"""Workspace-isolated RAG ingestion and retrieval with source evidence."""
from __future__ import annotations

import hashlib
import re
import uuid
from dataclasses import dataclass

from openai import OpenAI
from sqlalchemy import select
from sqlalchemy.orm import Session

from .config import get_settings
from .models import KnowledgeChunk, KnowledgeSource
from .prompt_security import appears_injected

CHUNK_SIZE = 1200
CHUNK_OVERLAP = 180


@dataclass(frozen=True)
class Citation:
    source_id: uuid.UUID
    source_name: str
    chunk_index: int
    excerpt: str
    content: str


def chunk_text(content: str) -> list[str]:
    clean = re.sub(r"\s+", " ", content).strip()
    if not clean:
        return []
    chunks, start = [], 0
    while start < len(clean):
        end = min(len(clean), start + CHUNK_SIZE)
        if end < len(clean):
            boundary = clean.rfind(". ", start, end)
            if boundary > start + CHUNK_SIZE // 2:
                end = boundary + 1
        chunks.append(clean[start:end])
        if end == len(clean):
            break
        start = max(end - CHUNK_OVERLAP, start + 1)
    return chunks


def _embed(inputs: list[str]) -> list[list[float]]:
    settings = get_settings()
    if not settings.openai_api_key:
        raise RuntimeError("Embeddings are not configured")
    response = OpenAI(api_key=settings.openai_api_key).embeddings.create(model=settings.embedding_model, input=inputs)
    return [item.embedding for item in response.data]


def ingest_text(db: Session, workspace_id: uuid.UUID, actor_id: uuid.UUID, name: str, content: str) -> tuple[KnowledgeSource, int]:
    digest = hashlib.sha256(content.encode()).hexdigest()
    source = db.scalar(select(KnowledgeSource).where(KnowledgeSource.workspace_id == workspace_id, KnowledgeSource.content_hash == digest))
    if source:
        return source, 0
    chunks = chunk_text(content)
    if not chunks:
        raise ValueError("Document contains no usable text")
    source = KnowledgeSource(workspace_id=workspace_id, name=name, content_hash=digest, created_by=actor_id)
    db.add(source)
    db.flush()
    vectors = _embed(chunks)
    db.add_all(KnowledgeChunk(workspace_id=workspace_id, source_id=source.id, chunk_index=index, content=chunk, embedding=vector) for index, (chunk, vector) in enumerate(zip(chunks, vectors, strict=True)))
    return source, len(chunks)


def retrieve(db: Session, workspace_id: uuid.UUID, query: str, limit: int = 5) -> list[Citation]:
    if appears_injected(query):
        return []
    vector = _embed([query])[0]
    distance = KnowledgeChunk.embedding.cosine_distance(vector).label("distance")
    rows = db.execute(
        select(KnowledgeChunk, KnowledgeSource, distance)
        .join(KnowledgeSource, KnowledgeSource.id == KnowledgeChunk.source_id)
        .where(KnowledgeChunk.workspace_id == workspace_id, KnowledgeSource.workspace_id == workspace_id)
        .order_by(distance)
        .limit(limit)
    ).all()
    return [Citation(source_id=source.id, source_name=source.name, chunk_index=chunk.chunk_index, excerpt=chunk.content[:240], content=chunk.content) for chunk, source, _ in rows if not appears_injected(chunk.content)]

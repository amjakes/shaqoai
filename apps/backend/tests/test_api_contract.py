from fastapi.testclient import TestClient

from src.main import app


client = TestClient(app)


def test_health_returns_versioned_service_status():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"
    assert response.headers["X-Request-ID"]


def test_workspace_endpoint_requires_authentication():
    response = client.get("/api/v1/workspaces")
    assert response.status_code == 401
    assert response.json()["error"] == "request_error"


def test_validation_errors_are_structured():
    response = client.post("/api/v1/auth/register", json={"email": "not-an-email"})
    assert response.status_code == 422
    assert response.json()["error"] == "validation_error"

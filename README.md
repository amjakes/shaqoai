# ShaqoAI

> **AI Workforce. Reimagined.**

ShaqoAI is an AI-powered workforce platform designed to help businesses automate repetitive operations, coordinate intelligent AI agents, and increase productivity while keeping humans in control of critical decisions.

The platform presents a modern enterprise SaaS experience focused on **AI workforce deployment, workflow automation, multi-agent coordination, business operations, and human-in-the-loop controls**.

---

## Overview

Traditional business operations often require employees to spend significant amounts of time on repetitive tasks such as:

- Customer support
- Administrative work
- Financial reconciliation
- Data processing
- Scheduling
- Follow-ups
- Reporting
- Workflow coordination

ShaqoAI is designed around the idea of deploying **AI agents as a digital workforce** that can execute these operational tasks while escalating sensitive decisions to humans when necessary.

### Core Vision

> Give every business access to an intelligent digital workforce.

ShaqoAI combines AI agents, workflow automation, business integrations, and human oversight into a unified platform.

---

## Key Features

### 🤖 Autonomous AI Workforce

Deploy specialized AI agents capable of handling different areas of business operations.

Examples include:

- Executive Secretary Agent
- Sales Agent
- Customer Support Agent
- Finance Agent
- Operations Agent

---

### 🔄 Multi-Agent Workflow Automation

Agents can coordinate workflows and hand tasks between specialized agents.

Example:

```text
Customer Inquiry
       ↓
Support Agent
       ↓
Intent Detection
       ↓
Finance Agent
       ↓
Payment Verification
       ↓
Human Approval
       ↓
Transaction Execution

## Installation

Follow the steps below to run ShaqoAI locally.

### Prerequisites

Make sure you have the following installed:

* **Python 3.10+**
* **Git**
* **Node.js 18+** *(if running the frontend)*

### 1. Clone the repository

```bash
git clone https://github.com/amjakes/shaqoai.git
cd shaqoai
```

### 2. Create a virtual environment

```bash
python -m venv .venv
```

Activate the virtual environment:

**Windows:**

```bash
.venv\Scripts\activate
```

**macOS / Linux:**

```bash
source .venv/bin/activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure environment variables

Create a `.env` file in the project root:

```env
OPENAI_API_KEY=your_api_key_here
```

Add any other environment variables required by your local configuration.

> **Never commit your `.env` file or API keys to GitHub.**

### 5. Run the application

Use the appropriate command for your project:

```bash
python main.py
```

If ShaqoAI includes a separate frontend, install its dependencies and start it according to the frontend configuration.

### Development

To verify your Python environment:

```bash
python --version
pip --version
```

To deactivate the virtual environment when finished:

```bash
deactivate
```

### Prerequisites

- Python 3.10 or newer
- Git
- An OpenAI API key

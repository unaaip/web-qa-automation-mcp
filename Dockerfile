FROM mcr.microsoft.com/playwright/python:v1.59.0-noble

WORKDIR /app
ENV PYTHONPATH=/app/src \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY requirements.txt pyproject.toml README.md ./
COPY src ./src
COPY reports ./reports

RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir -e .

EXPOSE 8000
CMD ["python", "-m", "web_qa_mcp_agent.server"]

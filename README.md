# Web QA MCP Agent

A production-style **Model Context Protocol (MCP) server** that uses Playwright to audit real websites from MCP Inspector or any MCP-compatible client.

This project is intentionally similar in spirit to browser automation MCP tools, but it is an original, portfolio-ready use case focused on **QA, SEO, accessibility and release validation**.

## What it does

- Opens real websites in Chromium with Playwright.
- Returns browser snapshots with title, status, links and page structure.
- Takes screenshots.
- Runs full QA audits.
- Checks SEO basics.
- Checks accessibility basics.
- Captures JavaScript console errors and failed requests.
- Compares two pages, useful for staging vs production.
- Runs browser journeys from JSON steps.
- Generates Markdown, JSON and HTML reports.
- Runs fully in Docker with MCP Inspector included.

## MCP tools

| Tool | Purpose |
| --- | --- |
| `browser_snapshot` | Open a URL and return title, status, page metadata and basic findings. |
| `screenshot_page` | Save a screenshot into `reports/`. |
| `audit_website` | Run full QA audit and write Markdown/JSON reports. |
| `audit_markdown_report` | Return a Markdown report directly in MCP Inspector. |
| `compare_two_pages` | Compare two URLs, useful for production vs staging. |
| `export_audit_schema` | Return the JSON schema of audit results. |
| `web_journey_tester` | Execute browser steps such as goto, click, fill, press and assertions. |
| `accessibility_quick_scan` | Browser-based accessibility quick scan. |
| `seo_audit` | Browser-based SEO scan. |
| `console_error_audit` | Capture browser console errors, page errors and failed requests. |
| `generate_audit_html_report` | Generate `reports/audit-report.html`. |
| `ai_web_audit` | Run the audit and ask an LLM to explain issues, business impact, risk and next actions. |
| `ai_audit_markdown_report` | Return a concise AI-generated Markdown report for GitHub/LinkedIn demos. |

## Run with Docker

```bash
cp .env.example .env
docker compose up --build
```

Open MCP Inspector:

```text
http://localhost:6274
```

Connect to the MCP server:

```text
Transport: Streamable HTTP
URL: http://web-qa-mcp-agent:8000/mcp
```

If you connect from a local MCP client outside Docker, use:

```text
http://localhost:8000/mcp
```

## Run without Docker

### 1. Create a virtual environment

```bash
python -m venv .venv
source .venv/bin/activate
```

On Windows:

```powershell
.venv\Scripts\activate
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
pip install -e .
playwright install --with-deps chromium
```

Or use Make:

```bash
make install
```

### 3. Run the MCP server

```bash
python -m web_qa_mcp_agent.server
```

Server URL:

```text
http://localhost:8000/mcp
```


## AI-powered QA analysis

This project includes an optional LLM layer so the MCP server can explain technical audit results like a senior QA engineer.

Configure your `.env`:

```env
LLM_PROVIDER=openai
OPENAI_API_KEY=sk-your-key
OPENAI_MODEL=gpt-4o-mini
OPENAI_TEMPERATURE=0.2
OPENAI_MAX_TOKENS=900
```

Then rebuild/restart Docker:

```bash
docker compose down
docker compose up --build
```

### AI audit example

Tool: `ai_web_audit`

```json
{
  "url": "https://www.wikipedia.org",
  "check_links": false,
  "write_report": true
}
```

It returns:

- raw QA audit data;
- AI-generated executive summary;
- business impact;
- prioritized recommendations;
- risk level;
- report paths under `reports/`.

Tool: `ai_audit_markdown_report`

```json
{
  "url": "https://www.python.org",
  "check_links": false
}
```

This is the best tool for a LinkedIn/GitHub demo because the output is already a readable Markdown report.

## Example tool calls

### Browser snapshot

```json
{
  "url": "https://example.com"
}
```

### Full audit

```json
{
  "url": "https://example.com",
  "check_links": true
}
```

### Browser journey

```json
{
  "steps": [
    {"action": "goto", "url": "https://example.com"},
    {"action": "expect_text", "text": "Example Domain"},
    {"action": "click", "selector": "text=More information"},
    {"action": "expect_url_contains", "value": "iana"},
    {"action": "screenshot", "path": "reports/journey.png"}
  ]
}
```

### Generate HTML report

```json
{
  "url": "https://example.com"
}
```

The report is written to:

```text
reports/audit-report.html
```

## Common Playwright Docker error

If you see an error like:

```text
BrowserType.launch: Executable doesn't exist
Looks like Playwright was just updated
```

it means the Playwright Python package and the Docker image version do not match.

This repo fixes that by pinning both to Playwright `1.59.0`:

```dockerfile
FROM mcr.microsoft.com/playwright/python:v1.59.0-noble
```

and:

```txt
playwright==1.59.0
```

Rebuild with no cache:

```bash
docker compose down
docker compose build --no-cache
docker compose up
```

## Test

```bash
make test
```

or:

```bash
pytest -v
```

## Portfolio pitch

> I built an AI-powered MCP server that lets an agent validate websites with real browser automation: screenshots, SEO, accessibility, console errors, link checks, performance signals, staging-vs-production comparison, journey testing and LLM-generated QA recommendations. It runs locally with Docker and MCP Inspector.

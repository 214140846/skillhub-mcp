# syntax=docker/dockerfile:1
FROM python:3.12-slim-bookworm AS base

FROM base AS builder

COPY --from=ghcr.io/astral-sh/uv:0.4.9 /uv /bin/uv

ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

WORKDIR /app

COPY uv.lock pyproject.toml /app/

RUN --mount=type=cache,target=/root/.cache/uv \
  uv sync --frozen --no-install-project --no-dev

COPY . /app

RUN --mount=type=cache,target=/root/.cache/uv \
  uv sync --frozen --no-dev

FROM base

COPY --from=builder /app /app

ENV PATH="/app/.venv/bin:$PATH"

# Create non-root user
RUN groupadd -r skillhub-mcp && useradd --no-log-init -r -g skillhub-mcp skillhub-mcp

# Change ownership to non-root user
RUN chown -R skillhub-mcp:skillhub-mcp /app

# Switch to non-root user
USER skillhub-mcp

# Expose port (default is 8000 for HTTP transport)
EXPOSE 8000

# Run the Skillhub MCP server, allow arguments to be passed at runtime
ENTRYPOINT ["python", "-m", "skillhub_mcp"]
# No CMD, so arguments can be passed via docker run

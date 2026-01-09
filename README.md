# Claude Agent

A Dockerized Claude Code environment with `mise` for dynamic language runtimes and GitHub authentication.

## Usage

### 1. Build & Push
```bash
docker build -t ghcr.io/YOUR_USER/claude-agent:latest .
docker push ghcr.io/YOUR_USER/claude-agent:latest
```

### 2. Run
```bash
docker run -it \
  -e ANTHROPIC_API_KEY="sk-..." \
  -e GITHUB_TOKEN="ghp_..." \
  -v mise_cache:/root/.local/share/mise \
  ghcr.io/YOUR_USER/claude-agent:latest
```


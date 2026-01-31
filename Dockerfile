FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. Set generic Git identity
RUN git config --global user.email "claude-agent@example.com" && \
    git config --global user.name "Claude Agent"

# 3. Install Node.js (Required to run Claude Code itself)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 4. Install Claude Code and mise
RUN npm install -g @anthropic-ai/claude-code
ENV MISE_INSTALL_PATH=/usr/local/bin/mise
RUN curl https://mise.run | sh

# 5. Configure PATH to prioritize mise-managed tools
ENV PATH="/root/.local/share/mise/shims:$PATH"

WORKDIR /app

# 6. Copy and configure entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

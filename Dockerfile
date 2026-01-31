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

# Create a non-root user
RUN useradd -m -s /bin/bash claude

# 4. Install Claude Code and mise
# Switch to non-root user
USER claude
WORKDIR /home/claude

# Configure npm to use a directory in the user's home for global packages
ENV NPM_CONFIG_PREFIX=/home/claude/.npm-global
ENV PATH=$NPM_CONFIG_PREFIX/bin:$PATH

RUN npm install -g @anthropic-ai/claude-code
ENV MISE_INSTALL_PATH=/home/claude/.local/bin/mise
RUN curl https://mise.run | sh

# 5. Configure PATH to prioritize mise-managed tools
ENV PATH="/home/claude/.local/share/mise/shims:$PATH"

WORKDIR /app

# 6. Copy and configure entrypoint
USER root
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
# Ensure the user owns the working directory
RUN chown claude:claude /app

USER claude
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

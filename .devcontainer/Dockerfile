FROM mcr.microsoft.com/devcontainers/cpp:ubuntu-22.04

# Install required packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    xorg-dev \
    libglfw3-dev \
    libsdl2-dev \
    libfreetype6-dev \ 
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with sudo access
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Clone and install emsdk (Emscripten SDK)
WORKDIR /
RUN git clone https://github.com/emscripten-core/emsdk.git \
    && cd /emsdk \
    && ./emsdk install latest \
    && ./emsdk activate latest

# Set up environment for Emscripten
ENV PATH="/emsdk:/emsdk/upstream/emscripten:${PATH}"
ENV EMSDK="/emsdk"

# Setup Emscripten cache directories with proper permissions
RUN mkdir -p /emsdk_cache /emsdk_node_modules
RUN chown ${USERNAME}:${USERNAME} /emsdk_cache /emsdk_node_modules /emsdk

# Set environment variables for Emscripten cache
ENV EM_CACHE=/emsdk_cache
ENV EM_CONFIG=/home/${USERNAME}/.emscripten
ENV EM_NODE_MODULES=/emsdk_node_modules
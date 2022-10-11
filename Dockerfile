FROM ubuntu:20.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
ENV VSTS_AGENT_VERSION 2.211.0
WORKDIR /azp/agent
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes \
  && DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common \
    libcurl4 \
    libicu66 \
    libunwind8 \
    netcat \
    libssl1.1 \
    zip \
    unzip \
  && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update && apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin \
  && set -x \
  && curl -fSL "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m`" -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose \
  && curl -LsS "https://vstsagentpackage.azureedge.net/agent/${VSTS_AGENT_VERSION}/vsts-agent-linux-x64-${VSTS_AGENT_VERSION}.tar.gz" | tar -xz & wait $! \
  && rm -rf /var/lib/apt/lists/*

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]

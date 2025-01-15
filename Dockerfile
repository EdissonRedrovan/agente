FROM ubuntu:22.04

RUN apt update
RUN apt upgrade -y
RUN apt install -y curl git jq libicu70 openjdk-21-jdk unzip wget

#Install Maven
RUN apt -y install maven

# Install Docker CLI and Docker Compose
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Instalar Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install Golang
RUN apt install -y golang-go

# Also can be "linux-arm", "linux-arm64", "linux-x64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Another option is to run the agent as root.
ENV AGENT_ALLOW_RUNASROOT="true"
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV JAVA_HOME_21_X64=${JAVA_HOME}
ENV GO=/usr/bin/go
ENV PYTHON=/usr/bin/python3
RUN export PATH
RUN export JAVA_HOME
RUN export JAVA_HOME_21_X64
RUN sed -i -e 's/\r$//' ./start.sh
ENTRYPOINT ./start.sh

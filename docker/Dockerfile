# Base image
FROM ubuntu:latest
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        ARCHITECTURE=amd64; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        ARCHITECTURE=arm64; \
    fi

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    wget \
    tzdata \
    lsb-release \
    gnupg \
    apt-transport-https \
    ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# Install ClickHouse
# RUN curl https://clickhouse.com/ | sh && ./clickhouse install && rm ./clickhouse
RUN curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | sudo gpg --dearmor -o /usr/share/keyrings/clickhouse-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb stable main" | sudo tee \
    /etc/apt/sources.list.d/clickhouse.list
RUN sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y clickhouse-server clickhouse-client && \
    sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# Install PostgreSQL
RUN sudo apt-get update && sudo apt-get install -y postgresql postgresql-contrib && \
    sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# Install Uptrace
RUN if [ "$(uname -m)" = "aarch64" ]; then \
        wget -qO /uptrace https://github.com/uptrace/uptrace/releases/download/v1.7.6/uptrace_linux_arm64; \
    else \
        wget -qO /uptrace https://github.com/uptrace/uptrace/releases/download/v1.7.6/uptrace_linux_amd64; \
    fi
RUN chmod +x /uptrace
COPY uptrace.yml /etc/uptrace/uptrace.yml

# Expose ports
EXPOSE 14317 14318

# Start the Uptrace service
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
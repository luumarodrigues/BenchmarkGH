# Dockerfile for benchmark-analyze GitHub Action
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl jq git && \
    rm -rf /var/lib/apt/lists/*

# Install Go 1.22.2 manually
RUN curl -LO https://go.dev/dl/go1.22.2.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz \
    && rm go1.22.2.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:$PATH"

# Install benchstat
RUN go install golang.org/x/perf/cmd/benchstat@latest && \
    cp /root/go/bin/benchstat /usr/local/bin/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Dockerfile for benchmark-analyze GitHub Action
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl jq golang-go git && \
    rm -rf /var/lib/apt/lists/*

# Install benchstat
RUN go install golang.org/x/perf/cmd/benchstat@latest && \
    cp /root/go/bin/benchstat /usr/local/bin/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

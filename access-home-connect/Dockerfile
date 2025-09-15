FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl jq ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install cloudflared
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# Add run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
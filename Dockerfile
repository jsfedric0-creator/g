FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Add Flussonic repository
RUN wget -q -O - http://debian.erlyvideo.org/binary/gpg.key | apt-key add - \
    && echo "deb http://debian.erlyvideo.org binary/" >> /etc/apt/sources.list

# Install Flussonic
RUN apt-get update && apt-get install -y flussonic

# Expose ports (HTTP/HTTPS/RTMP/RTSP)
EXPOSE 80 443 1935 554

# Start Flussonic
CMD ["/usr/bin/flussonic", "/etc/flussonic/flussonic.conf"]

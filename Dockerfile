# Use Debian as the base image (matching the installer)
FROM debian:bullseye-slim

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C
ENV PATH=/bin:/sbin:/usr/bin:/usr/sbin

# Install initial dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Copy and run the official installer script
COPY flussonic-installer.sh /tmp/flussonic-installer.sh
RUN chmod +x /tmp/flussonic-installer.sh && \
    /tmp/flussonic-installer.sh

# Create a minimal configuration file (essential!)
RUN mkdir -p /etc/flussonic && \
    echo "http 0.0.0.0:80;" > /etc/flussonic/flussonic.conf && \
    echo "stream test { input fake://fake; }" >> /etc/flussonic/flussonic.conf

# Expose the default Flussonic ports
EXPOSE 80 443 1935 554 8080

# Start command - find the correct binary
CMD ["sh", "-c", "exec $(which flussonic || find /usr -name flussonic -type f -executable | head -1) /etc/flussonic/flussonic.conf"]

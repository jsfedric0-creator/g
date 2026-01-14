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

# Create configuration directory
RUN mkdir -p /etc/flussonic

# Copy your configuration
COPY flussonic.conf /etc/flussonic/flussonic.conf

# Disable system optimization that fails in container
RUN sed -i '/ulimit -n/d' /opt/flussonic/bin/run \
    && sed -i '/sysctl/d' /opt/flussonic/bin/run \
    && sed -i '/rp_filter/d' /opt/flussonic/bin/run

# Set Erlang VM memory limits (CRITICAL)
ENV ERL_FLAGS="+K true +A 16 +MBas ageffcbf +MBl ageffcbf +MHl ageffcbf +MMs ageffcbf"
ENV FLUSSONIC_VM_ARGS="+K true +A 16 +MBas ageffcbf +MBl ageffcbf +MHl ageffcbf +MMs ageffcbf"

# Expose ports
EXPOSE 80 443 1935 554 8080

# Start Flussonic with minimal memory footprint
CMD ["/usr/bin/flussonic", "/etc/flussonic/flussonic.conf"]

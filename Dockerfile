FROM haproxy:2.3.6

ENV CONSUL_TEMPLATE_VERSION=0.25.2

ENV PIDFILE=/var/run/haproxy.pid

ENV HAPROXY_USER haproxy

# Create haproxy directoy so haproxy can hroot it later
RUN mkdir --parents /var/lib/${HAPROXY_USER} && \
  chown -R ${HAPROXY_USER}:${HAPROXY_USER} /var/lib/${HAPROXY_USER}

# Install WGET command
RUN apt update && apt install -y wget

# Download consul-template
RUN wget --no-check-certificate https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tgz \
  && tar xfz consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tgz \
  && mv consul-template /usr/bin/consul-template \
  && rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tgz

# Download and install  rsyslog
RUN apt-get install rsyslog -y
# Fix default configuration to run inside a container
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf
  
# Create directory for admin socket
RUN mkdir -p /var/run/haproxy

# Copy rsyslog haproxy configuration
ADD haproxy.conf /etc/rsyslog.d/haproxy.conf
# Copy haproxy skeleteon configuration to be used when initializing daemon
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
# Copy consul template configuration
COPY haproxy.hcl /tmp/haproxy.hcl
# Copy template to be used for generating haproxy configuration when consul services change
COPY haproxy.ctmpl /tmp/haproxy.ctmpl
# Copy reload script
COPY reload.sh /reload.sh

# Copy custom entrypoint
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

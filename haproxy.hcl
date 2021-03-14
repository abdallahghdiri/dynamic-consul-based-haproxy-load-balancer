template {
  source = "/tmp/haproxy.ctmpl" # the template
  destination = "/etc/haproxy/haproxy.cfg" # the generated file destination
  command = "/bin/sh /reload.sh" # the haproxy reload script
}
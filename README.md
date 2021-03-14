# A dynamic CONSUL based HAPROXY Load Balancer

This project aims to provide a drop in replacement for the [FABIO](https://github.com/fabiolb/fabio) load balancer using
HAPROXY in order to make use of its superior load balancing capabilities all while still being able to delegate service
discovery to CONSUL.

## How it works

We use a consul template service to query the consul server state and generate a new HAPROXY configuration file based on
a defined template. A pre-flight validation check is performed on the generated configuration file before the haproxy is
seamlessly reloaded (taking care of not losing requests in the process).

The generated configuration file uses the start of the path for each incoming request to route it to the appropriate
registered (and available) service.

To define which start of the query path is linked to each service we continue to make use of the service
tag `strip=[PATH_TO_STRIP]` used by FABIO, after properly identifying the backend service to use the start of the path
is stripped and HAPROXY takes care of load balancing between the different registered instances of this service, this
must be configured as needed in the configuration template to enable [affinity](https://www.haproxy.com/blog/load-balancing-affinity-persistence-sticky-sessions-what-you-need-to-know/) based load balancing strategy for example (something that is not possible with FABIO).

## DEMO

For this demo we use a docker compose file to launch a consul server, our dynamic haproxy load balancer and two basic
NGNIX web server instances that serve the same consul service `web-server`.

A separate docker one shot CLI service (`register_backend_services`) register the 2 NGINX instances in CONSUL (
named `web-server`) provoking the HAPROXY configuration file to be updated, and
a [hitless reload](https://www.haproxy.com/blog/truly-seamless-reloads-with-haproxy-no-more-hacks/) to be performed.

The following tag is defined with each service registry `strip=/web-server` so calling `http://localhost/web-server`
will make the load balancer forward the request to one of the two registered instance for `web-server`.

To setup the demo run the following command `docker-compose up -d`
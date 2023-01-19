# Coredns multistage docker build with the mysql external plugin

Specify coredns version from the [tags at coredns repo](https://github.com/coredns/coredns/tags).

Default is v1.10.0 override build with "--build-arg coredns_version=v1.9.4"

Example build:
```
docker build --build-arg coredns_version=v1.9.4 -t coredns .
```
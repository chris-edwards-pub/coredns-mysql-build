FROM golang:alpine AS builder
SHELL [ "/bin/sh", "-ec" ]

# Update alpine and install ca-certificates to copy to scratch coredns build below.
RUN apk update && apk add --no-cache git make ca-certificates

# Specify version from the tags at coredns repo.  https://github.com/coredns/coredns/tags
# Default is v1.10.0 override build with "--build-arg coredns_version=v1.9.4"
ARG coredns_version=v1.10.0
# Clone and build coredns from source and inclue the external mysql plugin.
RUN git clone https://github.com/coredns/coredns.git
WORKDIR /go/coredns
RUN git checkout ${coredns_version} ; \
    echo "mysql:github.com/cloud66-oss/coredns_mysql" >> /go/coredns/plugin.cfg ; \
    go get github.com/cloud66-oss/coredns_mysql ; \
    go generate ; \
    go build ; \
    ./coredns -version

FROM scratch

# Copy ca-certificates needed by coredns but not available in scratch.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/coredns/coredns /coredns

EXPOSE 53 53/udp
ENTRYPOINT ["/coredns"]
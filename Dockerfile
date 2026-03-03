FROM swift:5.3@sha256:eb5a806503f3a2abc5d2bd61d570cdb2222426c44764b2165420007fc289d74b as builder
WORKDIR /swiftdoc
COPY . .
RUN apt-get -qq update && apt-get install -y libxml2-dev graphviz-dev && rm -r /var/lib/apt/lists/*
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so* /build/lib
RUN make install prefix=/build

FROM ubuntu:18.04@sha256:152dc042452c496007f07ca9127571cb9c29697f42acbfad72324b2bb2e43c98
RUN apt-get -qq update && apt-get install -y graphviz-dev libatomic1 libxml2-dev libcurl4-openssl-dev && rm -r /var/lib/apt/lists/*
COPY --from=builder /build/bin/swift-doc /usr/bin
COPY --from=builder /build/lib/* /usr/lib/
ENTRYPOINT ["swift-doc"]
CMD ["--help"]


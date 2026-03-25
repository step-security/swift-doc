FROM swift:6.3@sha256:7f969657c95bd7c2054e3aeda04e0ac97341e129588c952a547fb7009ee2fc44 as builder
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


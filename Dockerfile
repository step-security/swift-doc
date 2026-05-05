FROM swift:5.3@sha256:eb5a806503f3a2abc5d2bd61d570cdb2222426c44764b2165420007fc289d74b as builder
WORKDIR /swiftdoc
COPY . .
RUN apt-get -qq update && apt-get install -y libxml2-dev graphviz-dev && rm -r /var/lib/apt/lists/*
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so* /build/lib
RUN make install prefix=/build

FROM ubuntu:26.04@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
RUN apt-get -qq update && apt-get install -y graphviz-dev libatomic1 libxml2-dev libcurl4-openssl-dev && rm -r /var/lib/apt/lists/*
COPY --from=builder /build/bin/swift-doc /usr/bin
COPY --from=builder /build/lib/* /usr/lib/
ENTRYPOINT ["swift-doc"]
CMD ["--help"]


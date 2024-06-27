ARG VERSION=3.2.0

FROM fiware/iotagent-json:${VERSION}

ARG VERSION=3.2.0

COPY lib/${VERSION}/commonBindings.js /opt/iotagent-json/lib/commonBindings.js
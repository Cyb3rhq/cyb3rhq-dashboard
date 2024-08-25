# Usage: docker build --build-arg NODE_VERSION=18.19.0 --build-arg CYB3RHQ_DASHBOARDS_BRANCH=4.10.0 --build-arg CYB3RHQ_DASHBOARDS_PLUGINS=4.10.0 --build-arg CYB3RHQ_SECURITY_DASHBOARDS_PLUGIN_BRANCH=4.10.0 --build-arg OPENSEARCH_DASHBOARDS_VERSION=2.13.0 -t wzd:4.10.0 -f cyb3rhq-dashboard.Dockerfile .

ARG NODE_VERSION
FROM node:${NODE_VERSION} AS base
ARG OPENSEARCH_DASHBOARDS_VERSION
ARG CYB3RHQ_DASHBOARDS_BRANCH
ARG CYB3RHQ_DASHBOARDS_PLUGINS
ARG CYB3RHQ_SECURITY_DASHBOARDS_PLUGIN_BRANCH
ENV OPENSEARCH_DASHBOARDS_VERSION=${OPENSEARCH_DASHBOARDS_VERSION}
USER root
RUN apt-get update && apt-get install -y git zip unzip curl brotli jq
USER node
RUN git clone --depth 1 --branch ${CYB3RHQ_DASHBOARDS_BRANCH} https://github.com/cyb3rhq/cyb3rhq-dashboard.git /home/node/wzd
RUN chown node.node /home/node/wzd

WORKDIR /home/node/wzd
RUN yarn osd bootstrap --production
RUN yarn build --linux --skip-os-packages --release


WORKDIR /home/node/wzd/plugins
RUN git clone --depth 1 --branch ${CYB3RHQ_SECURITY_DASHBOARDS_PLUGIN_BRANCH} https://github.com/cyb3rhq/cyb3rhq-security-dashboards-plugin.git
RUN git clone --depth 1 --branch ${CYB3RHQ_DASHBOARDS_PLUGINS} https://github.com/cyb3rhq/cyb3rhq-dashboard-plugins.git
WORKDIR /home/node/wzd/plugins/cyb3rhq-security-dashboards-plugin
RUN yarn
RUN yarn build
WORKDIR /home/node/wzd/plugins
RUN mv ./cyb3rhq-dashboard-plugins/plugins/main ./cyb3rhq
RUN mv ./cyb3rhq-dashboard-plugins/plugins/cyb3rhq-core ./cyb3rhq-core
RUN mv ./cyb3rhq-dashboard-plugins/plugins/cyb3rhq-check-updates ./cyb3rhq-check-updates
WORKDIR /home/node/wzd/plugins/cyb3rhq
RUN yarn
RUN yarn build
WORKDIR /home/node/wzd/plugins/cyb3rhq-core
RUN yarn
RUN yarn build
WORKDIR /home/node/wzd/plugins/cyb3rhq-check-updates
RUN yarn
RUN yarn build
WORKDIR /home/node/
RUN mkdir packages
WORKDIR /home/node/packages
RUN zip -r -j ./dashboard-package.zip ../wzd/target/opensearch-dashboards-${OPENSEARCH_DASHBOARDS_VERSION}-linux-x64.tar.gz
RUN zip -r -j ./security-package.zip ../wzd/plugins/cyb3rhq-security-dashboards-plugin/build/security-dashboards-${OPENSEARCH_DASHBOARDS_VERSION}.0.zip
RUN zip -r -j ./cyb3rhq-package.zip ../wzd/plugins/cyb3rhq-check-updates/build/cyb3rhqCheckUpdates-${OPENSEARCH_DASHBOARDS_VERSION}.zip ../wzd/plugins/cyb3rhq/build/cyb3rhq-${OPENSEARCH_DASHBOARDS_VERSION}.zip ../wzd/plugins/cyb3rhq-core/build/cyb3rhqCore-${OPENSEARCH_DASHBOARDS_VERSION}.zip
WORKDIR /home/node/wzd/dev-tools/build-packages/base
RUN ./generate_base.sh -v 4.10.0 -r 1 -a file:///home/node/packages/cyb3rhq-package.zip -s file:///home/node/packages/security-package.zip -b file:///home/node/packages/dashboard-package.zip
WORKDIR /home/node/wzd/dev-tools/build-packages/base/output
RUN cp ./* /home/node/packages/


FROM node:${NODE_VERSION}
USER node
COPY --chown=node:node --from=base /home/node/wzd /home/node/wzd
COPY --chown=node:node --from=base /home/node/packages /home/node/packages
WORKDIR /home/node/wzd

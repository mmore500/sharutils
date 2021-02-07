# Pull base image.
FROM ubuntu:bionic-20180125@sha256:d6f6cc62b6bed64387d84ca227b76b9cc45049b0d0aefee0deec21ed19a300bf

SHELL ["/bin/bash", "-c"]

# Prevent interactive time zone config.
# adapted from https://askubuntu.com/a/1013396
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  echo 'Acquire::http::Timeout "60";' >> "/etc/apt/apt.conf.d/99timeout" \
    && \
  echo 'Acquire::ftp::Timeout "60";' >> "/etc/apt/apt.conf.d/99timeout" \
    && \
  echo 'Acquire::Retries "100";' >> "/etc/apt/apt.conf.d/99timeout" \
    && \
  echo "buffed apt-get resiliency"

RUN \
  find /etc/apt -type f -name '*.list' -exec sed -i 's/\(^deb.*-backports.*\)/#\1/; s/\(^deb.*-updates.*\)/#\1/; s/\(^deb.*-proposed.*\)/#\1/; s/\(^deb.*-security.*\)/#\1/' {} + \
    && \
  rm -rf /var/lib/apt/lists/* \
    && \
  echo "removed -backports, -updates, -proposed, -security repositories"

RUN \
  apt-get update -qq \
    && \
  apt-get install sharutils \
    && \
  apt-get clean \
    && \
  rm -rf /var/lib/apt/lists/* \
    && \
  echo "installed sharutils"

CMD ["bash"]

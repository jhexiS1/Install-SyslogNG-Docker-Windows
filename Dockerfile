FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl gnupg net-tools wget sudo && \
    wget -qO - https://ose-repo.syslog-ng.com/apt/syslog-ng-ose-pub.asc | apt-key add - && \
    echo "deb https://ose-repo.syslog-ng.com/apt/ nightly ubuntu-jammy" > /etc/apt/sources.list.d/syslog-ng-ose.list && \
    apt-get update && \
    apt-get install -y syslog-ng syslog-ng-mod-http && \
    mkdir -p /etc/syslog-ng/conf.d

COPY sentinelone.conf /etc/syslog-ng/conf.d/sentinelone.conf

EXPOSE 514/udp

CMD ["syslog-ng", "-F", "--no-caps"]

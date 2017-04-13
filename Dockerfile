FROM centos:7
MAINTAINER Horatiu Eugen Vlad <info@vlad.eu>

RUN yum install -y epel-release && \
    yum -y install java-1.8.0-openjdk.x86_64 nss_wrapper && \
    yum clean all

COPY logstash.repo /etc/yum.repos.d/logstash.repo

ENV USER logstash
ENV HOME /var/lib/logstash
ENV PATH /var/lib/logstash/bin:$PATH
ENV LOGSTASH_VERSION 2.3.4-1
ENV LOGSTASH_CONF_DIR /etc/logstash/conf.d

RUN yum -y install logstash-${LOGSTASH_VERSION} && \
    yum clean all

COPY passwd.in ${HOME}/
COPY entrypoint /

RUN for path in /var/lib/logstash /var/log/logstash ${LOGSTASH_CONF_DIR}; do \
      mkdir -p "$path" && chmod -R ug+rwX "$path" && chown -R $USER:root "$path"; \
    done
USER 1000

ENTRYPOINT ["/entrypoint"]
CMD ["logstash -f ${LOGSTASH_CONF_DIR}"]

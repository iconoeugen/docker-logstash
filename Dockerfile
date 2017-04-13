FROM centos:7
MAINTAINER Horatiu Eugen Vlad <info@vlad.eu>

RUN yum install -y epel-release && \
    yum -y install curl nss_wrapper java-1.8.0-openjdk.x86_64 && \
    yum clean all
ENV JAVACMD /usr/bin/java

ENV USER logstash
ENV HOME /usr/share/logstash
ENV PATH /usr/share/logstash/bin:$PATH
ENV LS_VERSION 1:5.3.0-1
ENV LS_INIT_DIR /etc/logstash/init.d
ENV LS_CONF_DIR /etc/logstash/conf.d

COPY logstash.repo /etc/yum.repos.d/logstash.repo
RUN yum -y install logstash-${LS_VERSION}.noarch && \
    yum clean all

COPY passwd.in ${HOME}/
COPY entrypoint /

RUN for path in /var/lib/logstash /var/log/logstash ${HOME} ${LS_CONF_DIR} ${LS_INIT_DIR}; do \
      mkdir -p "$path" && chmod -R ug+rwX "$path" && chown -R $USER:root "$path"; \
    done
USER 1000

ENTRYPOINT ["/entrypoint"]
CMD logstash -f ${LS_CONF_DIR}

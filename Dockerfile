FROM python:3.5.2

MAINTAINER Tunde Alkemade <tundealkemade@godatadriven.com>

RUN update-ca-certificates -f \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
    wget \
    git \
  && apt-get clean \
  && git config --global http.sslverify false

ENV GIT_SSL_NO_VERIFY=false

# Java
RUN cd /opt/ \
  && wget \
    --no-cookies \
    --no-check-certificate \
    --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz" \
    -O jdk-8.tar.gz \
  && tar xzf jdk-8.tar.gz \
  && rm jdk-8.tar.gz \
  && update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_161/bin/java 100 \
  && update-alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_161/bin/jar 100 \
  && update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_161/bin/javac 100

# SPARK
ADD spark-1.6.3-bin-hive.tgz /opt/
RUN cd /opt/ \
 && ln -s /opt/spark-1.6.3-bin-hive /opt/spark

ENV SPARK_HOME /opt/spark
ENV PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.9-src.zip:$SPARK_HOME/python/:$PYTHONPATH

RUN mkdir -p /usr/spark/work/ \
  && chmod -R 777 /usr/spark/work/

RUN pip install --upgrade pip \
  && pip install pipenv 

ENV SPARK_MASTER_PORT 7077

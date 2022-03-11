#FROM integralsw/osa-python:11.1-16-g88c002b7-20210507-170349-refcat-43.0-heasoft-6.28-python-3.8.2
FROM integralsw/osa-python:11.1-16-g88c002b7-20210507-170349-refcat-43.0-heasoft-6.25-python-3.8.2
#FROM integralsw/osa-python:11.1-3-g87cee807-20200410-144247-refcat-42.0-heasoft-6.26.1-python-3.6.9


# also add osa10.2

RUN mkdir -pv /osa10.2 && \
    curl -q https://www.isdc.unige.ch/integral/download/osa/sw/10.2/osa10.2-bin-linux64-CentOS7.tar.gz | tar xzf - -C /opt/

ADD init.sh /init.sh

RUN cat -n /init.sh && source /init.sh && export

RUN cat /init.sh >> /init-osa10.2.sh && \
    echo "export OSA_VERSION=10.2" >> /init-osa10.2.sh && \
    echo "export CONTAINER_COMMIT=$CONTAINER_COMMIT" >> /init-osa10.2.sh && \
    echo "export ISDC_ENV=/opt/osa10.2" >> /init-osa10.2.sh && \
    echo "source /opt/osa10.2/bin/isdc_init_env.sh" >> /init-osa10.2.sh


# additional software

ENV HOME_OVERRRIDE=/tmp/home

RUN . /init.sh; pip install --upgrade pip; pip install wheel

ADD requirements.txt /requirements.txt
RUN . /init.sh; pip install -r /requirements.txt --upgrade

ADD dda-interface-app /dda-interface-app
RUN . /init.sh; pip install /dda-interface-app

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh

RUN echo "export OSA_VERSION=$OSA_VERSION" >> /init.sh
RUN echo "export CONTAINER_COMMIT=$CONTAINER_COMMIT" >> /init.sh

#RUN export HOME=/tmp; id; source /osa_init.sh; python -c 'import yaml, collections; yaml.load(yaml.dump(collections.OrderedDict()))'

#ENV DDA_QUEUE /data/ddcache/queue

ADD bootstrap-data.sh /bootstrap-data.sh

RUN . /init.sh; pip install git+https://github.com/volodymyrss/dda-ddosadm.git@63d4d1c

#ADD etc-passwd /etc/passwd
RUN echo 'oda:x:1000:1000:ODA runner:/tmp/:/bin/bash' >> /etc/passwd

ADD worker-knowledge-osa11.0.yaml /worker-knowledge-osa11.0.yaml
ADD worker-knowledge-osa10.2.yaml /worker-knowledge-osa10.2.yaml

RUN . /init.sh; pip install --upgrade git+https://github.com/volodymyrss/data-analysis@31403a5
RUN . /init.sh; pip install -U numpy

RUN yum install -y bind-utils

RUN . /init.sh; pip install git+https://github.com/volodymyrss/dda-rangequery@staging-1-3


RUN . /init.sh; pip install jsonschema\<4.0

#!/bin/bash

export WORKDIR=${SCRATCH_BASE:-}/scratch/$HOSTNAME/

mkdir -pv ${SCRATCH_BASE:-}/scratch/$HOSTNAME/
mkdir -pv ${SCRATCH_BASE:-}/var/log/containers/

mkdir -pv $WORKDIR/tmp-home

export HOME_OVERRRIDE=$WORKDIR/tmp-home

#source /init-osa10.2.sh
source /init.sh
#sh setup_curlftpfs.sh

# local osa-specific

CURRENT_IC=/data/rep_base_prod
INTEGRAL_DATA=/data/rep_base_prod
REP_BASE_PROD=/data/rep_base_prod

# 

set -x

cd $HOME

#cp -fvr  /data/resources /data/rep_base_prod/resources

export COMMON_INTEGRAL_SOFTDIR=$HOME/software/
export PYTHONUNBUFFERED=0
export DISPLAY=""

#export CONTAINER_NAME=`python get_docker_name.py`
export CONTAINER_NAME=$HOSTNAME


[ "$MATTERMOST_CHANNEL" == "" ] || (echo "starting backend master $CONTAINER_NAME " | mattersend  -U `cat ~/.mattermost-hook` -c $MATTERMOST_CHANNEL)

#sh choose_proxy.sh

cd $WORKDIR

export PFILES="$PWD/pfiles;${PFILES##*;}"

mkdir -pv $PWD/pfiles

##

if [ "${DDA_BOOTSTRAP_DATA:-no}" == "yes" ]; then
    echo -e '\033[31m requested to bootstrap data \033[0m'
    bash /bootstrap-data.sh
fi

##


#ln -s /osa  /home/integral/osa

echo "worker mode: $WORKER_MODE"
if [ "$WORKER_MODE" == "interface" ]; then
#resttimesystem.sh > /host_var/log/resttimesystem.log 2>&1
    while true; do
        echo "interface worker starting"
        DISPLAY="" gunicorn --workers 4 --timeout 600  --log-level debug -b 0.0.0.0:8000 ddaworker.service:app 2>&1 
        echo "worker dead: restarting"
        sleep 1
    done | tee -a ${SCRATCH_BASE:-}/var/log/containers/${CONTAINER_NAME}
else
    while true; do
        echo "passive worker starting"


        (
            source /init.sh
            DISPLAY="" python -m dataanalysis.caches.queue -B 2 -t 36000 $DDA_QUEUE -k /worker-knowledge-osa11.0.yaml 2>&1
        )

        (
            source /init-osa10.2.sh
            DISPLAY="" python -m dataanalysis.caches.queue -B 2 -t 36000 $DDA_QUEUE -k /worker-knowledge-osa10.2.yaml 2>&1
        )

        echo "worker dead: restarting"
        sleep 1
    done | tee -a ${SCRATCH_BASE:-}/var/log/containers/${CONTAINER_NAME}
fi



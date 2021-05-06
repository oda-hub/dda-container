export HOME=${HOME_OVERRRIDE:-/home/integral}

export HEADAS=/opt/heasoft/x86_64-pc-linux-gnu-libc2.17/

[ -s $HEADAS/headas-init.sh ] && 
    . $HEADAS/headas-init.sh

export REP_BASE_PROD=/isdc/arc/rev_3
export ISDC_REF_CAT=${REP_BASE_PROD}/cat/hec/gnrl_refr_cat_0042.fits #TODO: use a variable, substitute from build time
export ISDC_OMC_CAT=${REP_BASE_PROD}/cat/omc/omc_refr_cat_0005.fits

export ISDC_ENV=/opt/osa

[ -s $ISDC_ENV/bin/isdc_init_env.sh ] && 
    source $ISDC_ENV/bin/isdc_init_env.sh

[ -s /opt/root/bin/thisroot.sh ] && 
    source /opt/root/bin/thisroot.sh


source /etc/pyenvrc
export HEADAS="/opt/heasoft/x86_64-pc-linux-gnu-libc2.17/"; source $HEADAS/headas-init.sh

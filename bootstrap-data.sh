echo -e '\033[31will download some semi-static data!\033[0m'

set -xe

mkdir -pv /data/ic_collection/default-isdc 

rsync -Lzrtv isdcarc.unige.ch::arc/FTP/arc_distr/ic_tree/prod/ /data/ic_collection/default-isdc

mkdir -pv /data/rep_base_prod/cat/hec/
wget -q -O- https://www.isdc.unige.ch/integral/catalog/43/gnrl_refr_cat_0043.fits.gz | gunzip - > /data/rep_base_prod/cat/hec/gnrl_refr_cat_0043.fits


mkdir -pv /data/rep_base_prod/{scw,aux}

mkdir -pv /data/rep_base_prod/aux/adp/ref/

rsync -lrtv  --exclude \*txt isdcarc.unige.ch::arc/FTP/arc_distr/NRT/public/aux/adp/ref/ /data/rep_base_prod/aux/adp/ref/

echo -e '\033[31will download some semi-static data!\033[0m'

set -xe

mkdir -pv /data/ic_collection/default-isdc 

rsync -Lzrtv isdcarc.unige.ch::arc/FTP/arc_distr/ic_tree/prod/ /data/ic_collection/default-isdc

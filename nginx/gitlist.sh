mkdir /home/app/web/gitlist
cd /home/app/web/gitlist || exit

wget "https://github.com/klaussilveira/gitlist/releases/download/2.0.0/gitlist-2.0.0.zip"
unzip gitlist-2.0.0.zip
# cp  ./config ./config
git config --global --add safe.directory /home/app/web/config_backup


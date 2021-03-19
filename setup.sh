#!/bin/bash
app_name="plexaria"
version="v. 0.1"
created_by="@thedevofthings"

#welcome
echo "------------------------------------------"
echo "            __                    _       "
echo "    ____  / /__  _  ______ ______(_)___ _ "
echo "   / __ \/ / _ \| |/_/ __  / ___/ / __  / "
echo "  / /_/ / /  __/>  </ /_/ / /  / / /_/ /  "
echo " / .___/_/\___/_|_|\__,_/__/  /_/\__,_/   "
echo "/_/                                       "

echo $version
echo "by" $created_by
echo "-----------------------------------------"
sleep 1

#download required packages and other stuff
echo -e "\033[31mupdate package list and get rclone and docker"
sleep 1
apt update -y
apt install rclone docker.io -y
docker pull linuxserver/plex
docker pull linuxserver/letsencrypt
docker pull jlesage/jdownloader-2
docker pull nextcloud:stable-apache

#create essential media folders
echo -e "\033[31mcreating media folders"
sleep 1
dir_downloads="/media/downloads"
dir_gdrive="/media/gdrive"
dir_gmovies="/media/gdrive/gMovies"
dir_gseries="/media/gdrive/gSeries"
[ ! -d $dir_downloads ] && mkdir -p $dir_downloads
[ ! -d $dir_gdrive ] && mkdir -p $dir_gdrive
[ ! -d $dir_gmovies ] && mkdir -p $dir_gmovies
[ ! -d $dir_gseries ] && mkdir -p $dir_gseries

#setup gdrive via rclone
rclone config create "gdrive" "drive" config_is_local "false"

echo -e "\033[31myou need to provide two passwords to encrypt your files on gdrive"
echo -e "\033[32mplease provide the first password and press [ENTER]:"
read first_password
echo -e "\033[32mplease provide the second password and press [ENTER]:"
read second_password

echo -e "\033[31mfirst password:" $first_password
echo -e "\033[31msecond password:" $second_password
echo -e "\033[37mmake sure that you don't lose these passwords!"
sleep 1

rclone config create "gcrypt" "crypt" remote "gdrive:" filename_encryption "standard" directory_name_encryption "true" password $first_password password2 $second_password

echo -e "\033[37mdone."

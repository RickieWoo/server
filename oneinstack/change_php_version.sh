#!/bin/bash
# Author:  yeho <lj2007331 AT gmail.com>
# BLOG:  https://blog.linuxeye.com
#
# Notes: OneinStack for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+
#
# Project home page:
#       https://oneinstack.com
#       https://github.com/lj2007331/oneinstack

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear
printf "
#######################################################################
#       OneinStack for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+      #
#                       Change your PHP version                       #
#       For more information please visit https://oneinstack.com      #
#######################################################################
"

. ./include/color.sh

echo
OLD_PHP_version=`/usr/local/php/bin/php -r 'echo PHP_VERSION;'`
echo "Current PHP Version: ${CMSG}${OLD_PHP_version%.*}${CEND}"

while :; do echo
  echo 'Please select a version of the PHP:'
  echo -e "\t${CMSG}1${CEND}. php-5.3"
  echo -e "\t${CMSG}2${CEND}. php-5.4"
  echo -e "\t${CMSG}3${CEND}. php-5.5"
  echo -e "\t${CMSG}4${CEND}. php-5.6"
  echo -e "\t${CMSG}5${CEND}. php-7.0"
  echo -e "\t${CMSG}6${CEND}. php-7.1"
  read -p "Please input a number:(Default 2 press Enter) " PHP_VERSION
  [ -z "$PHP_VERSION" ] && PHP_VERSION=2
  if [[ ! $PHP_VERSION =~ ^[1-6]$ ]];then
    echo "${CWARNING}input error! Please only input number 1,2,3,4,5,6${CEND}"
  else
    break
  fi
done

if [ -e "/etc/init.d/php-fpm" ];then
  if [ "$PHP_VERSION" == '1' ];then
    [ "${OLD_PHP_version%.*}" == '5.3' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    /etc/init.d/php-fpm stop;rm -rf /usr/local/php
    ln -s /usr/local/php53 /usr/local/php
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php53@' options.conf
    /etc/init.d/php-fpm start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}5.3${CEND}"
    echo
  elif [ "$PHP_VERSION" == '2' ];then
    [ "${OLD_PHP_version%.*}" == '5.4' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    /etc/init.d/php-fpm stop;rm -rf /usr/local/php
    ln -s /usr/local/php54 /usr/local/php
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php54@' options.conf
    /etc/init.d/php-fpm start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}5.4${CEND}"
    echo
  elif [ "$PHP_VERSION" == '3' ];then
    [ "${OLD_PHP_version%.*}" == '5.5' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    /etc/init.d/php-fpm stop;rm -rf /usr/local/php
    ln -s /usr/local/php55 /usr/local/php
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php55@' options.conf
    /etc/init.d/php-fpm start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}5.5${CEND}"
    echo
  elif [ "$PHP_VERSION" == '4' ];then
    [ "${OLD_PHP_version%.*}" == '5.6' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    /etc/init.d/php-fpm stop;rm -rf /usr/local/php
    ln -s /usr/local/php56 /usr/local/php
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php56@' options.conf
    /etc/init.d/php-fpm start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}5.6${CEND}"
    echo
  elif [ "$PHP_VERSION" == '5' ];then
    [ "${OLD_PHP_version%.*}" == '7.0' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    /etc/init.d/php-fpm stop;rm -rf /usr/local/php
    ln -s /usr/local/php70 /usr/local/php
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php70@' options.conf
    /etc/init.d/php-fpm start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}7.0${CEND}"
    echo
  elif [ "$PHP_VERSION" == '6' ];then
    [ "${OLD_PHP_version%.*}" == '7.1' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    /etc/init.d/php-fpm stop;rm -rf /usr/local/php
    ln -s /usr/local/php71 /usr/local/php
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php71@' options.conf
    /etc/init.d/php-fpm start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}7.1${CEND}"
    echo
  fi
else
  if [ "$PHP_VERSION" == '1' ];then
    [ "${OLD_PHP_version%.*}" == '5.3' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    rsync -crazP --delete /usr/local/apache/conf/vhost /usr/local/apache53/conf > /dev/null 2>&1
    /etc/init.d/httpd stop;rm -rf /usr/local/{apache,php}
    ln -s /usr/local/apache53 /usr/local/apache
    ln -s /usr/local/php53 /usr/local/php
    sed -i 's@apache_install_dir=.*@apache_install_dir=/usr/local/apache53@' options.conf
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php53@' options.conf
    /etc/init.d/httpd start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}5.3${CEND}"
    echo
  elif [ "$PHP_VERSION" == '2' ];then
    [ "${OLD_PHP_version%.*}" == '5.4' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    rsync -crazP --delete /usr/local/apache/conf/vhost /usr/local/apache54/conf > /dev/null 2>&1
    /etc/init.d/httpd stop;rm -rf /usr/local/{apache,php}
    ln -s /usr/local/apache54 /usr/local/apache
    ln -s /usr/local/php54 /usr/local/php
    sed -i 's@apache_install_dir=.*@apache_install_dir=/usr/local/apache54@' options.conf
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php54@' options.conf
    /etc/init.d/httpd start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}5.4${CEND}"
    echo
  elif [ "$PHP_VERSION" == '3' ];then
    [ "${OLD_PHP_version%.*}" == '5.5' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    rsync -crazP --delete /usr/local/apache/conf/vhost /usr/local/apache55/conf > /dev/null 2>&1
    /etc/init.d/httpd stop;rm -rf /usr/local/{apache,php}
    ln -s /usr/local/apache55 /usr/local/apache
    ln -s /usr/local/php55 /usr/local/php
    sed -i 's@apache_install_dir=.*@apache_install_dir=/usr/local/apache55@' options.conf
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php55@' options.conf
    /etc/init.d/httpd start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}5.5${CEND}"
    echo
  elif [ "$PHP_VERSION" == '4' ];then
    [ "${OLD_PHP_version%.*}" == '5.6' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    rsync -crazP --delete /usr/local/apache/conf/vhost /usr/local/apache56/conf > /dev/null 2>&1
    /etc/init.d/httpd stop;rm -rf /usr/local/{apache,php}
    ln -s /usr/local/apache56 /usr/local/apache
    ln -s /usr/local/php56 /usr/local/php
    sed -i 's@apache_install_dir=.*@apache_install_dir=/usr/local/apache56@' options.conf
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php56@' options.conf
    /etc/init.d/httpd start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}5.6${CEND}"
    echo
  elif [ "$PHP_VERSION" == '5' ];then
    [ "${OLD_PHP_version%.*}" == '7.0' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    rsync -crazP --delete /usr/local/apache/conf/vhost /usr/local/apache70/conf > /dev/null 2>&1
    /etc/init.d/httpd stop;rm -rf /usr/local/{apache,php}
    ln -s /usr/local/apache70 /usr/local/apache
    ln -s /usr/local/php70 /usr/local/php
    sed -i 's@apache_install_dir=.*@apache_install_dir=/usr/local/apache70@' options.conf
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php70@' options.conf
    /etc/init.d/httpd start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}7.0${CEND}"
    echo
  elif [ "$PHP_VERSION" == '6' ];then
    [ "${OLD_PHP_version%.*}" == '7.1' ] && { echo "${CWARNING}The version you entered is the same as the current version${CEND}"; exit 1; }
    rsync -crazP --delete /usr/local/apache/conf/vhost /usr/local/apache71/conf > /dev/null 2>&1
    /etc/init.d/httpd stop;rm -rf /usr/local/{apache,php}
    ln -s /usr/local/apache71 /usr/local/apache
    ln -s /usr/local/php71 /usr/local/php
    sed -i 's@apache_install_dir=.*@apache_install_dir=/usr/local/apache71@' options.conf
    sed -i 's@php_install_dir=.*@php_install_dir=/usr/local/php71@' options.conf
    /etc/init.d/httpd start
    echo
    echo "You have ${CMSG}successfully${CEND} changed to ${CMSG}7.1${CEND}"
    echo
  fi
fi

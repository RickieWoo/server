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
#                     Setup the backup parameters                     #
#       For more information please visit https://oneinstack.com      #
#######################################################################
"

. ./options.conf
. ./include/color.sh
. ./include/check_dir.sh

# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

while :; do echo
  echo 'Please select your backup destination:'
  echo -e "\t${CMSG}1${CEND}. Only Localhost"
  echo -e "\t${CMSG}2${CEND}. Only Remote host"
  echo -e "\t${CMSG}3${CEND}. Only Aliyun oss"
  echo -e "\t${CMSG}4${CEND}. Localhost and Remote host"
  echo -e "\t${CMSG}5${CEND}. Localhost and Aliyun oss"
  echo -e "\t${CMSG}6${CEND}. Remote host and Aliyun oss"
  read -p "Please input a number:(Default 1 press Enter) " DESC_BK 
  [ -z "$DESC_BK" ] && DESC_BK=1
  if [[ ! $DESC_BK =~ ^[1-6]$ ]];then 
    echo "${CWARNING}input error! Please only input number 1,2,3,4,5,6${CEND}"
  else
    break
  fi
done

[ "$DESC_BK" == '1' ] && sed -i 's@^backup_destination=.*@backup_destination=local@' ./options.conf
[ "$DESC_BK" == '2' ] && sed -i 's@^backup_destination=.*@backup_destination=remote@' ./options.conf
[ "$DESC_BK" == '3' ] && sed -i 's@^backup_destination=.*@backup_destination=oss@' ./options.conf
[ "$DESC_BK" == '4' ] && sed -i 's@^backup_destination=.*@backup_destination=local,remote@' ./options.conf
[ "$DESC_BK" == '5' ] && sed -i 's@^backup_destination=.*@backup_destination=local,oss@' ./options.conf
[ "$DESC_BK" == '6' ] && sed -i 's@^backup_destination=.*@backup_destination=Remote,oss@' ./options.conf

while :; do echo
  echo 'Please select your backup content:'
  echo -e "\t${CMSG}1${CEND}. Only Database"
  echo -e "\t${CMSG}2${CEND}. Only Website"
  echo -e "\t${CMSG}3${CEND}. Database and Website"
  read -p "Please input a number:(Default 1 press Enter) " CONTENT_BK
  [ -z "$CONTENT_BK" ] && CONTENT_BK=1
  if [[ ! $CONTENT_BK =~ ^[1-3]$ ]];then 
    echo "${CWARNING}input error! Please only input number 1,2,3${CEND}"
  else
    break
  fi
done

[ "$CONTENT_BK" == '1' ] && sed -i 's@^backup_content=.*@backup_content=db@' ./options.conf
[ "$CONTENT_BK" == '2' ] && sed -i 's@^backup_content=.*@backup_content=web@' ./options.conf
[ "$CONTENT_BK" == '3' ] && sed -i 's@^backup_content=.*@backup_content=db,web@' ./options.conf

if [ "$DESC_BK" != '3' ];then 
  while :; do echo
    echo "Please enter the directory for save the backup file: "
    read -p "(Default directory: $backup_dir): " NEW_backup_dir 
    [ -z "$NEW_backup_dir" ] && NEW_backup_dir="$backup_dir"
    if [ -z "`echo $NEW_backup_dir| grep '^/'`" ]; then
      echo "${CWARNING}input error! ${CEND}"
    else
      break
    fi
  done
  sed -i "s@^backup_dir=.*@backup_dir=$NEW_backup_dir@" ./options.conf
fi

while :; do echo
  echo "Pleas enter a valid backup number of days: "
  read -p "(Default days: 5): " expired_days 
  [ -z "$expired_days" ] && expired_days=5
  [ -n "`echo $expired_days | sed -n "/^[0-9]\+$/p"`" ] && break || echo "${CWARNING}input error! Please only enter numbers! ${CEND}"
done
sed -i "s@^expired_days=.*@expired_days=$expired_days@" ./options.conf

if [ "$CONTENT_BK" != '2' ];then
  databases=`$db_install_dir/bin/mysql -uroot -p$dbrootpwd -e "show databases\G" | grep Database | awk '{print $2}' | grep -Evw "(performance_schema|information_schema|mysql|sys)"`
  while :; do echo
    echo "Please enter one or more name for database, separate multiple database names with commas: "
    read -p "(Default database: `echo $databases | tr ' ' ','`) " db_name
    db_name=`echo $db_name | tr -d ' '`
    [ -z "$db_name" ] && db_name="`echo $databases | tr ' ' ','`"
    D_tmp=0
    for D in `echo $db_name | tr ',' ' '`
    do
      [ -z "`echo $databases | grep -w $D`" ] && { echo "${CWARNING}$D was not exist! ${CEND}" ; D_tmp=1; }
    done
    [ "$D_tmp" != '1' ] && break
  done
  sed -i "s@^db_name=.*@db_name=$db_name@" ./options.conf
fi

if [ "$CONTENT_BK" != '1' ];then
  websites=`ls $wwwroot_dir | grep -vw default`
  while :; do echo
    echo "Please enter one or more name for website, separate multiple website names with commas: "
    read -p "(Default website: `echo $websites | tr ' ' ','`) " website_name 
    website_name=`echo $website_name | tr -d ' '`
    [ -z "$website_name" ] && website_name="`echo $websites | tr ' ' ','`"
    W_tmp=0
    for W in `echo $website_name | tr ',' ' '`
    do
      [ ! -e "$wwwroot_dir/$W" ] && { echo "${CWARNING}$wwwroot_dir/$W not exist! ${CEND}" ; W_tmp=1; }
    done
    [ "$W_tmp" != '1' ] && break
  done
  sed -i "s@^website_name=.*@website_name=$website_name@" ./options.conf
fi

echo
echo "You have to backup the content:"
[ "$CONTENT_BK" != '2' ] && echo "Database: ${CMSG}$db_name${CEND}"
[ "$CONTENT_BK" != '1' ] && echo "Website: ${CMSG}$website_name${CEND}"

if [[ "$DESC_BK" =~ ^[2,4,6]$ ]];then 
  > tools/iplist.txt
  while :; do echo
    read -p "Please enter the remote host ip: " remote_ip
    [ -z "$remote_ip" -o "$remote_ip" == '127.0.0.1' ] && continue
    echo
    read -p "Please enter the remote host port(Default: 22) : " remote_port
    [ -z "$remote_port" ] && remote_port=22 
    echo
    read -p "Please enter the remote host user(Default: root) : " remote_user
    [ -z "$remote_user" ] && remote_user=root 
    echo
    read -p "Please enter the remote host password: " remote_password
    IPcode=$(echo "ibase=16;$(echo "$remote_ip" | xxd -ps -u)"|bc|tr -d '\\'|tr -d '\n')
    Portcode=$(echo "ibase=16;$(echo "$remote_port" | xxd -ps -u)"|bc|tr -d '\\'|tr -d '\n')
    PWcode=$(echo "ibase=16;$(echo "$remote_password" | xxd -ps -u)"|bc|tr -d '\\'|tr -d '\n')
    [ -e "~/.ssh/known_hosts" ] && grep $remote_ip ~/.ssh/known_hosts | sed -i "/$remote_ip/d" ~/.ssh/known_hosts
    ./tools/mssh.exp ${IPcode}P $remote_user ${PWcode}P ${Portcode}P true 10
    if [ $? -eq 0 ];then
      [ -z "`grep $remote_ip tools/iplist.txt`" ] && echo "$remote_ip $remote_port $remote_user $remote_password" >> tools/iplist.txt || echo "${CWARNING}$remote_ip has been added! ${CEND}"
      while :; do
        read -p "Do you want to add more host ? [y/n]: " more_host_yn 
        if [ "$more_host_yn" != 'y' -a "$more_host_yn" != 'n' ];then
          echo "${CWARNING}input error! Please only input 'y' or 'n'${CEND}"
        else
          break
        fi
      done
      [ "$more_host_yn" == 'n' ] && break
    fi
  done
fi

if [[ "$DESC_BK" =~ ^[3,5,6]$ ]];then 
  while :; do echo
    echo 'Please select your backup datacenter:'
    echo -e "\t ${CMSG}1${CEND}. cn-hangzhou-华东 1 (杭州)        ${CMSG}2${CEND}. cn-shanghai-华东 2 (上海)"
    echo -e "\t ${CMSG}3${CEND}. cn-qingdao-华北 1 (青岛)         ${CMSG}4${CEND}. cn-beijing-华北 2 (北京)"
    echo -e "\t ${CMSG}5${CEND}. cn-shenzhen-华南 1 (深圳)        ${CMSG}6${CEND}. cn-hongkong-香港"
    echo -e "\t ${CMSG}7${CEND}. us-east-美东 1 (弗吉尼亚)        ${CMSG}8${CEND}. us-west-美西 1 (硅谷)"
    echo -e "\t ${CMSG}9${CEND}. ap-southeast-亚太 (新加坡)      ${CMSG}10${CEND}. ap-northeast-亚太东北 1 (日本)"
    echo -e "\t${CMSG}11${CEND}. ap-southeast-亚太东南 2 (悉尼)  ${CMSG}12${CEND}. eu-central-欧洲中部 1 (法兰克福)"
    echo -e "\t${CMSG}13${CEND}. me-east-中东东部 1 (迪拜)"
    read -p "Please input a number:(Default 1 press Enter) " Location
    [ -z "$Location" ] && Location=1
    if [ ${Location} -ge 1 >/dev/null 2>&1 -a ${Location} -le 13 >/dev/null 2>&1 ]; then
      break
    else
      echo "${CWARNING}input error! Please only input number 1~13${CEND}"
    fi
  done
  [ "$Location" == '1' ] && Host=oss-cn-hangzhou-internal.aliyuncs.com
  [ "$Location" == '2' ] && Host=oss-cn-shanghai-internal.aliyuncs.com
  [ "$Location" == '3' ] && Host=oss-cn-qingdao-internal.aliyuncs.com
  [ "$Location" == '4' ] && Host=oss-cn-beijing-internal.aliyuncs.com
  [ "$Location" == '5' ] && Host=oss-cn-shenzhen-internal.aliyuncs.com
  [ "$Location" == '6' ] && Host=oss-cn-hongkong-internal.aliyuncs.com
  [ "$Location" == '7' ] && Host=oss-us-east-1-internal.aliyuncs.com
  [ "$Location" == '8' ] && Host=oss-us-west-1-internal.aliyuncs.com
  [ "$Location" == '9' ] && Host=oss-ap-southeast-1-internal.aliyuncs.com
  [ "$Location" == '10' ] && Host=oss-ap-northeast-1-internal.aliyuncs.com
  [ "$Location" == '11' ] && Host=oss-ap-southeast-2-internal.aliyuncs.com
  [ "$Location" == '12' ] && Host=oss-eu-central-1-internal.aliyuncs.com
  [ "$Location" == '13' ] && Host=oss-me-east-1-internal.aliyuncs.com
  [ "$(./include/check_port.py $Host 80)" == "False" ] && Host=$(echo $Host | sed 's@^oss@vpc100-oss@' | sed 's@-internal@@') 
  [ -e "/root/.osscredentials" ] && rm -rf /root/.osscredentials
  while :; do echo
    read -p "Please enter the aliyun oss Access Key ID: " KeyID
    [ -z "$KeyID" ] && continue
    echo
    read -p "Please enter the aliyun oss Access Key Secret: " KeySecret
    [ -z "$KeySecret" ] && continue
    ./tools/osscmd ls --host=$Host --id=$KeyID --key=$KeySecret >/dev/null 2>&1
    if [ $? -eq 0 ];then
      ./tools/osscmd config --host=$Host --id=$KeyID --key=$KeySecret >/dev/null 2>&1
      while :; do echo
        read -p "Please enter the aliyun oss bucket: " Bucket
        ./tools/osscmd createbucket $Bucket --acl=public-read >/dev/null 2>&1
        [ $? -eq 0 ] && { echo "${CMSG}[$Bucket] createbucket OK${CEND}"; sed -i "s@^oss_bucket=.*@oss_bucket=$Bucket@" ./options.conf; break; } || echo "${CWARNING}[$Bucket] already exists, You need to use the OSS Console to create a bucket for storing.${CEND}"
      done
      break
    fi
  done
fi

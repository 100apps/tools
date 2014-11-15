#!/bin/sh

#1 首先设置自己的 BDUSS
BDUSS=$1
#通过cookie就能查看，实测，一个多月没有失效。比如 EU2cllxdmZMREF5Y1JkVEdzVH5MUzFDTU9sNDR4VmhUTWYwSmMyS3owSDBmNjVUQVFBQUFBJCQAAAAAAAAAAAEAAADLhOcAwfW547flAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPTyhlP08oZTZ
if [ x$BDUSS = "x" ]
then
	echo 请先设置BDUSS，参考 http://gfzj.us/900.html
	exit
fi

if [ x$2 = "x" ] || [ x$3 = "x" ]
then
	echo "baidupan.sh BDUSS 远程路径(以/开头，/结尾,/表示根目录) 本地路径"
	exit
fi
echo 开始下载
curl "http://pcs.baidu.com/rest/2.0/pcs/file?app_id=250528&method=locatedownload&es=1&esl=1&ver=3.0&dtype=1&err_ver=1.0" --data-urlencode "path=$2" -H "User-Agent: netdisk;5.0.1.6;PC;PC-Windows;5.1.2600;WindowsBaiduYunGuanJia" -H "Cookie: BDUSS=${BDUSS}"|sed 's/\\//g'|pcregrep -o1 "url\":\"(.*?)\""|head -1|xargs curl -v -H "User-Agent: netdisk;5.0.1.6;PC;PC-Windows;5.1.2600;WindowsBaiduYunGuanJia" -H "Cookie: BDUSS=${BDUSS}" -o $3

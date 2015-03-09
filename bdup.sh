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
	echo "baidupan.sh BDUSS 本地文件名 上传路径(以/开头，/结尾,/表示根目录)"
	exit
fi
echo 开始上传。。。
fn=`echo $2 |xxd -plain | sed 's/\(..\)/%\1/g'`
dir=`echo $3 |xxd -plain | sed 's/\(..\)/%\1/g'`

#update Mon Mar  9 19:12:56 CST 2015 判断目录
if [ `echo $3|rev|cut -c1` != '/' ]
then
	fn=$dir
	dir="%2F"
fi

ret=`curl -F file=@$2 "https://c.pcs.baidu.com/rest/2.0/pcs/file?method=upload&app_id=250528&ondup=newcopy&dir=$dir&filename=$fn&BDUSS=$BDUSS"`
md5=`echo $ret|pcregrep -o1 'md5":"(.*?)"'`
mymd5=`md5sum $2|cut -f1 -d " "`
#苹果操作系统下。用md5命令
if [ `uname` = "Darwin" ]
then
mymd5=`md5 -q $2`
fi

echo
echo 输入的文件的md5: $mymd5;
echo 服务器返回的md5: $md5;
if [ x$md5 = x$mymd5 ] 
then
	echo "上传成功,路径是："
	echo $ret|pcregrep -o1 'path":"(.*?)",'|sed 's/\\//g';
else
	echo "上传失败"
	echo $ret
fi

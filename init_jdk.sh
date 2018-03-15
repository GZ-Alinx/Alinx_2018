#!/bin/bash
tar -zxvf jdk*
cd jdk1*
home=`pwd`
echo $home
echo "JAVA_HOME=${home}" >> /etc/profile
echo "CLASSPATH=\$JAVA_HOME/lib" >> /etc/profile
echo "PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile
echo "安装完毕！！！\r下面进行测试"

#配置完成，下面的是测试

source /etc/profile
javac
echo "java版本为："
java -version

echo "是否删除安装包"
select var in 是 否
do
    break
done

if [ var = 是 ]
then 
    rm -r jdk-*
    echo "安装包已删除"
fi

echo "脚本执行完毕！！！"

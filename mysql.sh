#!/bin/bash
#
##mysql bankup script
cat << EOF 
备份脚本须知：
	备份数据需要注意备份空间！
	备份数据需要注意安全防护！
	备份数据需要周期化的操作！
	备份数据切记做好异地备份！
EOF
#请等待-------
st=$(date +%s)  
USER="root"   
PASSWORD="****"   
DATABASE1="***"
DATABASE2="***"
DATABASE3="***"
MAIL="itadminlx.@163.com.com"
BACKUP_DIR=/data/bankup/mysql
LOGFILE=/data/bankup/mysql/data_backup.log

DATE=`date +%Y%m%d%H%M`
DUMPFILE1=$DATABASE1$DATE.sql   
DUMPFILE2=$DATABASE2$DATE.sql   
DUMPFILE3=$DATABASE3$DATE.sql   
ARCHIVE1=$DATABASE1$DATE.sql.tar.gz   
ARCHIVE2=$DATABASE2$DATE.sql.tar.gz   
ARCHIVE3=$DATABASE3$DATE.sql.tar.gz   
OPTIONS1="-u$USER -p$PASSWORD $DATABASE1"  
OPTIONS2="-u$USER -p$PASSWORD $DATABASE2"  
OPTIONS3="-u$USER -p$PASSWORD $DATABASE3"  
  
if [ ! -d $BACKUP_DIR ]   
then  
    mkdir -p "$BACKUP_DIR"  
fi    
  
echo "    ">> $LOGFILE   
echo "--------------------" >> $LOGFILE   
echo "BACKUP DATE:" $(date +"%y-%m-%d %H:%M:%S") >> $LOGFILE   
echo "-------------------" >> $LOGFILE    
  
cd $BACKUP_DIR   
mysqldump $OPTIONS1 > $DUMPFILE1
	if [ $? -eq 0 ]; then
		echo "[$ARCHIVE1] Backup Successful! 备份成功！" >> $LOGFILE   
	else
		echo "Database Backup Fail! 备份失败！= $ARCHIVE1" >> $LOGFILE   
	fi

mysqldump $OPTIONS2 > $DUMPFILE2  
	if [ $? -eq 0 ]; then
		echo "[$ARCHIVE2] Backup Successful! 备份成功！" >> $LOGFILE   
	else
		echo "Database Backup Fail! 备份失败！= $ARCHIVE2" >> $LOGFILE   
	fi

mysqldump $OPTIONS3 > $DUMPFILE3   
	if [ $? -eq 0 ]; then
		echo "[$ARCHIVE3] Backup Successful! 备份成功！" >> $LOGFILE   
	else   
		echo "Database Backup Fail! 备份失败！= $ARCHIVE3" >> $LOGFILE   
	fi
#if [[ $? == 0 ]]  
#then   
#    echo "[$ARCHIVE1] Backup Successful! 备份成功！" >> $LOGFILE   
#    echo "[$ARCHIVE2] Backup Successful! 备份成功！" >> $LOGFILE   
#    echo "[$ARCHIVE3] Backup Successful! 备份成功！" >> $LOGFILE   
#mail -s "database:$DATABASE Daily Backup Fail!备份出问题了！" $MAIL   
echo "Backup Process Done 结束备份！"   
#删除3天以上的备份文件  
#Cleaning  
find $BACKUP_DIR  -type f -mtime +2 -name "*.sql" -exec rm -f {} \;  

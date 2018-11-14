#!/bin/bash
# $PROJ_PATH：jenkins远程工作目录，执行脚本时传入
# $TOMCAT_PATH：tomcat目录，执行脚本时传入
 
# 关闭tomcat
killTomcat()
{
  pid=`ps -ef|grep tomcat|grep java|awk '{print $2}'`
  echo "tomcat id list :$pid"
  if [ "$pid" = "" ]
  then 
      echo "no tomcat pid alive"
  else
       kill -9 $pid
  fi
}
 
# 进入远程工作目录
cd $PROJ_PATH/spring
# maven打包程序
mvn clean install
# 结束tomcat进程
killTomcat
 
# 删除旧文件
rm -rf $TOMCAT_PATH/webapps/ROOT
rm -f $TOMCAT_PATH/webapps/ROOT.war
rm -f $TOMCAT_PATH/webapps/spring.war
 
# 拷贝文件
cp $PROJ_PATH/target/spring.war $TOMCAT_PATH/webapps/
 
# 进入tomcat/webapps目录
cd $TOMCAT_PATH/webapps/
 
# 重新命名
mv spring.war ROOT.war
 
# 进入tomcat目录
cd $TOMCAT_PATH/
 
# 重新启动tomcat
sh bin/startup.sh

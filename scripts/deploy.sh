#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=springboot_aws_webservice

echo "> Build 파일 복사"
cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> 현재 구동 중인 애플리케이션 pid 확인"
CURRENT_PID=$(pgrep -fl springboot_aws_webservice | grep java | awk '{print $1}')
# | : 전 단게에서 얻은 결과를 다음 프로그램으로 넘겨주면서 작업이 진행됨.
# pgrep >> -fl옵션과 함께 실행하면 명령어의 경로 출력. ex) 14777 springboot_aws_webservice.jar
# grep >> jar 있는지 검색.
# awk '{print $1}' >> 검색 결과의 첫번째 열 출력.


if [ -z "$CURRENT_PID" ]; then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> 새 애플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR NAME : $JAR_NAME"

echo "> $JAR_NAME에 실행권한 추가}"
chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

nohup java -jar \
  -Dspring.config.location=classpath:/application.properties,classpath:/application-real.properties,/home/ec2-user/app/application-oauth.properties,/home/ec2-user/app/application-real-db.properties \
  -Dspring.profiles.active=real \
  $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &
  #2>&1 :  표준 에러 리다이렉션.
  # & : 앞의 명령어를 백그라운드로 돌리고 동시에 뒤의 명령어를 실행.
  # &&는 앞의 명령어가 성공했을 때 뒤의 명령어 실행.


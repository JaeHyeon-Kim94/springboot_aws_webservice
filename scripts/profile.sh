#!/usr/bin/env bash

# 쉬고 있는 profile 찾기
function find_idle_profile(){
  #현재 nginx가 바라보고 있는 스프링 부트가 정상적으로 수행중인지 확인. 응답값을 HttpStatus로 받음.
  RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/profile)

  if [ ${RESPONSE_CODE} -ge 400 ] #400보다 크면
  then
    CURRENT_PROFILE=real2
  else
    CURRENT_PROFILE=$(curl -s http://localhost/profile)
  fi

  if [ ${CURRENT_PROFILE} == real1 ]
  then
    IDLE_PROFILE=real2
  else
    IDLE_PROFILE=real1
  fi

  echo "${IDLE_PROFILE}"
}

#쉬고 있는 profile의 port 찾기
function find_idle_port(){
  IDLE_PROFILE=$(find_idle_profile)

  if [ ${IDLE_PROFILE} == real1 ]
  then
    echo "8081" #bash는 값을 반환하는 기능이 없으므로 echo로 출력된 결과 이용.
                #제일 마지막 줄에 출력. 중간에 echo 사용해선 안됨.
  else
    echo "8082"
  fi
}
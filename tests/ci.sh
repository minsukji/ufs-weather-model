#!/bin/bash
set -eux

check_memory_usage() {
  dirName=/sys/fs/cgroup/memory/docker/$1
  # /sys/fs/cgroup/memory/actions_job/${containerID}
  set +x
  while [ -d $dirName ] ; do
    awk '/(^cache |^rss |^shmem )/' $dirName/memory.stat | cut -f2 -d' ' | paste -s -d,
    sleep 1
  done
  set -x
}

IMG_NAME=ci-test-weather
CASE=""
BUILD="false"
RUN="false"
TEST_NAME=""
BUILD_CASE=""
RUN_CASE=""

# Read in TEST_NAME
source ci.test

while getopts :c:br opt; do
  case $opt in
    c)
      CASE=$OPTARG
      ;;
    b)
      BUILD="true"
      ;;
    r)
      RUN="true"
      ;;
  esac
done

if [ $BUILD = "true" ] && [ $RUN = "true" ]; then
  echo "Specify either build (-b) or run (-r) option, not both"
  exit 2
fi

if [ $BUILD = "true" ] && [ Q$CASE = Q"" ]; then
  echo "Build option (-b) should accompany CASE option (-c)"
  exit 2
fi

if [ $RUN = "true" ] && [ Q$CASE != Q"" ]; then
  echo "Run option (-r) should not accompany CASE option (-c)"
  exit 2
fi

if [ $BUILD = "true" ]; then
  case $CASE in
    restart)
      BUILD_CASE=std
      RUN_CASE=restart
      ;;
    thread)
      BUILD_CASE=std
      RUN_CASE=thread
      ;;
    mpi)
      BUILD_CASE=std
      RUN_CASE=mpi
      ;;
    decomp)
      BUILD_CASE=std
      RUN_CASE=decomp
      ;;
    debug)
      BUILD_CASE=debug
      RUN_CASE=debug
      ;;
    32bit)
      BUILD_CASE=32bit
      RUN_CASE=32bit
      ;;
    *)
      echo Wrong case to run
      exit 2
  esac

  sed -i -e '/affinity.c/d' ../CMakeLists.txt

  docker build --build-arg test_name=$TEST_NAME \
               --build-arg build_case=$BUILD_CASE \
               --build-arg run_case=$RUN_CASE \
               --no-cache \
               --squash --compress \
               -f ../Dockerfile -t ${IMG_NAME} ..
  exit $?

elif [ $RUN == "true" ]; then
  docker run -d ${IMG_NAME}
  echo 'cache,rss,shmem' >memory-stat.txt
  sleep 3
  containerID=$(docker ps -q --no-trunc)
  check_memory_usage $containerID >>memory-stat.txt &
  docker logs -f $containerID
  exit $(docker inspect $containerID --format='{{.State.ExitCode}}')
fi

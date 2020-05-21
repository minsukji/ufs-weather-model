#!/bin/bash
sleep 20
containerID=$(docker ps -q --no-trunc)
#containerID=$(docker ps --format "{{.ID}}")
while [ -d /sys/fs/cgroup/memory/docker/${containerID} ] ; do
  sed -n 1p /sys/fs/cgroup/memory/docker/${containerID}/memory.stat
  sleep 5
done

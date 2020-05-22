#!/bin/bash
sleep 10
containerID=$(docker ps -q --no-trunc)
#containerID=$(docker ps --format "{{.ID}}")
while [ -d /sys/fs/cgroup/memory/actions_job/${containerID} ] ; do
  sed -n 2p /sys/fs/cgroup/memory/actions_job/${containerID}/memory.stat | awk '{printf "%15d\n", $2}' >>mem.txt
  sleep 2
done

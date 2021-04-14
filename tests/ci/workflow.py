#!/usr/bin/env python3

import sys
import json
from datetime import datetime, timedelta
from urllib.request import urlopen, Request

with open('workflow.json') as json_file:
  data = json.load(json_file)['workflow_runs']

for x in data:
  if x['name'] == "Test Helpers":
    date_obj = datetime.strptime(x['created_at'], '%Y-%m-%dT%H:%M:%SZ')


def get_my_time(data, id):
   return datetime.strptime([x["created_at"] for x in data if x["id"]==id][0], "%Y-%m-%dT%H:%M:%SZ")

def get_aux_workflow_triggered_by_me(data, myid, name):
  mytime = get_my_time(data, myid)
  smallest_timedelta = timedelta(hours=23)
  id = -1
  for x in data:
    if x["name"] == name:
      thistime = datetime.strptime(x["created_at"], "%Y-%m-%dT%H:%M:%SZ")
      dt = thistime - mytime
      if dt >= timedelta() and  dt < smallest_timedelta:
        smallest_timedelta = thistime - mytime
        id = x["id"]
        
  return id

def main():
  data = json.load(sys.stdin)["workflow_runs"]
  id = get_aux_workflow_triggered_by_me(data, int(sys.argv[1]), "Test Helpers")
  print(id)

if __name__ == "__main__":
  main()

#!/usr/bin/env python3

import os
import re
import sys
import json
import time
from urllib.request import urlopen, Request

def update_url_data(response, job_name):
  data = json.loads(response.read().decode())
  indices=[]
  for n in range(data["total_count"]):
    if re.search(job_name, data["jobs"][n]["name"]):
      indices.append(n)

  if len(indices) == 0:
    raise ValueError(f"No job named '{job_name}' exists")

  return data, indices

def main():

  time.sleep(80) # give enough time for jobs to start!
  url = sys.stdin.read()
  job_name = sys.argv[1]
  #token = os.environ.get('AUTH')

  #request = Request(url)
  #request.add_header('Authorization', 'token %s' % token)

  status="not-completed"
  no_completed_jobs = 0

  while status != "completed":
    response = urlopen(url)
    data, indices = update_url_data(response, job_name)

    for i in indices:
      if data["jobs"][i]["status"] == "completed":
        no_completed_jobs += 1

    if no_completed_jobs == len(indices):
      status = "completed"
    else:
      no_completed_jobs = 0
      time.sleep(20)

  time.sleep(20)
  conclusion="failure"
  no_successful_jobs = 0
  for i in indices:
    if data["jobs"][i]["conclusion"] == "success":
      no_successful_jobs += 1

  if no_successful_jobs == len(indices):
    conclusion = "success"

  print(conclusion)

if __name__ == "__main__": main()

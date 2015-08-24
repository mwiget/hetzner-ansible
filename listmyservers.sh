#!/bin/bash
username=`grep hetzner_webservice_username secrets.yml|cut -d'"' -f2`
password=`grep hetzner_webservice_password secrets.yml|cut -d' ' -f2`
curl -su "$username:$password" https://robot-ws.your-server.de/server|python -m json.tool

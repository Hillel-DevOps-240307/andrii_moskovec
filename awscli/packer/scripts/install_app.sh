#!/bin/sh

#### install packages required for app
sudo apt install -y python3-pip default-libmysqlclient-dev build-essential pkg-config

#### install app and dependencies
git clone https://github.com/saaverdo/flask-alb-app -b orm
cd flask-alb-app
sudo pip install -r requirements.txt

#### Run app
gunicorn -b 0.0.0.0 appy:app

#### App will be available via url http://<instance_dns_or_ip>:8000


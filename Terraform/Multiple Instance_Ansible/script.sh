#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "Welcome to Saravanan" > /var/www/html/index.html
yum install java-11 -y
yum install docker -y
systemctl enable docker
systemctl start docker
docker run -d --name webserver -p 8080:80 nginx
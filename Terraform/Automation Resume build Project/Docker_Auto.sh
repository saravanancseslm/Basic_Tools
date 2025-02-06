#!/bin/bash
yum update -y
yum install git -y
yum install java-11 -y
yum install docker -y

systemctl enable docker

systemctl start docker

mkdir /home/ec2-user/project

cd /home/ec2-user/project

git clone https://github.com/saravanancseslm/Resume_Project_V2.git

cat <<EOF > Dockerfile
# Use an official httpd base image
FROM httpd:latest

# Updating user Details
MAINTAINER "Saravanan"

# Copying the content
COPY ./Resume_Project_V2/ /usr/local/apache2/htdocs

# Expose the port
EXPOSE 80

EOF

mv /home/ec2-user/Dockerfile /home/ec2-user/project/

cd /home/ec2-user/project

docker build -t resume .

docker run -d --name Resume01 -p 80:80 resume
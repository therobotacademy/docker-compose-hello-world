#!/bin/bash
dpkg -r docker
wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $(whoami)
sudo apt-get update
sudo apt-get -y install python-pip
sudo pip install docker-compose
docker-compose --version

docker-compose -f ~/hello_world/docker-compose.yml build
docker-compose -f ~/hello_world/docker-compose.yml up -d

WEB_APP_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' helloworld_web_1)
echo $WEB_APP_IP
curl http://${WEB_APP_IP}:80

docker-compose -f ~/hello_world/docker-compose.test.yml -p ci build
docker-compose -f ~/hello_world/docker-compose.test.yml -p ci up -d
docker logs -f ci_sut_1
docker wait ci_sut_1


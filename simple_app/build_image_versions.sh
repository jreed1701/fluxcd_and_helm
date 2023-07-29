#!/usr/bin/env bash

sed -i 's/VERSION="1"/VERSION="1"/g' ./application/views.py
docker build -t localhost:9001/simple_app:v1 ./

sed -i 's/VERSION="1"/VERSION="2"/g' ./application/views.py
docker build -t localhost:9001/simple_app:v2 ./

sed -i 's/VERSION="2"/VERSION="3"/g' ./application/views.py
docker build -t localhost:9001/simple_app:v3 ./

sed -i 's/VERSION="3"/VERSION="1"/g' ./application/views.py

docker push localhost:9001/simple_app:v1
docker push localhost:9001/simple_app:v2
docker push localhost:9001/simple_app:v3


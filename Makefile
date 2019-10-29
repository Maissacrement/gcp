#!make
help:
	echo 'test'

deploy:
	gcloud app deploy

compose-start:
	docker-compose up --build

build:
	docker build -t emmario/node-hello:0.1 .

run:
	docker run --name mario-nginx -it -p 5147:5147 emmario/node-hello:0.1

rm-dev:
	docker stop /mario-nginx && \
	docker rm /mario-nginx

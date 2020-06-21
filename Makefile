SERVICE_NAME = simple-service
PROTOC_DOCKER_IMAGE = jaegertracing/protobuf:latest

compile_protos:
	docker run \
		--rm \
		-w ${PWD} \
		-v ${PWD}:${PWD} \
		jaegertracing/protobuf:latest \
		--proto_path=${PWD}/ --go_out=plugins=grpc,paths=source_relative:. proto/simple/*.proto

build_local: compile_protos 
	docker build -t simple .
	docker run --rm -p 11500:11500 simple

build_dev: build_local
	echo "${ECR_REPOSITORY_URI_DEFAULT}"
	docker tag ${SERVICE_NAME}:latest simple-service:latest-dev
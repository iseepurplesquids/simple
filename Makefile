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
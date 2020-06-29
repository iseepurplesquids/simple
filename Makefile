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
	docker build -t ${SERVICE_NAME}:latest .

build_dev: build_local
	echo "${ECR_REPOSITORY_URI_DEFAULT}"
	docker tag ${SERVICE_NAME}:latest simple-service:latest-dev

migrate:
	docker run --rm \
		-e "FLYWAY_SCHEMAS=simpledatabase" \
		-e "FLYWAY_PASSWORD=11142233" \
		-e "FLYWAY_USER=admin" \
		-e "FLYWAY_URL=jdbc:mysql://simple-database-1.cluster-cuzlsorkzlvn.ap-south-1.rds.amazonaws.com:3306/simpledatabase" \
		-v ${PWD}/config/flyway/:/flyway/conf \
		-v ${PWD}/deployment/migrations:/flyway/sql \
		flyway/flyway:6.4.1 migrate

run:
	docker run --rm -p 11500:11500 simple
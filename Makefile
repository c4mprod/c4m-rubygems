VERSION="0.1.0"
BUILD_TAG="cdarne/c4m-rubygems:$(VERSION)"
CONTAINER_NAME="rubygems"

build: Dockerfile
	docker build -t=$(BUILD_TAG) .

daemon:
	docker rm $(CONTAINER_NAME)
	docker run -e "GEM_SERVER_USERNAME=c4m" -e "GEM_SERVER_PASSWORD=password" --name $(CONTAINER_NAME) -d -P $(BUILD_TAG)

logs:
	docker logs -f $(CONTAINER_NAME)

bash:
	docker run -e "GEM_SERVER_USERNAME=c4m" -e "GEM_SERVER_PASSWORD=password" --rm -t -i -P $(BUILD_TAG) /sbin/my_init -- bash -l

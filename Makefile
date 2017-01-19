DOCKER_IMAGE_VERSION=1.0
DOCKER_IMAGE_NAME=talmai/rpi-watchtower
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

WATCHTOWER_OUTPUT_ARM5=rpi-watchtower_ARM5
WATCHTOWER_OUTPUT_ARM6=rpi-watchtower_ARM6
WATCHTOWER_OUTPUT_ARM7=rpi-watchtower_ARM7

default: build

compileARM:
	@test -s $(WATCHTOWER_OUTPUT_ARM5) && echo "$(WATCHTOWER_OUTPUT_ARM5) already built" || env GOOS=linux GOARCH=arm GOARM=5 go build -o $(WATCHTOWER_OUTPUT_ARM5) ./main.go
	@test -s $(WATCHTOWER_OUTPUT_ARM6) && echo "$(WATCHTOWER_OUTPUT_ARM6) already built" || env GOOS=linux GOARCH=arm GOARM=5 go build -o $(WATCHTOWER_OUTPUT_ARM6) ./main.go
	@test -s $(WATCHTOWER_OUTPUT_ARM7) && echo "$(WATCHTOWER_OUTPUT_ARM7) already built" || env GOOS=linux GOARCH=arm GOARM=5 go build -o $(WATCHTOWER_OUTPUT_ARM7) ./main.go

clean:
	rm -rf rpi-watchtower_ARM5
	rm -rf rpi-watchtower_ARM6
	rm -rf rpi-watchtower_ARM7

build: compileARM
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push:
	docker push $(DOCKER_IMAGE_NAME)

test:
	docker run --rm $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."

rmi:
	docker rmi -f $(DOCKER_IMAGE_TAGNAME)
	# env REPO_USER=xxx REPO_PASS=xxxx docker run -d --name watchtower -v /var/run/docker.sock:/var/run/docker.sock lightingiot/rpi-test --debug

rebuild: clean rmi build
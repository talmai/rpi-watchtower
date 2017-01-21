DOCKER_IMAGE_VERSION=1.0
DOCKER_IMAGE_NAME=talmai/rpi-watchtower
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

WATCHTOWER_OUTPUT_ARM5=rpi-watchtower_ARM5
WATCHTOWER_OUTPUT_ARM6=rpi-watchtower_ARM6
WATCHTOWER_OUTPUT_ARM7=rpi-watchtower_ARM7

default: build

compileARM:
	@test -s $(WATCHTOWER_OUTPUT_ARM5) && echo "$(WATCHTOWER_OUTPUT_ARM5) already built" || (echo "Building $(WATCHTOWER_OUTPUT_ARM5)" && env GOOS=linux GOARCH=arm GOARM=5 go build -o $(WATCHTOWER_OUTPUT_ARM5) ./main.go)
	@test -s $(WATCHTOWER_OUTPUT_ARM6) && echo "$(WATCHTOWER_OUTPUT_ARM6) already built" || (echo "Building $(WATCHTOWER_OUTPUT_ARM6)" && env GOOS=linux GOARCH=arm GOARM=6 go build -o $(WATCHTOWER_OUTPUT_ARM6) ./main.go)
	@test -s $(WATCHTOWER_OUTPUT_ARM7) && echo "$(WATCHTOWER_OUTPUT_ARM7) already built" || (echo "Building $(WATCHTOWER_OUTPUT_ARM7)" && env GOOS=linux GOARCH=arm GOARM=7 go build -o $(WATCHTOWER_OUTPUT_ARM7) ./main.go)

clean:
	rm -rf rpi-watchtower_ARM5
	rm -rf rpi-watchtower_ARM6
	rm -rf rpi-watchtower_ARM7

build: compileARM
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push: build
	docker push $(DOCKER_IMAGE_NAME)

test:
	docker run --rm $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."
	# run test container
	docker run -it talmai/rpi-test
	# run rpi-watchtower
	#docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -e REPO_USER=xxx -e REPO_PASS=xxx talmai/rpi-watchtower 6 --apiversion=1.24 --debug lightingiot/rpi-test
	docker run -d -v /var/run/docker.sock:/var/run/docker.sock -e REPO_USER=xxx -e REPO_PASS=xxx talmai/rpi-watchtower 6 --apiversion=1.24 --debug lightingiot/rpi-test
	#docker ps -a | grep Exited | cut -d ' ' -f 1 | xargs docker rm
	#docker rmi $(docker images --quiet --filter "dangling=true")

#debugProcess:
#	rm rpi-watchtower_ARM6
#	make compileARM
#	scp rpi-watchtower_ARM6 pi@riot006.local:/tmp

rmi:
	docker rmi -f $(DOCKER_IMAGE_TAGNAME)

rebuild: clean rmi build
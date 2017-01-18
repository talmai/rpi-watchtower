## Prerequisites
To contribute code changes to this project you will need the following development kits.
 * Go. [Download and install](https://golang.org/doc/install) the Go programming language
 * [docker](https://docs.docker.com/engine/installation/).
 
 ### Installing Docker on RPi
 
 ```bash
curl -sSL https://get.docker.com | sh
```

Followed by adding your user (pi) to the docker group, and restarting your RPi

 ```bash
sudo usermod -aG docker pi
sudo /sbin/shutdown -r now
```

## Checking out the code
When cloning watchtower to your development environment you should place your forked repo within the [standard go code structure](https://golang.org/doc/code.html#Organization).
```bash
export GOPATH=<your_fork_location>
cd $GOPATH/src
mkdir <yourfork>
cd <yourfork>
git clone http://github.com/talmai/rpi-watchtower
cd watchtower
```

## Building and testing
watchtower is a go application and is built with go commands. The following commands assume that you are at the root level of your repo.
```bash
go get ./... # analyzes and retrieves package dependencies
env GOOS=linux GOARCH=arm GOARM=6 go build     # compiles and packages an executable binary, watchtower
go test      # runs tests
./watchtower # runs the application (outside of a container)
```
```diff
- there are no tests currently. just fyi
```

### Building the docker image
watchtower is packaged and distributed as a docker image. A [golang-builder](https://github.com/CenturyLinkLabs/golang-builder) is used to package the go code and its
dependencies as a minimally-sized application. The application binary is then layered into to a minimal docker image (see `Dockerfile`), so that the entire image is <10MB.
See `circle.yml` for further details.The following commands assume that you are at the root level of your repo (i.e. `watchtower/`).

```bash
docker pull centurylink/golang-builder:latest									# download the builder
docker run -v $(pwd):/src centurylink/golang-builder:latest						# build the minimal binary
docker build -t <yourfork>/watchtower:latest .									# build the docker image
docker run -v /var/run/docker.sock:/var/run/docker.sock <yourfork>/watchtower	# run the application (inside of a container)
```


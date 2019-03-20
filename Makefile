GIT_VER := $(shell git describe --tags | sed -e 's/^v//')
export GO111MODULE := on

all: katsubushi

katsubushi: cmd/katsubushi/katsubushi

cmd/katsubushi/katsubushi: *.go cmd/katsubushi/*.go
	cd cmd/katsubushi && go build -ldflags "-w -s -X github.com/kayac/go-katsubushi.Version=${GIT_VER}"


.PHONEY: clean test packages install
install: cmd/katsubushi/katsubushi
	install cmd/katsubushi/katsubushi ${GOPATH}/bin

clean:
	rm -rf cmd/katsubushi/katsubushi pkg/*

test:
	go test -race

packages:
	cd cmd/katsubushi && gox -os="linux darwin" -arch="386 amd64" -output "../../pkg/${GIT_VER}-{{.OS}}-{{.Arch}}/{{.Dir}}" -ldflags "-w -s -X github.com/kayac/go-katsubushi.Version=${GIT_VER}"
	cd pkg && find * -type dir -exec ../pack.sh {} katsubushi \;


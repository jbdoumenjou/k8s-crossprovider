.PHONY: all

all: build-images start

build-images: clean-images
	docker tag containous/traefik:latest traefik:local
	docker save traefik:local -o ./images/traefik.tar

clean: clean-images
	rm -rf ./in/coredns.yaml
	rm -rf ./in/traefik.yaml
	rm -rf ./in/rolebindings.yaml

clean-images:
	rm -rf ./images/traefik.tar

start: stop
	docker-compose up -d
	sleep 5
	export KUBECONFIG=$(pwd)/in/kubeconfig.yaml

stop:
	docker-compose down --remove-orphans && docker system prune -f --volumes

test-http:
	curl localhost/whoami

test-api:
	curl localhost:8080/api/rawdata | jq

get-secret-tls:
	cat certs/cert.pem | base64 | tr -d '\n'
	cat certs/key.pem | base64 | tr -d '\n'

IMAGE:=ghcr.io/rwunderer/postgres-s3backup
VERSION:=latest

all: scan

build:
	docker build -t $(IMAGE):$(VERSION) .

scan: build
	trivy --cache-dir .trivycache/ image --exit-code 1 --no-progress --severity HIGH --ignore-unfixed $(IMAGE):$(VERSION)

# vim: noexpandtab ts=4 sw=4

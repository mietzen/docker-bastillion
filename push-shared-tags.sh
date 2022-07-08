#/bin/bash -l
docker manifest create mietzen/bastillion-dev:latest-debian mietzen/bastillion-dev:latest-debian-amd64-34 mietzen/bastillion-dev:latest-debian-arm64-34 mietzen/bastillion-dev:latest-debian-armv7-34
docker manifest push mietzen/bastillion-dev:latest-debian
docker manifest create mietzen/bastillion-dev:latest-alpine mietzen/bastillion-dev:latest-alpine-amd64-34 mietzen/bastillion-dev:latest-alpine-arm64-34
docker manifest push mietzen/bastillion-dev:latest-alpine
docker manifest create mietzen/bastillion-dev:latest mietzen/bastillion-dev:latest-debian-amd64-34 mietzen/bastillion-dev:latest-debian-arm64-34 mietzen/bastillion-dev:latest-debian-armv7-34
docker manifest push mietzen/bastillion-dev:latest

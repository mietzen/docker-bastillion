# Bastillion Docker Image
**This is a fork of: [e-COSI/docker-bastillion](https://github.com/e-COSI/docker-bastillion) Docker image for [Bastillion.io](https://www.bastillion.io/)**

I updated `bastillion` to the latest version in order to address [CVE-2021-44228](https://github.com/advisories/GHSA-jfh8-c2jp-5v3q), [CVE-2021-45046](https://github.com/advisories/GHSA-7rjr-3q55-vv33) aka **Log4Shell**, updated the deprecated base image fom `openJDK` to `debian-slim` with `openjdk-11-jre-headless` and because of the arm64 target I build dockerize from source as part of the build.

There are now Github Actiona to build the image for:
* `linux/amd64`
* `linux/arm64`
* `linux/arm/v7`

And to build a `alpine` version taged `-alpine` (e.g. `mietzen/bastillion:3.14.0-alpine`) for:
* `linux/amd64`
* `linux/arm64`

The full upgrade path is available from `e-COSI/docker-bastillion:3.09.00` image to `3.14.0`.

Shared tags:

* `3.14.0`  -> `3.14.0-debian`
* `3.13.00` -> `3.13.00-debian`
* `3.12.02` -> `3.12.02-debian`
* `3.12.01` -> `3.12.01-debian`
* `3.12.00` -> `3.12.00-debian`
* `3.11.01` -> `3.11.01-debian`
* `3.10.00` -> `3.10.00-debian`
* `3.14.0-alpine`
* `3.13.00-alpine`
* `3.12.02-alpine`
* `3.12.01-alpine`
* `3.12.00-alpine`
* `3.11.01-alpine`
* `3.10.00-alpine`

For all tags, see: [DockerHub](https://hub.docker.com/r/mietzen/bastillion/tags?page=1&ordering=name)

The base images are nightly updated and all images are rudimentary tested with [InSpec](https://docs.chef.io/inspec/).

## Upgrade to the latest version
Before upgrading to the next version make sure to read the [release notes](https://github.com/n-stone/docker-bastillion/releases), check how to migrate your settings and database.
## What is Bastillion?
Bastillion is an open-source web-based SSH console that centrally manages administrative access to systems.
A bastion host for administrators with features that promote infrastructure security, including key management and auditing.
For more information visit the [Bastillion website](https://www.bastillion.io/) or the [GitHub page](https://github.com/bastillion-io/Bastillion)

## Start with `docker run`
On Linux:
```
mkdir ./keydb
sudo chown 999:$(id -g) ./keydb
sudo chmod 770 ./keydb
```

Start Bastillion with `docker run` on your local host:
```shell
docker run -d -p 8443:8443 -v $(pwd)/keydb:/keydb mietzen/bastillion
```

With `--add-host=host.docker.internal:host-gateway` you will be able to connect to ssh-servers on your lan.

Go to [https://127.0.0.1:8443](https://127.0.0.1:8443) and login with: 
* Username: `admin`
* Password: `changeme`

## Start using `docker-compose`

On Linux:
```
mkdir /srv/keydb
sudo chown 999:$(id -g) ./keydb
sudo chmod 770 ./keydb
```

```yaml
version: "3"
services:
  bastillion:
    image: mietzen/bastillion:3.14.0
    container_name: bastillion
    restart: unless-stopped
    ports:
      - 8443:8443
    volumes:
      - ./keydb:/keydb
```

By adding:
```
extra_hosts:
      - "host.docker.internal:host-gateway"
```
you will be able to connect to ssh-servers on your lan.

Run with:
```shell
docker-compose up -d
```
Go to [https://127.0.0.1:8443](https://127.0.0.1:8443) and login with: 
* Username: `admin`
* Password: `changeme`

See also: [docker-compose.yaml](docker-compose.yaml)

## Build it your self

### Ubuntu
```shell
BASTILLION_VERSION=3.14.0
BASTILLION_FILENAME_VERSION=$(echo $BASTILLION_VERSION | sed -r 's/(.*)\./\1_/')
if [ "${#BASTILLION_FILENAME_VERSION}" -lt 7 ]; then BASTILLION_FILENAME_VERSION=$(echo "${BASTILLION_FILENAME_VERSION}0"); fi # Fix for 3.14.0 
docker build \
   --build-arg BASTILLION_VERSION=${BASTILLION_VERSION} \
   --build-arg BASTILLION_FILENAME_VERSION=${BASTILLION_FILENAME_VERSION} \
   --no-cache -t bastillion:${BASTILLION_VERSION} \
   --file ./Dockerfile .
```
### Alpine
```shell
BASTILLION_VERSION=3.14.0
BASTILLION_FILENAME_VERSION=$(echo $BASTILLION_VERSION | sed -r 's/(.*)\./\1_/')
if [ "${#BASTILLION_FILENAME_VERSION}" -lt 7 ]; then BASTILLION_FILENAME_VERSION=$(echo "${BASTILLION_FILENAME_VERSION}0"); fi # Fix for 3.14.0
docker build \
   --build-arg BASTILLION_VERSION=${BASTILLION_VERSION} \
   --build-arg BASTILLION_FILENAME_VERSION=${BASTILLION_FILENAME_VERSION} \
   --no-cache -t bastillion:${BASTILLION_VERSION}-alpine \
   --file ./Dockerfile.alpine .
```

## Full list of environment variables:
See: [all environment variables](environment_list.md)

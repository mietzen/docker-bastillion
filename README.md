# Bastillion Docker Image
**This is a fork of: [e-COSI/docker-bastillion](https://github.com/e-COSI/docker-bastillion) Docker image for [Bastillion.io](https://www.bastillion.io/)**

**Orignially Developed by: [e-COSI](https://github.com/e-COSI)**

I updated `bastillion` to `3.14.0` to address [CVE-2021-44228](https://github.com/advisories/GHSA-jfh8-c2jp-5v3q), [CVE-2021-45046](https://github.com/advisories/GHSA-7rjr-3q55-vv33) aka Log4Shell and updated the deprecated base image fom `openJDK` to [eclipse-temurin:17-jre](https://hub.docker.com/_/eclipse-temurin/) 
There are now Github Actiona to build the image for:
* `linux/amd64`
* `linux/arm64`
* `linux/arm/v7`

And to build a `alpine` version taged `-alpine` (e.g. `mietzen/bastillion:3.14.0-alpine`) for:
* `linux/amd64`
* `linux/arm64`

The full upgrade path is available from the `latest` `e-COSI/docker-bastillion:3.09.00` image to `3.14.0`.

For all tags, see: [DockerHub](https://hub.docker.com/r/mietzen/bastillion/tags?page=1&ordering=name)

The base images are nightly updated.

## Upgrade to the latest version
Before upgrading to the next version make sure to read the [release notes](https://github.com/n-stone/docker-bastillion/releases), check how to migrate your settings and database.
## What is Bastillion?
Bastillion is an open-source web-based SSH console that centrally manages administrative access to systems.
A bastion host for administrators with features that promote infrastructure security, including key management and auditing.
For more information visit the [Bastillion website](https://www.bastillion.io/) or the [GitHub page](https://github.com/bastillion-io/Bastillion)

## Start with `docker run`
Start Bastillion with `docker run` on your local host:
```console
$ docker run -d -p 8080:8080 -p 8443:8443 -v $(pwd)/keydb:/keydb mietzen/bastillion
```

Go to [https://127.0.0.1:8080](https://127.0.0.1:8080) and login with: 
* Username: `admin`
* Password: `changeme`

## Start using `docker-compose`

```
version: "3"
services:
  bastillion:
    image: mietzen/bastillion:3.14.0
    container_name: bastillion
    restart: unless-stopped
    ports:
      - 8080:8080
      - 8443:8443
    volumes:
      - ./keydb:/keydb
```

Run with:
```console
$ docker-compose up -d
```
Go to [https://127.0.0.1:8080](https://127.0.0.1:8080) and login with: 
* Username: `admin`
* Password: `changeme`

See also: [docker-compose.yaml](docker-compose.yaml)

## Build it your self

### Ubuntu
```console
$ BASTILLION_VERSION=3.14.0
$ BASTILLION_FILENAME_VERSION=$(echo $BASTILLION_VERSION | sed -r 's/(.*)\./\1_/')
$ if [ "${#BASTILLION_FILENAME_VERSION}" -lt 7 ]; then BASTILLION_FILENAME_VERSION=$(echo "${BASTILLION_FILENAME_VERSION}0"); fi # Fix for 3.14.0 
$ docker build \
   --build-arg BASTILLION_VERSION=${BASTILLION_VERSION} \
   --build-arg BASTILLION_FILENAME_VERSION=${BASTILLION_FILENAME_VERSION} \
   --no-cache -t bastillion:${BASTILLION_VERSION} \
   --file ./Dockerfile .
```
### alpine
```console
$ BASTILLION_VERSION=3.14.0
$ BASTILLION_FILENAME_VERSION=$(echo $BASTILLION_VERSION | sed -r 's/(.*)\./\1_/')
$ if [ "${#BASTILLION_FILENAME_VERSION}" -lt 7 ]; then BASTILLION_FILENAME_VERSION=$(echo "${BASTILLION_FILENAME_VERSION}0"); fi # Fix for 3.14.0
$ docker build \
   --build-arg BASTILLION_VERSION=${BASTILLION_VERSION} \
   --build-arg BASTILLION_FILENAME_VERSION=${BASTILLION_FILENAME_VERSION} \
   --no-cache -t bastillion:${BASTILLION_VERSION}-alpine \
   --file ./Dockerfile.alpine .
```

## Full Environment Variable list:
_Dockerize is used to generate a configuration file for the application_

* **set to true to regenerate and import SSH keys**

   `RESET_APPLICATION_SSH_KEY` 

   _Default: "false"_


* **SSH key type 'dsa', 'rsa', or 'ecdsa' for generated keys**

   `SSH_KEY_TYPE` 

   Default: "rsa"


* **SSH key length for generated keys**

   2048 => 'rsa','dsa'; 521 => 'ecdsa'
   
   `SSH_KEY_LENGTH` 
   
   _Default: "2048"_

* **private ssh key**
   Provide **path** to private keyfile

   leave blank to generate key pair

   `SSH_PRIVATE_KEY` 

   _Default: ""_


* **public ssh key**
   Provide **path** to public keyfile

   leave blank to generate key pair

   `SSH_PUBLIC_KEY` 

   _Default: ""_

* **default passphrase** 

   leave blank for key without passphrase

   `defaultSSHPassphrase=${randomPassphrase}` 


* **enable audit**

   `ENABLE_INTERNAL_AUDIT`

   _Default: "false"_


* **keep audit logs for in days**

   `DELETE_AUDIT_LOG_AFTER`

   _Default:  "90"_

* **The number of seconds that the client will wait before sending a null packet to the server to keep the connection alive**

   `SERVER_ALIVE_INTERVAL` 

   _Default: "60"_


* **enable SSH agent forwarding**

   `AGENT_FORWARDING` 

   _Default: "false"_

* **enable two-factor authentication with a one-time password**

   'required', 'optional', or 'disabled'

   `ONE_TIME_PASSWORD` 

   _Default: "optional"_

* **set to false to disable key management**
   
   If false, the Bastillion public key will be appended to the authorized_keys file (instead of it being overwritten completely).
   
   `KEY_MANAGEMENT_ENABLED`
   
   _Default: "true"_

* **set to true to generate keys when added/managed by users and enforce strong passphrases set to false to allow users to set their own public key**

   `FORCE_USER_KEY_GENERATION` 

   _Default: "true"_

* **authorized_keys refresh interval in minutes**
   
   (no refresh for <=0)
   
   `AUTH_KEYS_REFRESH_INTERVAL` 
   
   _Default: "120"_


* **HTTP header to identify client IP Address**
  
  ('X-FORWARDED-FOR')
  
  `CLIENT_IP_HEADER` 

* **The session time out value of application in minutes**

   `SESSION_TIMEOUT`
   
   _Default: "15"_

* **Database user**

   `DB_USER` 
   
   _Default: "bastillion"_

* **Database password**

   `DB_PASSWORD`

* **Connection URL to the DB**

   `DB_CONNECTION_URL` 

   _Default: "jdbc:h2:keydb/bastillion;CIPHER=AES"_

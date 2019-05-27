# [Dockerized](https://www.docker.com/) [Geneweb](https://geneweb.tuxfamily.org/wiki/GeneWeb)

GeneWeb is a free multi-platform genealogy software tool created and owned by Daniel de Rauglaudre of INRIA. GeneWeb is 
accessed by a Web browser, either off-line or as a server in a Web environment.

## Running from pre-compiled docker image

Ensure you have [docker environment](https://www.docker.com/products/docker-desktop) setup on your desktop/server

### Download the docker image
```
docker pull jeffernz/geneweb:latest
```

### Running the docker image

When running the geneweb dockerized container, you will need a location to save your geneweb databases on you local 
desktop/server. For this we can pick a location in your home directory. e.g. `~/GenealogyData`

To launch the container, execute the following in your favourite shell:

```
docker run -d \
    --name jeffernz-geneweb \
    --restart unless-stopped \
    -p 2316:2316 -p 2317:2317 \
    -v ~/GenealogyData:/usr/local/var/geneweb \
    jeffernz/geneweb:latest
```

If you are accessing GeneWeb setup from a different host, add the environment variable `HOST_IP` to the run command. e.g.

```
--env HOST_IP=192.168.0.10
```

If you need to run GeneWeb in a different language, add the environment variable `LANGUAGE` to the run command. e.g.

```
--env LANGUAGE=en
```

If you need to run GeneWeb in a different timezone, add the environment variable `TZ` to the run command. e.g.

```
--env TZ=Australia/Melbourne
```

## Running from source repository

Ensure you have [Git](https://git-scm.com/) and [docker environment](https://www.docker.com/products/docker-desktop) setup on your desktop/server

### Download source, build and run

```
git clone https://github.com/jeffery/docker-geneweb.git && cd docker-geneweb
```

```
./main.sh -z
```

Geneweb portal should be running at http://localhost:2317 and setup portal available at http://localhost:2316

## Shutdown
To shutdown the container just run

```docker stop jeffernz-geneweb```

Cleanup the launched container

```docker rm jeffernz-geneweb```

## Backup

To obtain a backup of all the databases in your running GeneWeb container, you can execute

```
docker exec -it jeffernz-geneweb backup.sh
```

The backup will be stored in your home directory under `~/GenealogyData/backup`

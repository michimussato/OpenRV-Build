

---

# OpenRV

## Docker

### Rocky 9

#### Base

##### Build

```shell
export DOCKERFILE="OpenRV.Linux-Rocky9.build_base.Dockerfile" && \
/usr/bin/time \
    -f 'Commandline Args: %C\nElapsed Time: %E\nPeak Memory: %M\nExit Code: %x' \
docker build \
    --file ./docker/${DOCKERFILE} \
    --progress plain \
    --tag openstudiolandscapes/$(echo ${DOCKERFILE,,} | sed -r 's/[-. ]+/_/g'):latest \
    --tag openstudiolandscapes/$(echo ${DOCKERFILE,,} | sed -r 's/[-. ]+/_/g'):$(date +"%Y-%m-%d_%H-%M-%S") \
    . \
> >(tee -a ./docker/${DOCKERFILE}.STDOUT.log) 2> >(tee -a ./docker/${DOCKERFILE}.STDERR.log >&2) && \
unset DOCKERFILE
```

##### Run

```shell
export DOCKERFILE="OpenRV.Linux-Rocky9.build_base.Dockerfile" && \
docker run \
    --hostname $(echo ${DOCKERFILE,,} | sed -r 's/[-. ]+/_/g') \
    --rm \
    --name $(echo ${DOCKERFILE,,} | sed -r 's/[-. ]+/_/g') \
    openstudiolandscapes/$(echo ${DOCKERFILE,,} | sed -r 's/[-. ]+/_/g'):latest /bin/bash -c "trap : TERM INT; sleep infinity & wait" && \
unset DOCKERFILE
```

##### Exec

```shell
export DOCKERFILE="OpenRV.Linux-Rocky9.build_base.Dockerfile" && \
docker container exec \
    --interactive \
    --tty $(echo ${DOCKERFILE,,} | sed -r 's/[-. ]+/_/g') /bin/bash && \
unset DOCKERFILE
```

#### Stage
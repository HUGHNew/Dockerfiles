# cs143

[Dockerfile](Dockefile) is the same as [Dockerfile.zh](Dockerfile.zh)

> You can install lib32z1 to get 32bit support for x86_64

`sudo docker pull git4docker/cs143:(zh|raw)`

> `zh` for people who lives in China
> 
> `raw` for others
> 
> diff in apt source only

or

build by yourself

## features

- based on ubuntu:14.04
- unzip tarball to `/usr/cs143` and add to `PATH`
- EXPOSE 22 and install ssh-server to allow VSCode Remote
- workdir locates `/root/code`
- Aliyun mirror for zh-CN

### usage

Dockerfile for cs143 based on ubuntu14:04

to run this image:`sudo docker run --name cs143 -h cs143 -itd cs143:zh`

get container ip : `sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" container_name`

(You can use VSCode Remote)to ssh this container:
```bash
ssh root@$(sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" cs143)
```

default passwd is `root`

## paths

the tarball locates `/usr/cs143` while the bin has been added to PATH
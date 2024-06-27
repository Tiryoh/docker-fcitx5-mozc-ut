# docker-fcitx5-mozc-ut

Dockerfile to build mozc-ut

## Usage

### Ubuntu 22.04

```
./build.sh
```

```
docker run --rm -it -v $PWD/dist:/ws ghcr.io/tiryoh/fcitx5-mozc-ut:jammy
cp /tmp/mozc-src/*.deb /ws/  # run this command in the container
```

## Reference

https://fx-kirin.com/ubuntu/install-fcitx5-mozc-ut-on-ubuntu-22-04/

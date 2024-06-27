FROM ubuntu:jammy-20240416

RUN apt-get update && \
	apt-get install -y git build-essential wget apt-src ruby language-pack-ja && \
	update-locale LANG=ja_JP.UTF-8 && \
	apt-get clean && \
	rm -rf /var/cache/apt/*

RUN apt-get update && \
	cd /tmp && \
	git clone https://github.com/utuhiro78/merge-ut-dictionaries.git && \
	cd merge-ut-dictionaries && \
	wget https://patch-diff.githubusercontent.com/raw/utuhiro78/merge-ut-dictionaries/pull/3.patch && \
	git apply 3.patch && \
	cd src && bash make.sh && \
	apt-get clean && \
	rm -rf /var/cache/apt/*

RUN sed -i -e 's/# deb-src/deb-src/g' /etc/apt/sources.list && \
	mkdir /tmp/mozc-src && cd /tmp/mozc-src && \
	apt-src update && \
	apt-src install fcitx5 && \
	apt-src install fcitx5-mozc && \
	cat /tmp/merge-ut-dictionaries/src/mozcdic-ut-*.txt >> /tmp/mozc-src/dictionary00.txt && \
	rm -rf /var/cache/apt/*

RUN cd /tmp/mozc-src && \
	apt-src build fcitx5 && \
	apt-src build fcitx5-mozc

# Need to install a package with apt command if you get message like 
# "dpkg-checkbuilddeps: error: Unmet build dependencies: ..."

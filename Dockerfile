FROM ubuntu:jammy-20240416

RUN apt-get update && \
	apt-get install -y git build-essential wget apt-src ruby python-is-python3 language-pack-ja && \
	update-locale LANG=ja_JP.UTF-8 && \
	apt-get clean && \
	rm -rf /var/cache/apt/*

RUN apt-get update && \
	cd /tmp && \
	git clone https://github.com/utuhiro78/merge-ut-dictionaries.git && \
	cd merge-ut-dictionaries/src/merge && \
	bash make.sh && \
	apt-get clean && \
	rm -rf /var/cache/apt/*

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install python3-software-properties && \
	/usr/bin/python3 -c "from softwareproperties.SoftwareProperties import SoftwareProperties; SoftwareProperties().enable_source_code_sources()" && \
	apt-get update && \
	apt-get clean && \
	rm -rf /var/cache/apt/*

# generate dictionary data
RUN mkdir /tmp/mozc-src && cd /tmp/mozc-src && \
	cat /tmp/merge-ut-dictionaries/src/merge/mozcdic-ut.txt >> /tmp/mozc-src/dictionary00.txt

# Configure debconf to use non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# prepare and build mozc
# Need to install a package with apt command if you get message like
# "dpkg-checkbuilddeps: error: Unmet build dependencies: ..."
RUN cd /tmp/mozc-src && \
	apt-src update && \
	apt-src install fcitx5 && \
	apt-src install fcitx5-mozc && \
    apt-src build fcitx5 && \
	apt-src build fcitx5-mozc && \
	rm -rf /var/cache/apt/*

CMD sh -c "cp /tmp/mozc-src/*.deb /ws/"

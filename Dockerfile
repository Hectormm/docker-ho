FROM debian:jessie
LABEL maintainer="Hector Martinez"

LABEL org.label-schema.vcs-url="https://github.com/Hectormm/docker-ho"
LABEL version="latest"

ARG HO_FILE_SHA256SUM=51E1DAA5383D5A5A4E4BE69CE372D6748CB636AF4910A30BE0159F5DAD82306D
ARG HO_FILE_VERSION=3.0/HO-3.0.2.2728

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install wget=* default-jre=* && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	wget -O /tmp/ho.deb https://sourceforge.net/projects/ho1/files/ho1/${HO_FILE_VERSION}.deb/download && \
	wget -O /tmp/ho.deb https://github.com/akasolace/HO/releases/download/${HO_FILE_VERSION}.deb && \
	echo "${HO_FILE_SHA256SUM}  /tmp/ho.deb"| sha256sum -c - && \
	dpkg -i /tmp/ho.deb && \
	export uid=1000 gid=1000 && \
	mkdir -p /home/user/hrf/ && \
	echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
	echo "user:x:${uid}:" >> /etc/group && \
	chown ${uid}:${gid} -R /home/user

USER user
ENV HOME /home/user
VOLUME /home/user/hrf/

ENTRYPOINT [ "/usr/bin/ho1" ]

FROM debian:buster-slim

RUN \
	useradd builder -u 1000 -m -G users && \
	chmod 755 /home/builder

RUN \	
	echo 'deb http://deb.debian.org/debian bookworm-backports main' > /etc/apt/sources.list.d/bookworm-backports.list &&\
	apt update && apt install -y golang-1.22 && \
	rm /etc/apt/sources.list.d/bookworm-backports.list && \
	apt update && apt install -y git rsync build-essential devscripts dh-systemd

ENV GOPATH=/home/builder/go

ENV GOROOT=/usr/lib/go-1.22
ENV PATH=/usr/lib/go-1.22/bin:${GOPATH}/bin:$PATH
RUN chown -R builder:builder /home/builder

USER root
COPY entrypoint /usr/local/sbin/entrypoint
RUN chmod 744 /usr/local/sbin/entrypoint
ENTRYPOINT ["/usr/local/sbin/entrypoint"]

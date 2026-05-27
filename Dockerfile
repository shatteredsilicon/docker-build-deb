FROM debian:buster-slim

RUN \
	useradd builder -u 1000 -m -G users && \
	chmod 755 /home/builder

# switch to archive repos
COPY sources.list /etc/apt/sources.list

RUN \
	apt update && \
	echo 'deb http://deb.debian.org/debian trixie-backports main' > /etc/apt/sources.list.d/trixie-backports.list && \
	apt update && apt install -y golang-1.25 && \
	rm /etc/apt/sources.list.d/trixie-backports.list

RUN apt update && apt install -y git rsync build-essential devscripts dh-systemd

ENV GOPATH=/home/builder/go

ENV GOROOT=/usr/lib/go-1.25
ENV PATH=/usr/lib/go-1.25/bin:${GOPATH}/bin:$PATH
RUN chown -R builder:builder /home/builder

USER root
COPY entrypoint /usr/local/sbin/entrypoint
RUN chmod 744 /usr/local/sbin/entrypoint
ENTRYPOINT ["/usr/local/sbin/entrypoint"]

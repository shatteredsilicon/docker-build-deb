FROM debian:buster-slim

RUN \
	useradd builder -u 1000 -m -G users && \
	chmod 755 /home/builder

RUN apt update && apt install -y curl
RUN curl https://dl.shatteredsilicon.net/misc/DEBS/SS-misc-archive-keyring.pgp > /usr/share/keyrings/SS-misc-archive-keyring.pgp
COPY ss-misc.list /etc/apt/sources.list.d/

RUN apt update && apt install -y golang-1.24 git rsync build-essential devscripts dh-systemd

ENV GOPATH=/home/builder/go

ENV GOROOT=/usr/lib/go-1.24
ENV PATH=/usr/lib/go-1.24/bin:${GOPATH}/bin:$PATH
RUN chown -R builder:builder /home/builder

USER root
COPY entrypoint /usr/local/sbin/entrypoint
RUN chmod 744 /usr/local/sbin/entrypoint
ENTRYPOINT ["/usr/local/sbin/entrypoint"]

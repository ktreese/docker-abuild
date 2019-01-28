FROM docker.io/alpine:3.8

MAINTAINER Kris Reese <ktreese@gmail.com>

WORKDIR /root

RUN apk --update add --no-cache alpine-sdk \
 && adduser -D builder \
 && addgroup builder abuild \
 && sed -i '/root ALL=/a builder ALL=\(ALL\) ALL' /etc/sudoers \
 && sed -i 's/#PACKAGER="Your Name <your@email.address>"/PACKAGER="Kris Reese <ktreese@gmail.com>"/' /etc/abuild.conf \
 && sed -i 's/#MAINTAINER/MAINTAINER/' /etc/abuild.conf \
 && mkdir -p /var/cache/distfiles \
 && chmod a+w /var/cache/distfiles


WORKDIR /home/builder
RUN su builder -c "git config --global user.name 'Kris Reese'" \
 && su builder -c "git config --global user.email 'ktreese@gmail.com'" \
 && su builder -c "newapkbuild duo_unix"

COPY resources/APKBUILD /home/builder/duo_unix
RUN chown builder:builder /home/builder/duo_unix/APKBUILD

CMD ["ash"]

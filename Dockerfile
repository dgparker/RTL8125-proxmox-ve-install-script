# ignore this dockerfile - my bash is terrible so i needed it for testing :)

FROM ubuntu:20.04
RUN apt-get update && apt-get install -y apt-utils iproute2 inetutils-ping

ADD setup.sh /tmp/setup.sh
ADD realtek-r8125-dkms_9.003.05-1_amd64.deb /tmp/realtek-r8125-dkms_9.003.05-1_amd64.deb 


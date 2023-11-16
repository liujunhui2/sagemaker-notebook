FROM ubuntu:20.04
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata
RUN apt-get install -y openssh-server sudo jq python3 python3-pip
RUN apt-get clean
RUN pip3 --no-cache-dir install jupyter
RUN mkdir /run/sshd
RUN useradd -rm -s /bin/bash -g root -G sudo aws
RUN echo "aws:aws" | chpasswd
ENV SSH_PORT=22
ENV MAPPED_PORT=2222
ENV JUPYTER_PORT=8888
ENV SSH_USER=ec2-user
ENV PATH="/opt/sagemaker-ssh:${PATH}"
EXPOSE 22
COPY sshd_config /etc/ssh/sshd_config
COPY start.sh /opt/sagemaker-ssh/train
RUN  chmod a+x /opt/sagemaker-ssh/train
WORKDIR /opt/sagemaker-ssh 
CMD train

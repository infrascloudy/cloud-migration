FROM ubuntu:16.04

RUN apt-get update && apt-get install -y software-properties-common

RUN apt-get update && apt-get install -y \
    python-boto \
    python-dev \
    python-pip

RUN pip install --upgrade pip

RUN pip install "awscli==1.14.9"

RUN pip install "ansible==2.4.1.0"

RUN pip install "pyopenssl==17.3.0"

RUN pip install "pywinrm==0.2.2"

#
# Steps to install sqlcmd (Linux SQL Server client) in the container
#
RUN apt-get install -y \
    apt-transport-https \
    wget

RUN wget https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update

ENV ACCEPT_EULA=Y

RUN apt-get install -y \
  locales \
  mssql-tools \
  unixodbc-dev

RUN locale-gen en_US.UTF-8

ENV PATH /opt/mssql-tools/bin:$PATH

#
# Steps to install Terraform
#

ENV TERRAFORM_VERSION 0.11.7

RUN apt-get install -y \
    unzip \
    wget

RUN wget -q -O /terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip /terraform.zip -d /bin && \
    rm -rf /terraform.zip

VOLUME ["/data"]
WORKDIR /data

#
# Main section
#

COPY ansible /ansible

COPY terraform /terraform

WORKDIR /

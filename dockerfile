FROM ubuntu:22.04


LABEL MAINTAINER "Constantine Vlahos <cvlahos@smarttech.com>"


# Set noninteractive installation  
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Edmonton  


# Build a ubuntu 20.04 base image
# Update package lists, install packages, and clean up
RUN apt-get update \  
    && apt-get upgrade -y \  
    && apt-get install --no-install-recommends -y \  
        ccache \  
        cmake \  
        unzip \  
        wget \  
        git \  
        python3 \  
        python3-venv \   
        python3-distutils \  
        python3-pip \  
    && apt-get clean \  
    && apt-get autoremove  
  
# Install gcloud CLI
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-423.0.0-linux-x86_64.tar.gz \  
    && tar zxvf google-cloud-sdk-423.0.0-linux-x86_64.tar.gz google-cloud-sdk \  
    && ./google-cloud-sdk/install.sh \  
    && rm google-cloud-sdk-423.0.0-linux-x86_64.tar.gz  
  
# Install Golang v1.13.4  
RUN wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz \  
    && tar -C /usr/local -xzf go1.13.4.linux-amd64.tar.gz \  
    && rm go1.13.4.linux-amd64.tar.gz  
  
# Add Go to PATH  
ENV PATH $PATH:/usr/local/go/bin  


# Copy requirements files into the Docker image  
COPY ./setupFiles/requirements_awscli.txt /tmp/  
COPY ./setupFiles/requirements_azure.txt /tmp/  
COPY ./setupFiles/requirements_google.txt /tmp/  


# Install Python packages  
RUN pip3 install --no-cache-dir -r /tmp/requirements_awscli.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements_azure.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements_google.txt


# Create devops_python_venv
RUN python3 -m venv /usr/local/virt_env/virt-3-DevOps
RUN chmod 755 /usr/local/virt_env/virt-3-DevOps/bin/activate  


# Download and installing Terraform
RUN apt-get update && apt-get install -y curl
RUN curl -fsSL https://smartvcs.visualstudio.com/_git/DevOps?path=/bin/terraform_update -o /usr/local/bin/terraform_update
RUN chmod +x /usr/local/bin/terraform_update
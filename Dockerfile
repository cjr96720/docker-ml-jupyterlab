FROM ubuntu:20.04

# Install Ubuntu packages
RUN apt-get update \
    && apt-get upgrade -y
RUN apt-get install -y \
    wget \
    dkms \
    build-essential \
    curl \
    git-core \
    unzip \
    vim \
    git

# Setup Timezone
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ /etc/Timezone

# Install Python and PIP
RUN apt-get update \
    && apt-get install -y software-properties-common 
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update \
    && apt install -y python3-pip

# Setup User
RUN useradd -m -d /home/devuser -s /bin/bash devuser
USER devuser
WORKDIR /home/devuser/projects

# Setup Python Path
ENV PATH=/home/devuser/.local/bin:$PATH

# Install Python packages
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Config JupyterLab
RUN jupyter lab --generate-config
COPY jupyter_lab_config.py /home/devuser/.jupyter/jupyter_lab_config.py

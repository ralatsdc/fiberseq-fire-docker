# Pin base image
# See: https://hub.docker.com/r/continuumio/miniconda3
FROM continuumio/miniconda3@sha256:166ff37fba6c25fcad8516aa5481a2a8dfde11370f81b245c1e2e8002e68bcce
LABEL description="Base docker image with conda and util libraries"

# Install procps (so that Nextflow can poll CPU usage)
RUN apt-get update && \
    apt-get install -y \
            procps \
            rsync && \
    apt-get clean -y

# Work in root
WORKDIR /root

# Install the conda environment
ARG ENV_NAME=fiberseq-fire
COPY environment.yaml /
RUN conda env create --quiet --name ${ENV_NAME} --file /environment.yaml -y && \
    conda clean -a

# Install the UCSC kent utilities
RUN rsync -aP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/ /usr/local/bin

# Clone the repository and checkout the specified release
ARG VERSION=v0.0.3
RUN git clone https://github.com/fiberseq/FIRE.git && \
    cd FIRE && \
    git checkout ${VERSION}

# Add conda installation and root dirs to PATH (instead of doing
# 'conda activate' or specifiying path to tool)
ENV PATH="/opt/conda/envs/$ENV_NAME/bin:/root:$PATH"

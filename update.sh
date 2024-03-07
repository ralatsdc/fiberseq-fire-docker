#!/usr/bin/env bash
# Run this script in base image:
# $ docker run -itv $PWD:/root -w /root continuumio/miniconda3@sha256:166ff37fba6c25fcad8516aa5481a2a8dfde11370f81b245c1e2e8002e68bcce
eval "$(conda shell.bash hook)"
conda create -n fiberseq-fire -c conda-forge -c bioconda 'snakemake>=8.4' -y
conda activate fiberseq-fire
conda env export | grep -v prefix > environment.yaml
conda deactivate
conda env remove -n fiberseq-fire

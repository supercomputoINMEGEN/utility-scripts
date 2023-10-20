#!/bin/bash

# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
wget https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh \
&& bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda -to-bash-profile yes \
&& rm Miniconda3-latest-Linux-x86_64.sh

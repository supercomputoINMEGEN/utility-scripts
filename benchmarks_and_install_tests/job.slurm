#!/bin/bash

#SBATCH --job-name=mytest
#SBATCH --node=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:01:00

sleep 30

echo "Hola $(hostname)"

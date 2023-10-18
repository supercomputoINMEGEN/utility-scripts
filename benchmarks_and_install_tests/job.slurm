#!/bin/bash

#SBATCH --job-name=mytest

sleep 30

echo "Hola $(hostname)"

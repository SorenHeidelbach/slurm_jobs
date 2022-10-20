#!/usr/bin/env bash
#SBATCH --job-name megalodon
#SBATCH --partition batch
#SBATCH --time 3:00:00
#SBATCH --qos=short
#SBATCH --gres=gpu:1
#SBATCH --nodelist=nv-ai-03.srv.aau.dk
#SBATCH --output="signal_map%a.out"

#jobs/map_signal.sh "/user/bio.aau.dk/lx38ll/modification_binning/data/processed/KE3/NAT/fast5_600mb" \
#  "/user/bio.aau.dk/lx38ll/modification_binning/results/KE3/medaka/consensus.fasta"
jobs/map_signal.sh "/user/bio.aau.dk/lx38ll/modification_binning/data/processed/DE4/NAT/fast5_600mb" \
  "/user/bio.aau.dk/lx38ll/modification_binning/results/KE3/medaka/consensus.fasta"

jobs/map_signal.sh "/user/bio.aau.dk/lx38ll/modification_binning/data/processed/KS3/NAT/fast5_600mb" \
  "/user/bio.aau.dk/lx38ll/modification_binning/results/KS3/medaka/consensus.fasta"
jobs/map_signal.sh "/user/bio.aau.dk/lx38ll/modification_binning/data/processed/DS4/NAT/fast5_600mb" \
  "/user/bio.aau.dk/lx38ll/modification_binning/results/KS3/medaka/consensus.fasta"




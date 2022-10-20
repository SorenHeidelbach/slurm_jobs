#!/usr/bin/env bash
#SBATCH --job-name megalodon
#SBATCH --partition batch
#SBATCH --time 3:00:00
#SBATCH --qos=short
#SBATCH --gres=gpu:1
#SBATCH --nodelist=nv-ai-03.srv.aau.dk
#SBATCH --output="signal_map%a.out"

# make directionary for raid storage
SAMPLE="KE3"
TYPE="NAT"
MODEL="dna_r10.4.1_e8.2_400bps_sup.cfg"
guppy_server_path="/user/bio.aau.dk/lx38ll/bin/ont-guppy/bin/guppy_basecall_server"
FAST5="/user/bio.aau.dk/lx38ll/modification_binning/data/processed/$SAMPLE/$TYPE/fast5_600mb"
REF="/user/bio.aau.dk/lx38ll/modification_binning/results/$SAMPLE/medaka/consensus.fasta"
RAID="/raid/bio.lx38ll"
FAST5_RAID="$RAID/megalodon/$SAMPLE/$TYPE/fast5"
OUT="/user/bio.aau.dk/lx38ll/modification_binning/data/processed/$SAMPLE/$TYPE/megalodon"

mkdir -p $RAID 
cd $WD
mkdir -p $OUT

# Transfer fast5 to high I/O RAID
if [[ ! -d $FAST5_RAID ]]; then
  mkdir -p $FAST5_RAID
fi
raid_diff=$(diff $FAST5 $FAST5_RAID)
if [[ ! -z "$raid_diff"  ]]; then
  mkdir -p $FAST5_RAID
  cp -r $FAST5 $FAST5_RAID
fi

megalodon \
  $FAST5_RAID \
  --reference $REF \
  --output-directory $OUT \
  --outputs mappings signal_mappings \
  --guppy-params "-d /user/bio.aau.dk/lx38ll/bin/ont-guppy/data/" \
  --guppy-config $MODEL \
  --devices 0 \
  --guppy-server-path $guppy_server_path \
  --overwrite


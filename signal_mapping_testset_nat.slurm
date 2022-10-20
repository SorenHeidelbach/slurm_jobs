#!/usr/bin/env bash
#SBATCH --job-name megalodon
#SBATCH --partition batch
#SBATCH --time 3:00:00
#SBATCH --qos=short
#SBATCH --gres=gpu:1
#SBATCH --nodelist=nv-ai-03.srv.aau.dk
#SBATCH --output="megalodon%a.out"

# make directionary for raid storage
RAID="/raid/bio.lx38ll"
mkdir -p $RAID 

# results output
WD="/user/bio.aau.dk/lx38ll/modification_binning/zymoHMW_testset"
cd $WD
OUT="nat/megalodon"
mkdir -p $OUT

# fast5 paths
FAST5="$RAID/megalodon/zymoHMW/nat/fast5"
FAST5_store="nat/fast5/"
REF="zymoHMW_references.fasta"
guppy_server_path="/user/bio.aau.dk/lx38ll/bin/ont-guppy/bin/guppy_basecall_server"

# Transfer fast5 to high I/O RAID
if [[ ! -d $FAST5 ]]; then
  mkdir -p $FAST5
fi
raid_diff=$(diff $FAST5 $FAST5_store)
if [[ ! -z "$raid_diff"  ]]; then
  mkdir -p $FAST5
  cp -r $FAST5_store $FAST5
fi

megalodon \
  $FAST5 \
  --reference $REF \
  --output-directory $OUT \
  --outputs basecalls mappings signal_mappings \
  --guppy-config "dna_r9.4.1_450bps_hac.cfg" \
  --devices 0 \
  --guppy-server-path $guppy_server_path \
  --overwrite




# make directionary for raid storage
FAST5=$1
REF=$2

RAID="/raid/bio.lx38ll"
FAST5_RAID="$RAID/megalodon/fast5"
OUT="$(dirname $FAST5)/megalodon"

MODEL="dna_r10.4.1_e8.2_400bps_sup.cfg"
guppy_server_path="/user/bio.aau.dk/lx38ll/bin/ont-guppy/bin/guppy_basecall_server"

mkdir -p $RAID 
mkdir -p $OUT

# Transfer fast5 to high I/O RAID
if [[ ! -d $FAST5_RAID ]]; then
  mkdir -p $FAST5_RAID
  else
  rm -r $FAST5_RAID
  mkdir -p $FAST5_RAID
fi
raid_diff=$(diff $FAST5 $FAST5_RAID)
if [[ ! -z "$raid_diff"  ]]; then
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


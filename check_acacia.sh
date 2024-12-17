#!/bin/bash


# Read the OGLIST from the data audit
OGLIST_FILE=list.txt
tsv=acacia_audit.tsv

echo -e "OG\tSAMP\tassembly\tsize" > $tsv

# Loop through each OGID in the OGLIST file
while IFS= read -r OGID; do
  echo "$OGID"
  OG=$(echo $OGID | awk '{print $1}')
  SAMP=$(echo $OGID | awk '{print $2}')
  echo "$OG"
  echo "$SAMP"
  assembly="${SAMP}.v129mh.fna"
  echo "$assembly"

  remote_path=pawsey0812:oceanomics-genomes/genomes.v2/$OG/assemblies/genome/$assembly
    

    # Check if the remote file exists
  if rclone ls "$remote_path" > /dev/null 2>&1; then
    SIZES=$(echo $(rclone size "$remote_path" | awk -F'Total size: ' '{print $2}' | awk '{print $1, $2}'))
    echo "$SIZES"
    # Format and append the results to the TSV
    echo -e "$OG\t$SAMP\t$assembly\t$SIZES" >> $tsv
  else
    echo "Warning: File '$remote_path' does not exist."
    # Optionally, append a message to the output or handle the absence of the file differently
    echo -e "$OG\t$SAMP\t$assembly\tFile not found" >> $tsv
  fi
done < "$OGLIST_FILE"


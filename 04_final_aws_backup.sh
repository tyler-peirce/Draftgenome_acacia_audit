#!/bin/bash --login

#---------------
#Requested resources:
#SBATCH --account=pawsey0812
#SBATCH --job-name=12o_final_aws_backup
#SBATCH --partition=work
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=14:00:00
#SBATCH --mem=10G 
#SBATCH --export=ALL
#SBATCH --output=%x-%j.out #SBATCH --error=%x-%j.err


. ../configfile.txt

## pull out the final fasta files and the filtered and trimmed reads to upload to AWS

for i in "$rundir"/OG*; do
    if [ -d "$i" ]; then  # Check if the item in $rundir is a directory
        SAMPLE=$(basename "$i")
        fasta="$rundir/$SAMPLE/assemblies/genome/*.fna"
        reads="$rundir/$SAMPLE/fastp/*.fastq.gz"
        
        mkdir -p $AWS
        newdir=$AWS/$SAMPLE
        mkdir -p $newdir
                
        #(this will put the *.fna & reads into directorys with their OG numbers for storage)
        cp $fasta $newdir
        if [ $? -ne 0 ]; then
            echo "Copy failed"
        fi

        cp $reads $newdir
        if [ $? -ne 0 ]; then
            echo "Copy failed"
        fi

    fi
done
 

wait 

# you can use either rclone or aws to copy the files over. Hash out which ever one you dont want to use.
rclone copy $AWS/ s3://oceanomics/OceanGenomes/analysed-data/draft-genomes/ --checksum #--progress
#aws s3 cp --recursive $dir s3://oceanomics/OceanGenomes/analysed-data/draft-genomes/
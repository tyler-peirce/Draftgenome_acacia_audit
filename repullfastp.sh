#!/bin/bash --login
#SBATCH --account=pawsey0812
#SBATCH --job-name=aws-raw-backup
#SBATCH --partition=work
#SBATCH --mem=15GB
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --export=NONE

. ~/.bashrc
#this script is to pull the fastp files if pawsey has deleted them

list=missing_list.txt


while IFS= read -r line; do
    og=$(echo "$line")
    echo "og = $og"
    #assembly=$(rclone lsf pawsey0812:oceanomics-genomes/genomes.v2/$og/assemblies/genome/ | grep '\.fna$')

    #mkdir -p /scratch/pawsey0812/tpeirce/DRAFTGENOME/_Draftgenome_acacia_audit/missing_aws/$og
    #rclone copy pawsey0812:oceanomics-genomes/genomes.v2/$og/assemblies/genome/$assembly /scratch/pawsey0812/tpeirce/DRAFTGENOME/_Draftgenome_acacia_audit/missing_aws/$og --checksum --progress
    
    mkdir -p /scratch/pawsey0812/tpeirce/DRAFTGENOME/_Draftgenome_acacia_audit/run_stats/$og
    rclone copy pawsey0812:oceanomics-genomes/genomes.v2/$og /scratch/pawsey0812/tpeirce/DRAFTGENOME/_Draftgenome_acacia_audit/run_stats/$og --checksum --progress
    
    #r1=$(rclone lsf pawsey0812:oceanomics-genomes/genomes.v2/$og/fastp | grep '\.R1.fastq.gz$')
    #r2=$(rclone lsf pawsey0812:oceanomics-genomes/genomes.v2/$og/fastp | grep '\.R2.fastq.gz$')
    #rclone copy pawsey0812:oceanomics-genomes/genomes.v2/$og/fastp/$r1 /scratch/pawsey0812/tpeirce/DRAFTGENOME/_Draftgenome_acacia_audit/missing_aws/$og --checksum --progress
    #rclone copy pawsey0812:oceanomics-genomes/genomes.v2/$og/fastp/$r2 /scratch/pawsey0812/tpeirce/DRAFTGENOME/_Draftgenome_acacia_audit/missing_aws/$og --checksum --progress

    #r1=$(rclone lsf pawsey0812:oceanomics-fastq/$og/fastp | grep '\.R1.fastq.gz$')
    #r2=$(rclone lsf pawsey0812oceanomics-fastq/$og/fastp | grep '\.R2.fastq.gz$')
    #rclone copy pawsey0812:oceanomics-fastq/$og/fastp/$r1 /scratch/pawsey0812/tpeirce/DRAFTGENOME/_Draftgenome_acacia_audit/missing_aws/$og --checksum --progress
    #rclone copy pawsey0812:oceanomics-fastq/$og/fastp/$r2 /scratch/pawsey0812/tpeirce/DRAFTGENOME/_Draftgenome_acacia_audit/missing_aws/$og --checksum --progress
done < "$list"

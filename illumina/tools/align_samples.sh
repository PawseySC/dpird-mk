#!/bin/bash

if [ "$#" -lt 1 ] ; then
 echo "Argument required: name of file containing list of input FASTA files. Exiting."
 exit
fi
if [ ! -s $1 ] ; then
 echo "File "$1" does not exist or is empty. Exiting."
 exit
fi

list_prefix_out="$1"

cat << 'EOF' >sbatch_align_samples_${list_prefix_out}.sh
#!/bin/bash -l

#SBATCH --job-name=sbatch_align_samples_FILELIST
#SBATCH --output=%x.out
#SBATCH --account=pawsey0281
#SBATCH --clusters=zeus
#SBATCH --partition=workq
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=50G
#SBATCH --export=NONE 
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# shifter definitions
module load shifter
srun_cmd="srun --export=all"
mafft_cont="quay.io/biocontainers/mafft:7.407--0"

list_prefix_in="FILELIST"

# running
echo Working directory : $(pwd)
echo SLURM job id : $SLURM_JOB_ID

# building fasta input for mafft
cat $(cat ${list_prefix_in} |xargs) >input_align_samples_${list_prefix_in}.fasta

# multiple alignment of selected consensus sequences
$srun_cmd shifter run $mafft_cont mafft-linsi \
	--thread $OMP_NUM_THREADS \
	input_align_samples_${list_prefix_in}.fasta >output_align_samples_${list_prefix_in}.fasta
EOF

sed -i "s/FILELIST/${list_prefix_out}/g" sbatch_align_samples_${list_prefix_out}.sh

jobid=$( sbatch --parsable sbatch_align_samples_${list_prefix_out}.sh | cut -d ";" -f 1 )
echo "Submitted sbatch_align_samples_"${list_prefix_out}".sh with Job ID "$jobid"."

exit

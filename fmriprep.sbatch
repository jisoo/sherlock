#!/usr/bin/env bash
#
#SBATCH -J fmriprep
#SBATCH --time=24:00:00
#SBATCH --array=1-5
#SBATCH -n 1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=32G

# Outputs ----------------------------------
#SBATCH -o log/%x-%A-%a.out
#SBATCH -e log/%x-%A-%a.err
#SBATCH --mail-user=%u@stanford.edu
#SBATCH --mail-type=ALL
# ------------------------------------------

FMRIPREP_OPTS="--omp-nthreads 8 --nthreads 12 --mem_mb 30000 --output-spaces T1w fsaverage6 fsaverage5 fsnative MNI152NLin6Asym MNI152NLin2009cAsym --medial-surface-nan --use-syn-sdc --cifti-output --use-aroma --skip_bids_validation --longitudinal --bold2t1w-dof 12 --dummy-scans 6 --return-all-components"

unset PYTHONPATH
subject=$( sed "${SLURM_ARRAY_TASK_ID}q;d" ${SUBJECT_LIST} )
cmd="singularity run --cleanenv -B /home/groups/russpold/software/fsl-5.0.11:/usr/share/fsl/5.0 $SINGULARITY_BIN/fmriprep.simg ${BIDS_DIR} ${OUT_DIR} participant --participant-label $subject --fs-license-file ~/license/freesurfer.txt -w ${WORK_DIR} ${FMRIPREP_OPTS}"
echo Running task ${SLURM_ARRAY_TASK_ID}
echo Commandline: $cmd
eval $cmd

echo Finished tasks ${SLURM_ARRAY_TASK_ID}

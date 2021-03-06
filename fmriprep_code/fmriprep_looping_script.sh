#!/bin/bash

#for use on server with slurm sbatch scripts

script_dir=/blue/stevenweisberg/stevenweisberg/MVPA_ARROWS/code/hipergator
BIDS_dir=/blue/stevenweisberg/stevenweisberg/MVPA_ARROWS/derivatives/bids
output_dir=/blue/stevenweisberg/stevenweisberg/MVPA_ARROWS/derivatives/fmriprep
freesurfer_dir=/blue/stevenweisberg/freesurfer_license
singularity_dir=/blue/stevenweisberg/stevenweisberg/hipergator_neuro/fmriprep/fmriprep-20.1.1.simg



# loops through subjects
for SUB in {112..128}
do

    # Skip 111 and 119
    [ "$SUB" -eq 111 ] && continue
    [ "$SUB" -eq 119 ] && continue

#copies processing and preprocessing scripts in to subject folder
 cp $script_dir/fmriprep_slurm.sh $script_dir/fmriprep_slurm_run_$sub.sh


#renames variable in fsl melodic, fsl feat, and freesurfer recon-all processing script to subject number
 sed -i -e "s|SUB_sed|${SUB}|g" fmriprep_slurm_run_$sub.sh
 sed -i -e "s|BIDS_sed|${BIDS_dir}|g" fmriprep_slurm_run_$sub.sh
 sed -i -e "s|OUTPUT_sed|${output_dir}|g" fmriprep_slurm_run_$sub.sh
 sed -i -e "s|SINGULARITY_sed|${singularity_dir}|g" fmriprep_slurm_run_$sub.sh
 sed -i -e "s|VERSION_sed|${version}|g" fmriprep_slurm_run_$sub.sh
 sed -i -e "s|FREESURFER_sed|${freesurfer_dir}|g" fmriprep_slurm_run_$sub.sh


#runs subject-level preprocessing scripts via sbatch on the hipergator
   sbatch fmriprep_slurm_run_$sub.sh

done

#removing the run script
 rm fmriprep_slurm_run*.sh
                  

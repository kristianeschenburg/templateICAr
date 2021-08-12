#!/bin/bash
#$ -t 1-100:1
#$ -tc 100
#$ -V
#$ -o /mnt/home/keschenb/templateICA/
#$ -e /mnt/home/keschenb/templateICA/
#$ -q global.q

subject_list=$1
session=$2
encoding=$3
components=$4

script_dir=/mnt/parcellator/parcellation/Code/templateICAr

template_mean=${script_dir}/data/L.d${components}.TemplateICA_mean.func.gii
template_variance=${script_dir}/data/L.d${components}.TemplateICA_var.func.gii
medial_wall=${script_dir}/data/L.mwall.Rdata

# load subjects into array
SUBJECTS=()
while IFS= read -r line; do
  SUBJECTS+=("${line}")
done < ${subject_list}

LENGTH=${#SUBJECTS[@]} 
echo Number of subjects in array: $LENGTH

echo SGE_TASK_ID: $SGE_TASK_ID

# array indecies start at 0, SGE_TASK_ID starts at 1 
INDX=`expr $SGE_TASK_ID - 1`;

if [[ $INDX -ge $LENGTH ]]; then 

    echo Array index greater than number of elements 
    
else 

    SUBJ=${SUBJECTS[$INDX]} 

    subject_directory=/projects3/parcellation/data/test_retest/${SUBJ}

    bold_dir=${subject_directory}/resting_state
    bold_file=${SUBJ}.L.rfMRI_REST${session}_${encoding}.Z-Trans.func.gii
    bold_file=${bold_dir}/${bold_file}

    output_dir=${subject_directory}/TemplateICA
    output_file=${SUBJ}.L.rfMRI_REST${session}_${encoding}.d${components}
    output_base=${output_dir}/${output_file}

	python ${script_dir}/bin/template_ICA.R --boldFile=${bold_file} \
                                            --templateMean=${template_mean} \
                                            --templateVariance=${template_variance} \
                                            --mwall=${medial_wall} \
                                            --outBase=${output_base}


fi
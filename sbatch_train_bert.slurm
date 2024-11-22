#!/bin/bash
#SBATCH --partition=gpu           # Partition (queue) name
#SBATCH -n 1                # Number of cores
#SBATCH --time=0-12:00          # Runtime in D-HH:MM
#SBATCH --job-name=open_G_dino      # Job name
#SBATCH --gpus-per-node=2               # Number of GPUs per node
#SBATCH --ntasks=1                  # Total number of tasks
#SBATCH --ntasks-per-node=1         # Tasks per node
#SBATCH --cpus-per-task=4           # CPUs per task
#SBATCH --mem-per-cpu 32000         # Memory per node
#SBATCH --output=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/%x_%j.out          # Standard output log
#SBATCH --error=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/%x_%j.err           # Standard error log
#SBATCH --export=ALL        # Pass any exported env vars to this script and its children

# Check for conda environment name, default to "grounding_dino" if not provided
if [ $# -eq 1 ]; then
    ENV_NAME=$1
else
    ENV_NAME="grounding_dino"
    echo "No conda environment specified. Using default: ${ENV_NAME}"
fi

# Create output directory with timestamp and job ID
OUTPUT_DIR="/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/bert-output-$(date '+%b-%d-%Y_%I-%M%p')-job${SLURM_JOB_ID}"  # Example: output-Nov-21-2024_02-30PM-job12345
echo "Creating output directory: ${OUTPUT_DIR}"

# Create the directory
mkdir -p ${OUTPUT_DIR}

# Load required modules and activate conda environment
module load anaconda
module load cuda/11.6
conda deactivate
conda activate ${ENV_NAME}

# Run the training script
python -u main.py \
    --output_dir ${OUTPUT_DIR} \
    -c /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/cfg_odvg.py \
    --datasets /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/med_mixed.json \
    --pretrain_model_path /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/dino_model/groundingdino_swint_ogc.pth \
    --options text_encoder_type=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/bert

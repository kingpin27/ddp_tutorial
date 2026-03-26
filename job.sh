#!/bin/bash
#SBATCH --job-name=ddp
#SBATCH --partition=ada
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --gres=gpu:2
#SBATCH --time=1:00:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

echo "Node: $(hostname)"
nvidia-smi

module purge
module load cuda/12.4

# Initialize conda for non-interactive shell
source /home/anirban/anishc/miniconda3/etc/profile.d/conda.sh
conda activate collm5

echo "Setting up CWD..."
cd /home/anirban/anishc/ddp_tutorial

start_ts=$(date +%s)
echo "Traininig started at: $(date '+%Y-%m-%d %H:%M:%S')"

PYTHON="/home/anirban/anishc/miniconda3/envs/collm5/bin/python"
srun "$PYTHON" main.py

end_ts=$(date +%s)
elapsed_sec=$((end_ts - start_ts))
echo "Training finished at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Total runtime: ${elapsed_sec} seconds"

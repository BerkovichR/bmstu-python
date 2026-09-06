#!/usr/bin/env bash
# Idempotent bootstrap for the bmstu-python course materials.
# Installs the system prerequisites for Python virtual environments and then
# creates/refreshes a local venv containing the Jupyter toolchain used to run
# the seminar and lab notebooks.
set -euo pipefail

cd "$(dirname "$0")/.."

# System packages required to build virtual environments (and to compile
# native wheels such as cffi if a prebuilt wheel is unavailable).
if ! dpkg -s python3.12-venv >/dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y --no-install-recommends python3.12-venv build-essential
fi

# Create the virtual environment once; reuse it on subsequent runs.
if [ ! -x .venv/bin/python ]; then
  python3 -m venv .venv
fi

.venv/bin/pip install --upgrade pip
.venv/bin/pip install -r requirements.txt

# Register the venv as a Jupyter kernel so the notebooks run against it.
.venv/bin/python -m ipykernel install --user --name bmstu-python --display-name "Python (bmstu-python)"

echo "install.sh completed successfully"

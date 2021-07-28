#!/usr/bin/env bash

set -e
set -x

# Install Python
sudo apt-get update
sudo apt-get install --assume-yes \
  git \
  python3 \
  python3-distutils \
  python-is-python3

# Configure local bin directory
mkdir --parents "${HOME}/.local/bin"
grep -qxF '  PATH="$HOME/.local/bin:$PATH"' ~/.bashrc || cat <<EOT >> ~/.bashrc

# set PATH so it includes user's private bin if it exists
if [ -d "\$HOME/.local/bin" ] ; then
  PATH="\$HOME/.local/bin:\$PATH"
fi
EOT
. ~/.bashrc

# Install PIP
curl --location --silent https://bootstrap.pypa.io/get-pip.py | python3

# Configure local bin directory
. ~/.bashrc

# Fetch Repository
if [ ! -d ~/.wsl-setup ]
then
  git clone https://github.com/rodrigoscna/wsl-setup.git ~/.wsl-setup
fi
(cd ~/.wsl-setup \
  && pip install --requirement requirements.txt \
  && ansible-galaxy collection install --requirements-file requirements.yaml \
  && ansible-playbook --ask-become-pass --inventory hosts playbook.yaml)

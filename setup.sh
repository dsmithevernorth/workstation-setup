#!/usr/bin/env bash
#
# setup.sh:  run the workstation setup
#
# Arguments:
#   - a list of components to install, see scripts/opt-in/ for valid options
#
# Environment variables:
#   - SKIP_ANALYTICS:  Set this to 1 to not send usage data to our Google Analytics account
#

# Fail immediately if any errors occur
set -e

echo "Caching password..."
sudo -K
sudo true;
clear

MY_DIR="$(dirname "$0")"
SKIP_ANALYTICS=${SKIP_ANALYTICS:-0}
if (( SKIP_ANALYTICS == 0 )); then
    clientID=$(od -vAn -N4 -tx  < /dev/urandom)
    source ${MY_DIR}/scripts/helpers/google-analytics.sh ${clientID} start $@
else
    export HOMEBREW_NO_ANALYTICS=1
fi

# Note: Homebrew needs to be set up first
source ${MY_DIR}/scripts/common/homebrew.sh


# Install everything else

# Terminal
#source ${MY_DIR}/scripts/common/bitwarden.sh
#source ${MY_DIR}/scripts/common/oh-my-zsh.sh
#source ${MY_DIR}/scripts/common/iterm2.sh
#source ${MY_DIR}/scripts/common/git.sh
#source ${MY_DIR}/scripts/common/oh-my-zsh-custom-plugins.sh

# Database Client
source ${MY_DIR}/scripts/common/dbeaver.sh
# Other
#source ${MY_DIR}/scripts/opt-in/python.sh
#source ${MY_DIR}/scripts/opt-in/kubernetes.sh
#source ${MY_DIR}/scripts/opt-in/node.sh
#source ${MY_DIR}/scripts/opt-in/terraform.sh
#source ${MY_DIR}/scripts/opt-in/docker.sh

# AWS
source ${MY_DIR}/scripts/common/localstack.sh
source ${MY_DIR}/scripts/common/aws_iam.sh

# IDE 
source ${MY_DIR}/scripts/common/visual-studio-code.sh

# Browser 
source ${MY_DIR}/scripts/common/google-chrome.sh

# Music 
source ${MY_DIR}/scripts/common/spotify.sh


# Not required 

# source ${MY_DIR}/scripts/common/editors.sh

# source ${MY_DIR}/scripts/common/git-aliases.sh
# source ${MY_DIR}/scripts/common/applications-common.sh
# source ${MY_DIR}/scripts/common/developer-utilities.sh
# source ${MY_DIR}/scripts/common/unix.sh
# source ${MY_DIR}/scripts/common/configuration-osx.sh

# For each command line argument, try executing the corresponding script in opt-in/
for var in "$@"
do
    echo "$var"
    FILE=${MY_DIR}/scripts/opt-in/${var}.sh
    echo "$FILE"
    if [ -f $FILE ]; then
        source ${FILE}
    else
       echo "Warning: $var does not appear to be a valid argument. File $FILE does not exist."
    fi
done

source ${MY_DIR}/scripts/common/finished.sh
if (( SKIP_ANALYTICS == 0 )); then
    source ${MY_DIR}/scripts/helpers/google-analytics.sh ${clientID} finish $@
fi

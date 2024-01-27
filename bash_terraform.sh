#!/bin/bash

set -e

case $OSTYPE in
  *linux*)
    platform=linux
    ;;
  *darwin*)
    platform=darwin
    ;;
  *)
    echo "Unsupported platform"
    exit 1
    ;;
esac


arch=$HOSTTYPE
# Fix arch discrepancy where x86_64 is amd64 here
if [[ $arch == x86_64 ]]; then arch=amd64; fi


function installProviderVersion() {
  company="$1"
  provider="$2"
  version="$3"


  folder="$HOME/terraform-providers/registry.terraform.io/${company}/${provider}/${version}/${platform}_${arch}"
  tmpfolder="$HOME/tmp-tf"
  file="terraform-provider-${provider}_${version}_${platform}_${arch}.zip"


  if [ -d $folder ]; then
    printf "Skipping install of Terraform provider %-35s , already exists at $folder\n" "$1/$2/$3"
  else
    echo "INSTALLING Terraform provider $1/$2/$3 ..."
    mkdir -p "$folder" "$tmpfolder"
    cd "$tmpfolder"


    if [ "$company" == "splunk" -o "$company" == "scottwinkler" -o "$company" == "yannh" ]; then
      echo "curl -L https://github.com/${company}/terraform-provider-${provider}/releases/download/v${version}/${file}"
      curl -L https://github.com/${company}/terraform-provider-${provider}/releases/download/v${version}/${file} -o "${file}"
    else
      curl https://releases.hashicorp.com/terraform-provider-${provider}/${version}/${file} -o "$file"
    fi


    unzip -o "$file" -d "$folder"
    rm "$file"
  fi
}


function installTerraform() {
  version="$1"
  custom_folder="$2"
  # Set default folder to $HOME/bin if not provided
  folder="${custom_folder:-$HOME/bin}"
  tmpfolder="$HOME/tmp-tf"
  file="terraform_${version}_${platform}_${arch}.zip"
  if which terraform-${version}; then
    printf "Skipping install of Terraform binary version %-10s , already installed\n" "$version"
  else
    echo "INSTALLING Terraform binary $1 ..."
    mkdir -p "$tmpfolder"
    cd "$tmpfolder"
    curl https://releases.hashicorp.com/terraform/${version}/${file} -o "$file" && \
    unzip -p "$file" terraform > terraform-${version} && \
    mkdir -p "${folder}" && \
    mv terraform-${version} "${folder}" && \
    chmod a+x "${folder}/terraform-${version}"
    rm -f "$file" terraform-${version}
  fi
}

installProviderVersion  hashicorp     null          3.1.1
installProviderVersion  hashicorp     null          3.2.1


installProviderVersion  hashicorp     random        3.5.1
installProviderVersion  hashicorp     time          0.9.1
installProviderVersion  hashicorp     local         2.4.0
installProviderVersion  hashicorp     tls           4.0.4


installProviderVersion  hashicorp     aws           3.74.1
installProviderVersion  hashicorp     aws           4.9.0
installProviderVersion  hashicorp     aws           4.54.0
installProviderVersion  hashicorp     aws           4.56.0
installProviderVersion  hashicorp     aws           4.67.0
installProviderVersion  hashicorp     aws           5.20.1


installProviderVersion  hashicorp     archive       2.3.0


installProviderVersion  mongodb       mongodbatlas  1.2.0
installProviderVersion  mongodb       mongodbatlas  1.3.1
installProviderVersion  mongodb       mongodbatlas  1.4.6
installProviderVersion  mongodb       mongodbatlas  1.5.0
installProviderVersion  mongodb       mongodbatlas  1.6.1
installProviderVersion  mongodb       mongodbatlas  1.7.0
installProviderVersion  mongodb       mongodbatlas  1.8.0


installProviderVersion  splunk        splunk        1.4.17


installProviderVersion  scottwinkler  shell         1.7.10


installProviderVersion  hashicorp     google        4.44.1
installProviderVersion  hashicorp     google        4.47.0
installProviderVersion  hashicorp     google        4.52.0
installProviderVersion  hashicorp     google        4.53.0
installProviderVersion  hashicorp     google        4.53.1
installProviderVersion  hashicorp     google        4.73.1


installProviderVersion  lacework      lacework      1.9.0


installProviderVersion  yannh         statuspage    0.1.12


folder="${1:-$HOME/bin}" installTerraform 1.1.6
folder="${1:-$HOME/bin}" installTerraform 1.1.9
folder="${1:-$HOME/bin}" installTerraform 1.2.9
folder="${1:-$HOME/bin}" installTerraform 1.3.6
folder="${1:-$HOME/bin}" installTerraform 1.3.8
folder="${1:-$HOME/bin}" installTerraform 1.3.9
folder="${1:-$HOME/bin}" installTerraform 1.3.10
folder="${1:-$HOME/bin}" installTerraform 1.4.7
folder="${1:-$HOME/bin}" installTerraform 1.5.7
folder="${1:-$HOME/bin}" installTerraform 1.6.1
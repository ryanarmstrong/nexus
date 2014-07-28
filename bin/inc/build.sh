#!/bin/bash

build () {
  cd ${base_dir}
  
  # Delete the webroot directory. We want a fresh start.
  if [[ -d "${webroot}" ]] ; then
    echo "- Removing existing ${webroot}"
    chmod -R 777 ${webroot_dir}/sites/default
    rm -rf ${webroot_dir}
  fi

  # Initialize and update any Git submodules.
  git submodule init
  git submodule update

  # Download the needed modules, themes, and libraries
  drush make ${profile_dir}/build.make ${webroot} -y

  # Create the symbolic link to the project's profile or copy the profile for deployment
  if [ "$deployment" == '1' ];
    then
      cp -R ${profile_dir} ${webroot_dir}/profiles
    else
      ln -s ${profile_dir} ${webroot_dir}/profiles/${project_name}
  fi
}

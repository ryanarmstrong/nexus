#!/bin/bash

# test script
#
# This script runs all PHPUnit and BeHat tests

test () {
  cd ${base_dir}

  # Download dependencies listed in composer.json
  echo "- Downloading dependencies via Composer."
  if [ ! -f composer.phar ] ; then
    curl -sS https://getcomposer.org/installer | php
  fi

  # Install/update vendor libraries
  if [[ -d "${base_dir}/vendor" ]] ; then
    php composer.phar update
  else
    php composer.phar install
  fi

  # Run Story BDD tests via BeHat
  bin/behat
}

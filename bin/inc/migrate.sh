#!/bin/bash

# assets script
#
# This script securely stores the credentials of the current environment.

migrate() {
  cd ${base_dir}
  
  assets_dir=${base_dir}/assets

  # If an assets.zip file is detected, process it.
  if [ -f ${assets_source}/assets.zip ];
    then
      echo "-- Assets detected"
      # Make a temp directory for the assets.
      if [ -d ${assets_dir} ]; then
        echo "-- Old temporary assets directory detected. Removing."
        rm -rf ${assets_dir}
      fi
      mkdir ${assets_dir}

      # Unzip the assets.zip into a temporary directory
      echo "-- Unzipping the assets"
      unzip -qq ${assets_source}/assets.zip -d ${assets_dir}

      # Move the images into place
      echo "-- Moving images into place"
      mkdir ${assets_dir}/images
      mv ${assets_dir}/assets/en_US/shared ${assets_dir}/images

      # Run through each language
      echo "-- Moving and flattening content"

      for lang_dir in $(find ${assets_dir}/assets -maxdepth 1 -mindepth 1 -type d)
      do
        # Create the new Apps and Articles directory
        mkdir -p ${assets_dir}/apps/`basename $lang_dir`
        mkdir -p ${assets_dir}/news/`basename $lang_dir`

        # Move and flatten all Apps
        for file in $(find $lang_dir/apps -type f -name '*.xml')
        do
          mv $file ${assets_dir}/apps/`basename $lang_dir`/`basename $file`
        done

        # Move and flatten all Articles
        for file in $(find $lang_dir/news -type f -name '*.xml')
        do
          mv $file ${assets_dir}/news/`basename $lang_dir`/`basename $file`
        done
      done

      echo "-- Copying XML files into place"
      cp ${base_dir}/bin/inc/xml/*.xml ${assets_dir}
      rm ${assets_dir}/categories-backup.xml ${assets_dir}/categories-original.xml

      echo "-- Removing the unzipped temporary Active directory"
      rm -rf ${assets_dir}/assets

      cd ${webroot_dir}

      echo "-- Importing content"
      drush en views -y
      sed -i '530s/throw/\/\/throw/' sites/all/modules/contrib/migrate/includes/base.inc
      drush mi --group=tegrazoneBase --force
      sed -i '530s/\/\/throw/throw/' sites/all/modules/contrib/migrate/includes/base.inc
      drush mi --group=tegrazoneApps --force
      drush mi --group=tegrazoneNews --force
      echo "-- Processing content through NVIDIA Flow"
      drush php-eval 'integrateNVFlow();'
      drush php-eval 'node_access_rebuild();'

      echo "-- Migration complete. Removing assets directory."
      drush dis views -y
      rm -rf ${assets_dir}

    else
      echo "-- No assets detected"
  fi
}

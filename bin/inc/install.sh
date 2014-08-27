#!/bin/bash

install() {
  cd ${base_dir}
  
  # Include the environment settings and credentials.
  if [ ! -f ${credentials_dir}/credentials.sh ]; then
    echo "Error: No credentials found. Please create one."
    exit
  fi
  . ${credentials_dir}/credentials.sh

  # Include the Config functions
  . ${base_dir}/bin/inc/config.sh

  # Create the database
  echo "- Creating ${human_project_name} database"
  if [[ ! -z "`mysql -u ${mysql_user} -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='${project_name}'" 2>&1`" ]];
  then
    echo "- Database exists. Dropping and recreating."
    mysql --host=${mysql_host} --user=${mysql_user} --password=${mysql_password} -e "drop database ${project_name};create database ${project_name};"
  else
    mysql --host=${mysql_host} --user=${mysql_user} --password=${mysql_password} -e "create database ${project_name};"
  fi

  cd ${webroot_dir}
  drush si ${project_name} --db-url=mysql://${mysql_user}:${mysql_password}@${mysql_host}/${project_name} --account-pass=${drupal_admin_password} --yes

  if [ "$development" == '1' ];
    then
      # Enable modules that aid in development
      drush en devel features devel_generate diff field_ui views migrate_ui link_css dblog tegrazone_developer_feature -y

      # Create test user accounts
      drush user-create ryanarmstrong

      drush user-create test_administrator
      drush role-create administrator
      drush user-add-role "administrator" --name=ryanarmstrong,test_administrator

      drush user-create test_authenticated_user

      drush user-create test_writer
      drush role-create writer      
      drush user-add-role "writer" --name=test_writer

      drush user-create test_editor
      drush role-create editor
      drush user-add-role "editor" --name=test_editor
  fi

  # Import Configuration
  echo "- Importing configuration tables"
  cd ${webroot_dir}
  $(drush sql-connect) < ../configuration/configuration.sql

  # Cleanup
  cd ${webroot_dir}
  drush dis update -y

  # Set file permissions
  echo "- Setting permissions for project"
  chmod -R 777 ${webroot_dir}/sites/default/files
  chmod -R 777 ${webroot_dir}/sites/all/modules/contrib

  drush fra -y
}

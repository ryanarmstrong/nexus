The Absent Admin
================

[![Build Status](https://travis-ci.org/ryanarmstrong/the-absent-admin.png?branch=master)](https://travis-ci.org/ryanarmstrong/the-absent-admin)

About
-----
**The Absent Admin** is a base project to build your Drupal projects on top of using Travis CI to handle CI bash scripting and [Drush](http://drupal.org/project/drush) makefiles to download and build a project, as well as providing scripts to compile any [Compass](http://compass-style.org/) projects.

### Installation

Clone the repo then run `./bin/init`. Make sure to setup your local environment to point to the webroot, the navigate to the site and run the Drupal installation. In the future, support for using `drush runserver` will be added. For now you must handle that.

    ./bin/init   # Cleans up and prepares the repo for your project, then builds the site.
    ./bin/build  # Downloads Drupal, and the modules, themes, and libraries listed in the makefiles.

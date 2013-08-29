The Absent Admin
================

[![Build Status](https://travis-ci.org/ryanarmstrong/the-absent-admin.png?branch=master)](https://travis-ci.org/ryanarmstrong/the-absent-admin)

About
-----
**The Absent Admin** is a base project to build your Drupal projects on top of using Travis CI to handle CI bash scripting and [Drush](http://drupal.org/project/drush) makefiles to download and build a project, as well as providing scripts to compile any [Compass](http://compass-style.org/) projects.

### Installation

#### Standalone MacOS X and Linux with Drush

Clone the repo then run `./bin/install`.

#### MAMP

Clone the repo then run `./bin/init`. Make sure to setup your local environment to point to the webroot, the navigate to the site and run the Drupal installation.

#### Commands

    [TO-DO] ./bin/install   # Runs init to clean up and prep, then installs drush, runs build, starts drush runserver and then runs test.
    ./bin/init        # Cleans up and prepares the repo for your project, then builds the site.
    ./bin/build       # Downloads Drupal, and the modules, themes, and libraries listed in the makefiles.
    [TO-DO] ./bin/test        # Runs all PHPUnit tests and BeHat tests

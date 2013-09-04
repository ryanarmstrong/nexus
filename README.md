#The Absent Admin

## About

**The Absent Admin** is a base project to build your Drupal projects on top of using Travis CI to handle CI, bash scripting and [Drush](http://drupal.org/project/drush) makefiles to download and build a project.

[![Build Status](https://travis-ci.org/ryanarmstrong/the-absent-admin.png?branch=master)](https://travis-ci.org/ryanarmstrong/the-absent-admin)

## Installation

### Prerequisites

* PHP 5.4 or higher
* Drush 6 or higher
* MySQL
 
[Homebrew](http://brew.sh/) is the easiest way to install and maintain these prerequisites in a OSX environment.

### Standalone MacOS X and Linux with Drush

Clone the repo then run `./bin/install`. If you have any permissions issues, try running `sudo ./bin/install`.

### MAMP

Clone the repo then run `./bin/init`. Make sure to setup your local environment to point to the webroot, then navigate to the site and run the Drupal installation.

### Commands

The following commands are available to help with setup, development, and testing. Make sure to read the commemnts in each script file to learn about the various flags and options you can use with them.

    ./bin/install  # Runs init, installs drush, runs build, installs Drupal, starts drush runserver and then runs test.
    ./bin/init     # Cleans up and prepares the repo for your project, then builds the site.
    ./bin/build    # Downloads Drupal, and the modules, themes, and libraries listed in the makefiles.
    ./bin/test     # Runs all PHPUnit tests and BeHat tests

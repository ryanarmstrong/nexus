#Nexus

**Nexus** is a base project to build your Drupal projects on top of using Travis CI to handle CI, bash scripting and [Drush](http://drupal.org/project/drush) makefiles to download and build a project.

Nexus Version | Branch  | Drupal Core Version | Prerequisites | Code Status
------------- | ------  | ------------------- | ------------- | -----------
Nexus 8       | <a href="https://github.com/ryanarmstrong/nexus/tree/8.x">8.x</a> | Drupal 8 (8.0-alpha3 by default) | PHP 5.4+, Drush 7+, MySQL 5.0.15+ | [![Build Status](https://travis-ci.org/ryanarmstrong/nexus.png?branch=8.x)](https://travis-ci.org/ryanarmstrong/nexus)
Nexus 7       | <a href="https://github.com/ryanarmstrong/nexus/tree/7.x">7.x</a> | Drupal 7 (7.23 by default) | PHP 5.4+, Drush 6+, MySQL 5.0.15+ | [![Build Status](https://travis-ci.org/ryanarmstrong/nexus.png?branch=7.x)](https://travis-ci.org/ryanarmstrong/nexus)

## Installation

### Prerequisites

* PHP 5.4 or higher
* Drush 6 or higher for Nexus 7 and Drush 7 or higher for Nexus 8
* MySQL 5.0.15 or higher
 
[Homebrew](http://brew.sh/) is the easiest way to install and maintain these prerequisites in a OSX environment.

### Standalone MacOS X and Linux with Drush

Clone the repo then run `./bin/install`. If you have any permissions issues, try running `sudo ./bin/install`.

### MAMP

Clone the repo then run `./bin/init`. Make sure to setup your local environment to point to the webroot, then navigate to the site and run the Drupal installation.

### Commands

The following commands are available to help with setup, development, and testing. Make sure to read the commemnts in each script file to learn about the various flags and options you can use with them.

    ./bin/install  # Runs init, runs build, installs Drupal, starts drush runserver and then runs test.
    ./bin/init     # Cleans up and prepares the repo for your project, then builds the site.
    ./bin/build    # Downloads Drupal, and the modules, themes, and libraries listed in the makefiles.
    ./bin/test     # Runs all PHPUnit tests and BeHat tests

#Nexus

**Nexus** is a base project to build your Drupal projects on top of using Travis CI to handle CI, bash scripting and [Drush](http://drupal.org/project/drush) makefiles to download and build a project.

Version | Branch  | Drupal | Current Release | Prerequisites | Status
------- | ------  | ------ | --------------- | ------------- | ------
Nexus 8 | [8.x](https://github.com/ryanarmstrong/nexus/tree/8.x) | [Dev](https://github.com/ryanarmstrong/nexus/archive/8.x.zip) | Drupal 8 (8.0-alpha3 by default) | PHP 5.4+, Drush 7+, MySQL 5.0.15+ | [![Build Status](https://travis-ci.org/ryanarmstrong/nexus.png?branch=8.x)](https://travis-ci.org/ryanarmstrong/nexus)
Nexus 7 | [7.x](https://github.com/ryanarmstrong/nexus/tree/7.x) | [7.0.0](https://github.com/ryanarmstrong/nexus/archive/7.0.0.zip) | Drupal 7 (7.23 by default) | PHP 5.4+, Drush 6+, MySQL 5.0.15+ | [![Build Status](https://travis-ci.org/ryanarmstrong/nexus.png?branch=7.x)](https://travis-ci.org/ryanarmstrong/nexus)

## Installation

### Prerequisites

* PHP 5.4 or higher
* Drush 6 or higher for Nexus 7 and Drush 7 or higher for Nexus 8
* MySQL 5.0.15 or higher
 
[Homebrew](http://brew.sh/) is the easiest way to install and maintain these prerequisites in a OSX environment.

### Installation

Set your 

Clone the repo giving it the name of your project `git clone git@github.com:ryanarmstrong/nexus.git yourprojectname`

Set the project variables in ./bin/inc/header.sh

Run `./bin/init`. If you have any permissions issues, try running `sudo ./bin/init`. To rebuild the site run `./bin/install` or `sudo ./bin/install` if you run into permissions issues.

### Commands

The following commands are available to help with setup, development, and testing. Make sure to read the commemnts in each script file to learn about the various flags and options you can use with them.

    ./bin/install  # Removes previous built projects, runs build, installs Drupal, starts drush runserver and then runs test.
    ./bin/init     # Cleans up and prepares the repo for your project, then builds the site.
    ./bin/test     # Runs all PHPUnit tests and BeHat tests

### Project Variables

The following are the project variables you should set before running `./bin/init` or `./bin/install`.

    project_name        # The machine name of the project. By default it is set to the git repo name.
    human_project_name  # The human-readable name of the project.
    webroot             # Where the built site will be run out of. Usually will be left as the default.

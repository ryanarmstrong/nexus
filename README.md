The Absent Admin
================

[![Build Status](https://travis-ci.org/ryanarmstrong/the-absent-admin.png?branch=master)](https://travis-ci.org/ryanarmstrong/the-absent-admin)

About
-----
**The Absent Admin** is a base project to build your Drupal projects on top of using Travis CI to handle CI bash scripting and [Drush](http://drupal.org/project/drush) makefiles to download and build a project, as well as providing scripts to compile any [Compass](http://compass-style.org/) projects.

### Installation

    ./bin/init   # Cleans up and prepares the repo for your project, then builds the site.
    ./bin/build  # Downloads Drupal, and the modules, themes, and libraries listed in the makefiles.

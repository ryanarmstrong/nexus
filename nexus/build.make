; ----------------
; Build Makefile for: Nexus
; GitHub: https://github.com/ryanarmstrong/nexus
; Contains: This make file should contain core as well as modules, themes, features, and libraries.
; ----------------

api = 2
core = 7.x

; Core project
; ------------
projects[drupal][type] = core
projects[drupal][version] = 7.26

; Include any modules, themes, and libraries that are hosted remotely.

; Modules
; --------
; Include any modules that are hosted remotely.

projects[configuration][version] = 2.x-dev
projects[configuration][subdir] = contrib
projects[configuration][type] = module

; Features
; ---------
; Include any features that are hosted remotely.

; Themes
; --------
; Include any themes that are hosted remotely.

; Libraries
; ---------
; Include libaries required by the above projects.

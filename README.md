# CatEEGfMRIStudy
A Psychtoolbox based visual simuly application, displaying a grid of squares where one of the square changes colour.

## Psychtoolbox installation
1. Download the Psychtoolbox MATLAB code from [here](http://psychtoolbox.org/download/) and save it in a directory of your choice.
2. Then download and install Subversion.
3. For Windows make sure Microsoft Runtime Libraries for MSVC 2010 or later are installed.
4. Execute `DownloadPsychtoolbox('C:\path_to_dir')` in MATLAB to download and install the toolbox

## Functionality
The `run.m` file contains sample code to run through a block of trials.
The `CatStudy` Class is used and it provides all the functionality to interface with Psychtoolbox and draw all squares etc.
Every single file is commented and should be very self-explanatory.

## TODOs
- Add a "pause" screen to display in between blocks
- Write the EEG interface to send time signals to EEG computer over some COM/Serial/Parallel port


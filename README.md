# Spotify Recommendations

## GitHub Repository
https://github.com/BenAhale/Spotify-App

## Installation and Setup

1. Install ruby, we recommend using [asdf](https://asdf-vm.com/) to do this.
1. Install the Ruby Gem. You can view the Ruby Gems page for this gem [here](https://rubygems.org/gems/spotify_rec).
    ```gem install spotify_rec```
1. This should download the following gem dependencies:
    - RSpotify
    - TTY-Prompt
    - Terminal-Table
    - Colorizer
If for any reason these don't install, you can do so with the following:
        ```
        gem install rspotify
        gem install tty-prompt
        gem install terminal-table
        gem install colorizer
        ```
1. You can run the app by typing ```spotify_rec``` from anywhere in your terminal.
1. In addition to ```spotify_rec```, the program takes the following options:
    - -v or --version || Displays the program version
    - -h or --help || Displays the help message
    - -t, --tutorial || Have a brief walkthrough of the program
    - -q (GENRE) or --quick (GENRE) || Generates a quick recommendation using the genre that is supplied

## Testing

### Overview

Spotify Recommendations has two tests to ensure that the application is functioning correctly. The first test checks that an instance of the user class can be created, and that it's attributes can be accessed properly. It also checks to see that items can be properly stored in the user's 'MyList' attribute. The second test checks that recommendations are being generated correctly, and that a recommendation can be properly added to the user playlist.

### How to run the tests

The tests included are built with the RSpec gem, and it will need to be installed in order to run them. A guide is included below.

1. If you don't have the RSpec gem installed on your computer, you can do so with:
    ```gem install rspec```
1. Once RSpec is installed, navigate to the ```src/``` directory and run:
    ```
    rspec spec
    ```
1. There should be a total of four cases that RSpec tests, and it will automatically show the outcomes for each, either as a green 'dot' if it is successful or a red 'F' if it fails.

## Software Development Plan

### R5 - Statement of Purpose and Scope

For quite some time, discovering new music has been a time consuming task, and usually involves hours of listening to music that just doesn't fit with your style. Spotify Recommendations seeks to change this, and aims to easily supply tailored recommendations to users so that they can discover potential new music. This is an issue that I am all too familiar with, and a tool was necesary in order to streamline this task. Spotify Recommendations achieves this with an easy to use, convenient command line application. The application allows you to maintain a list of songs, artists and genres, that closely resemble your music tastes, and generate track recommendations based on this list. From these recommendations, you can select those that you're interested in and store them in your private playlist. Recommendations can be generated any number of times, and the playlist can store as many tracks as you'd like. Once you have built an impressive playlist, you can export the list to a file on your desktop, with links to listen to all of your new songs! This application is aimed at anyone who listens to music and is looking to add a bit of variety and switch up their regular tracks. The application is set out into easy to navigate menus that show you all options that are available, and you can easily view, add to and remove from MyList or your playlist. On top of that, searching for songs, artists and genres has never been easier - simply throw in some keywords and the app will spit out the Top 5 results for you to select, so you can make sure you've got the right one. The application can be used as many times as you feel it is necessary, but we recommend to give it a shot every couple of weeks as you begin to need to new music to switch up the regulars.

### R6 - Features

The application includes 3 main features, on top of an account system that keeps your data private.

- MyList: A key component in generating recommendations, MyList allows a user to add up to 5 'items' to their list, being any type of a track, an artist or a genre. This list can be edited at any time to keep your music style up to date and most accurately reflected. Importantly, you must have at least one item in your list, or else the application won't generate any recommendations. MyList utilises variables to store list items and frequently uses loops to extract the information needed from arrays and display it properly to the user. Error handling also plays a huge role, as there are actions users can take in the MyList menu that throw errors, such as trying to remove and item from an already empty list.

- Recommendations: Perhaps the most important component in the application, generating recommendations is the sole reason for the app existing. Recommendations are generated using the Spotify Web API, so you can be sure that the songs we're recommending are popular, well known tracks. Recommendations are stored in variables and class variables in order to pass information between functions of the application, such as storing the top results after generating a recommendation and storing the users selected tracks to be added to the playlist. Additionally, the program regularly loops through arrays of data in order to pull only the necessary information and display it to the user. The application can only handle between 1-5 seed 'items' for generating a recommendation, so error handling is used to make sure users have the right number in their list to allow the app to run.

- Playlist: The place to store all of your favourite recommendations! You can select any number of the recommendations that have been generated for you and store them in your playlist, which is unique and private to each user account. You can add and remove items from the playlist, and when you're happy, export the tracks to a markdown file on your desktop, with links to go and listen to the songs on Spotify. Playlist infomation is stored in both variables and class variables, for easy access and manipulation in numerous areas of the program. Like the previous features, it also regularly loops through arrays and hashes of data in order to pull the necessary information and display it to the user. The playlist utilises error handling to stop users attempting to remove items from an already empty list, and from exporting an empty list to their desktop, as these actions would cause errors to break the program.

- Account: The program makes use of a full authentication system to keep users data private, and inaccessible to other users of the application. This involves a login / registration system before accessing the main menu. This uses variables and class variables to store information to move throughout the program, and loops through user data to match and authenticate login attempts. Error handling is used to make sure that user input is in the correct format and doesn't require any charactes that are not allowed.

### R7 - User Interaction and Experience

Users can walk through a tutorial rundown of the application by using ```spotify_rec -t```, with a number of screens explaining how each feature works and how it relates to the rest of the application. Each feature has its own sub-menu which is accessible through the main menu. The sub-menu includes a list of all available options, and utilises TTY-Prompt to make selecting and navigating through the options and menus hassle free. This all makes for a swift interation with the program, and any particular feature can be reached anywhere the program within 1-3 selections from the respective menus. Errors are handled in the program in a variety of ways, including conditional checks, rescuing errors and limiting input. Conditional checks reroute users in the program if the conditional is true, such as if the user has 5 items in MyList already, the program won't let them proceed to add another, and will kick them back to the menu. Raising errors and rescuing them is also used in areas of the program, such as not allowing a list to be displayed if it doesn't have any items in it and having the user choose a new username or password if it doesn't meet the requirements. Finally, TTY-Prompt's select capability is used to limit the range of user input that can be received, and eliminates any misspellings or unexpected options when navigating through the program. The user is only able to select from a defined list for things such as menus, and this doesn't allow any errors based on user input. Furthermore, TTY-Prompt offers a validate function, which validates whether a users selected amount of recommendations is within the range that is allowed to be generated. Each error is accompanied by a message that is printed to the screen to tell the user what has happened, and how they can take steps to fix it.

### R8 - Diagram and Control Flow

![ControlFlowDiagram](/docs/ControlFlowDiagram.png)

### R9 - Implementation Plan

The implementation plan for this project was developed on a Trello board. You can view the entire Trello board [here](https://trello.com/b/DJQti9ev/ben-ahale-t1a3).

# Endless Runner in Godot 4.2

This game was developed as a project for the missing-semester lecture at JKU Linz. The goal was to get familiar with the Godot game engine and create a small project showcasing what it can do. Additionally for learning purposes, also an automatic deployment pipeline was used to build and deploy a web version of the game to Github Pages.


## Authors

- [@rasalagean](https://github.com/rasalagean) - K12116140


## Screenshots
![image](https://github.com/rasalagean/endless-runner/assets/151786698/a228159f-4884-4c39-a160-073050a30e8f)

![image](https://github.com/rasalagean/endless-runner/assets/151786698/c252bab5-7e56-4a52-aa2d-d2a7230ca325)

![image](https://github.com/rasalagean/endless-runner/assets/151786698/600cdf9a-42c9-4deb-9233-83dddad7dd36)

## Run Locally

Clone the project

```bash
  git clone https://github.com/rasalagean/endless-runner.git
```

Make sure you have Godot 4.2 installed and import this project within the engine. After that, pressing F5 will launch the game.

This repository also includes exports of the game for Windows, Linux and Web. You can find them in the ./exports folder. There are executables which will run the game directly without having the need to install the Godot engine.

In order to make it easier to test the project the Web export is also automatically deployed to github pages.

**Please follow the following steps exactly as described, in order to run the game properly on the web:**

1. Open a new browser window.
2. Go to https://rasalagean.github.io/endless-runner/
3. Wait till the game loads and start playing :)

If the game works fine, nothing else to do. However if it looks broken please follow these steps:

1. Open a new browser window.
2. Open the web developer tools and resize the browser window to be 1152px x 648px. (Opening the web developer tools should display the window size while resizing)
3. Go to https://rasalagean.github.io/endless-runner/
3. Wait till the game loads and start playing :)

*Following these steps may be necessary as the configured Godot project window size is 1152px x 648px. A different window size may break the game. For the Linux and Windows runnables this is not necessary as they have a fixed window size anyways.*
## Deployment

There is a Github Action linked to this repository. Whenever a commit is pushed to the main branch, the process starts.
To sum it up, the Github Action downloads a Godot 4.2 instance, checks out the code on the main branch and builds a Web export to the "gh-pages" branch.
A second Github Action is then triggered when something is pushed to the "gh-pages" branch. This second action, is a basic static html file deployment to https://github.com/rasalagean/endless-runner  


## License

[MIT](https://choosealicense.com/licenses/mit/)

## Resources

[background-assets](https://ansimuz.itch.io/parallax-forest) \
[character-assets](https://arks.itch.io/dino-characters) \
[music-assets](https://www.filippovicarelli.com/8bit-game-background-music) \
[sound-assets](https://sfxr.me/)

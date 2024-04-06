# Decky Loader Windows Build
A Dockerfile to build the windows binary of [decky loader](https://github.com/SteamDeckHomebrew/decky-loader) for use on windows.

# Prerequisites

    Docker v19.03+


## Build process

1. Pass the release tag you want to build (obtained [here](https://github.com/SteamDeckHomebrew/decky-loader/tags))

```Dockerfile
   docker buildx build --output type=local,dest=. . --build-arg release=v2.11.1
```

2. It will generate a `dist` folder containing a `homebrew` folder

3. Move this `homebrew` folder to `C:/Users/{username}`

4. Run the executable, which will generate the necessary folders in the `homebrew` folder

5. Decky loader will now appear in the "Quick settings" in steam big picture mode
    - Access "Quick settings" with a xbox controller `Xbox button + A`

### Note

Any plugins doing anything other than styling will most likely not work, as most are intended for a linux environment.


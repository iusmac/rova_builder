## How to build Android 11+ based ROM for Xiaomi Redmi 4A/5A (rolex/riva)

### Set up the builder
This script is a simple wrapper around [ContainerizedAndroidBuilder](https://github.com/iusmac/ContainerizedAndroidBuilder).
1. Clone this repo
    ```console
    git clone --recursive https://github.com/iusmac/rova_builder.git -b 13-stable
    ```
    **(!) Pay attention to the _--recursive_ option. It's required so that submodules are included as well.**

2. Enter into it
    ```console
    cd rova_builder
    ```
3. Make the _builder.sh_ executable
    ```console
    chmod +x builder.sh
    ```
4. Install Docker on your system
    ```console
    curl -fsSL https://get.docker.com | sudo sh -
    ```
5. (<em>Optional</em>) Open the _builder.sh_ file and make appropriate changes for ``--repo-url``, ``--ccache-size``, etc.

   Discover more about customizations and how to speed the build on [ContainerizedAndroidBuilder](https://github.com/iusmac/ContainerizedAndroidBuilder).


### Prepare sources
1. Run the builder
    ```console
    ./builder.sh
    ```
2. To init repo navigate to ``Sources`` > ``Init`` (_this should be done once_)
3. To download source code navigate to ``Sources`` > ``Sync All``

### Build
1. Run the builder:
    ```console
    ./builder.sh
    ```
2. To start build navigate to ``Build`` > ``Build ROM``

### Keep it up to date
Don't forget to get latest builder updates using `Self-update` option in the main menu or:
```console
git pull --recurse-submodules
```

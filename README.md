## How to build Android 11+ based ROM for Xiaomi Redmi 4A/5A (rolex/riva)

### 1. Set up the script
This script is a simple wrapper around [ContainerizedAndroidBuilder](https://github.com/iusmac/ContainerizedAndroidBuilder/tree/12).

#### 1.1 Clone this repo
```console
iusmac@pc:~$ git clone --recursive https://github.com/iusmac/rova_builder.git -b 12
```

**(!) Pay attention to the _--recursive_ option. It's required so that submodules are included as well.**

#### 1.2 Enter into it
```console
iusmac@pc:~$ cd rova_builder
```

#### 1.3 Make the _builder.sh_ executable
```console
iusmac@pc:~/rova_builder$ chmod +x builder.sh
```

#### 1.4 Open the _builder.sh_ file and make appropriate changes for ``--email``, ``--ccache-size``, etc.
- Discover more about customizations and how to speed the build on [ContainerizedAndroidBuilder](https://github.com/iusmac/ContainerizedAndroidBuilder/tree/12).

### 2. Install Docker on your system
```console
iusmac@pc:~/rova_builder$ curl -fsSL https://get.docker.com | sudo sh -
```

### 3. Prepare sources
#### 3.1 Run the builder
```console
iusmac@pc:~/rova_builder$ ./builder.sh
```

#### 3.2 Init repo
Navigate to ``Sources`` > ``Init`` (_this should be done once_)

#### 3.3 Download source code
Navigate to ``Sources`` > ``Sync All``

### 4. Build
#### 4.1 Run the builder:
```console
iusmac@pc:~/rova_builder$ ./builder.sh
```

#### 4.2 Build
Navigate to ``Build`` > ``Build ROM``

### Keep it up to date
Don't forget to get latest builder updates using `Self update` option in the main menu or:
```console
iusmac@pc:~/rova_builder$ git pull --recurse-submodules
```

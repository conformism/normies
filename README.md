# Normies

This is the factory of packages provided to Conformism users. Some of them are meta-packages, some others are useful 3rd-party softwares not available at distributions repositories.

# Usage

## Build dependencies

- Debian / Ubuntu :

```sh
add-apt-repository ppa:kubuntu-ppa/backports
apt-get update
apt-get install libkf5threadweaver-dev libkf5i18n-dev libkf5configwidgets-dev \
    libkf5coreaddons-dev libkf5itemviews-dev libkf5itemmodels-dev libkf5kio-dev \
    libkf5solid-dev libkf5windowsystem-dev libelf-dev libdw-dev cmake \
    extra-cmake-modules gettext
```



## Build

Normies relies on CMake so packages construction is straight forward.

```sh
normies $

	mkdir build && cd build
	cmake ..
	make
	make pack
```


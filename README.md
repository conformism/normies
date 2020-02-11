# Normies

This is the factory of packages provided to Conformism users. Some of them are meta-packages, some others are useful 3rd-party softwares not available at distributions repositories.

# Usage

## Build within a container

Some packages have several build-time dependencies so not to pollute your system, you must use a container.

```sh
normies $

	docker build . -t normies:t1
	docker run -it normies:t1
	ls normies/build/out
```

## Classic build on Ubuntu 19.10 (deprecated)

If you don't care, you can go the classic way. Normies relies on CMake so packages construction is straight forward.

```sh
normies $

	sudo apt-get install build-essential git file libelf-dev \
		cmake extra-cmake-modules software-properties-common 

	mkdir build && cd build
	cmake -DINSTALL_BUILD_TIME_DEP=TRUE ..
	make pack
```


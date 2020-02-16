# Normies

This is the factory of packages provided to Conformism users. Some of them are meta-packages, some others are useful 3rd-party softwares not available at distributions repositories.

Running Normies will build `.deb` packages (and/or `rpm` or whatever CPack can package that preferentially manages dependencies) and deploy an APT repository.

# Usage

## Build within a container

Some packages have several build-time dependencies so not to pollute your system, you must use a container.

```sh
normies $

	docker build . -t normies:t1
	docker run -v $PWD/out:/opt/normies/build/out -t normies:t1
	ls out
```

Of course, you can use another directory than `$PWD/out` to deploy your packages repository.

## Classic build on Ubuntu 19.10 (deprecated)

If you don't care, you can go the classic way. Normies relies on CMake so packages construction is straight forward.

```sh
normies $

	sudo apt-get install build-essential git file libelf-dev \
		cmake extra-cmake-modules software-properties-common lintian

	mkdir build && cd build
	cmake -DINSTALL_BUILD_TIME_DEP=TRUE ..
	make deploy
```


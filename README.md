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

# Development

The list of packages for your normies is specific to each use case. So you may want to fork the project and add/remove some packages.

## Overview

By its structure, Normies will look familiar for someone who already used Yocto. Each package process is wrapped in a recipe (CMakeLists.txt) with some predefined sections. For example, take a look at existant recipes.

## Header paragraph

First of all, declare which CMake version is required `cmake_minimum_required( VERSION 3.11 )`. Then
declare a new project named as your package do, with its version and its description. Check CMake documentation :
  - https://cmake.org/cmake/help/latest/command/project.html

## Pack paragraph

It is the last section. It is mandatory since each recipe means to produce a package.

- `CPackConfig.cmake` holds your default config for packages plus the `CPackRegister` macro. Include it : `include( CPackConfig )`

- Set all the `CPACK_*` variables you need. Check CMake documentation :
	- https://cmake.org/cmake/help/latest/module/CPack.html
	- https://cmake.org/cmake/help/latest/manual/cpack-generators.7.html

- `include( CPack )` as usual.

- Register this package process as dependency of the target `pack`. You can also register other targets as dependencies of this package process. For example, if the package process need the build process to be done before executing, just write `CPackRegister( ${PROJECT_NAME} )`, assuming the build target is named as the current project.

## Build paragraph

### Local project

If it is your own package that has no place elsewhere, the recipe folder is its sources root folder and the recipe is the top `CMakeLists.txt`. Just write it's build system as usual, split it in subfolders if it is a large project.

### External project

- If the package is hosted somewhere on the Internet, use the `ExternalProject_Add` command that wrap the build process of a project based on CMake, Autotools or simply GNU Make. The process is splitted in some steps you can redefine. Check CMake documentation :
	- https://cmake.org/cmake/help/latest/module/ExternalProject.html

- As manually installed, the package would probably like to install itself to `/usr/local` instead of `/usr`, in this case you will have to override this behavior `CONFIGURE_COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX= <SOURCE_DIR>`.

- You will also need to make the project install itself to `<INSTALL_DIR>` instead wherever on the rootfs (like `/usr`, `/usr/local` or `/opt`) : `INSTALL_COMMAND make install DESTDIR=<INSTALL_DIR>`

- Do not forget to strip binary files if they are not. Just add a `strip` step after the `install` one.

- Then install project from the `ExternalProject` `<INSTALL_DIR>` to the real installation directory, `/usr`. If the project has a standard installation process, you will only have to install that directory to `.` that means the root after `${DESTDIR}/${CMAKE_INSTALL_PREFIX}`. Do not mess with permissions.
```c++
install(
	DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${EP_BASE_DIR}/Install/${PROJECT_NAME}/."
	DESTINATION "."
	USE_SOURCE_PERMISSIONS
	DIRECTORY_PERMISSIONS ${CMAKE_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS}
	)
```
Check CMake documentation :
	- https://cmake.org/cmake/help/latest/command/install.html

## Dependencies paragraph

If the package build process needs softwares or libraries to be installed, you can add build-time dependencies :

- Write the list of needed packages `<recipe_dir>/dependencies.debian`. Then use `InstallDebianDependencies( "AddDebianRepositories-${PROJECT_NAME}" )` if you have to add APT repositories before, else simply `InstallDebianDependencies()`. Do not forget to make your build process depends on this process by adding `DEPENDS "Dependencies-${PROJECT_NAME}"` to `ExternalProject_Add` or `add_custom_target`, or with `add_dependencies` for other targets.

- Write the list of needed repositories `<recipe_dir>/repositories.debian`. Then use `AddDebianRepositories`. This process probably depends on nothing else but it is possible to set a dependency the same way than for `AddDebianRepositories`.


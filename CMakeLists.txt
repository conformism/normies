cmake_minimum_required( VERSION 3.11 )
cmake_policy( VERSION 3.11 )

set( CMAKE_MODULE_PATH
	${CMAKE_MODULE_PATH}
	"${CMAKE_SOURCE_DIR}"
	)

project( Normies
	VERSION 0.0.0
	DESCRIPTION "Conformism packages builder"
	)

set( NORMIES_URL "https://github.com/conformism/normies" )
set( NORMIES_MAINTAINER "Thomas Lepoix <thomas.lepoix@protonmail.ch>" )

set( CMAKE_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS
	OWNER_READ
	OWNER_WRITE
	OWNER_EXECUTE
	GROUP_READ
	GROUP_EXECUTE
	WORLD_READ
	WORLD_EXECUTE
	)

add_custom_target( pack )

add_subdirectory( "${CMAKE_SOURCE_DIR}/pack_3rdparty/cutter" )
add_subdirectory( "${CMAKE_SOURCE_DIR}/pack/normies-dev" )


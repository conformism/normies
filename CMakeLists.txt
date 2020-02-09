cmake_minimum_required( VERSION 3.11 )
cmake_policy( VERSION 3.11 )

project( Normies
	VERSION 0.0.0
	DESCRIPTION "Conformism packages builder"
	)

set( NORMIES_URL "https://github.com/conformism/normies" )
set( NORMIES_MAINTAINER "Thomas Lepoix <thomas.lepoix@protonmail.ch>" )

set( CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}"
	"${CMAKE_SOURCE_DIR}"
	)

find_program( STRIP strip )
if( STRIP )
	message( STATUS "Found strip: ${STRIP}" )
else()
	message( ERROR "Not found strip: Please install binutils" )
endif()

include( ExternalProject )

set( EP_BASE_DIR "external" )
set_directory_properties( PROPERTIES EP_BASE "${EP_BASE_DIR}" )
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
add_subdirectory( "${CMAKE_SOURCE_DIR}/pack_3rdparty/hotspot" )
add_subdirectory( "${CMAKE_SOURCE_DIR}/pack/normies-dev" )


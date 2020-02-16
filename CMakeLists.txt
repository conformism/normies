cmake_minimum_required( VERSION 3.11 )
cmake_policy( VERSION 3.11 )

project( Normies
	VERSION 0.0.0
	DESCRIPTION "Conformism packages builder"
	)

set( NORMIES_URL "https://github.com/conformism/normies" )
set( NORMIES_MAINTAINER "Thomas Lepoix <thomas.lepoix@protonmail.ch>" )

set( CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}"
	"${CMAKE_SOURCE_DIR}/cmake"
	"${CMAKE_SOURCE_DIR}"
	)

############################################################################FIND

find_program( STRIP strip )
if( STRIP )
	message( STATUS "Found strip: ${STRIP}" )
else()
	message( ERROR "Not found strip: Please install binutils" )
endif()

find_program( LINTIAN lintian )
if( LINTIAN )
	message( STATUS "Found lintian: ${LINTIAN}" )
else()
	message( ERROR "Not found lintian: Please install lintian" )
endif()

find_program( DPKG_SCANPACKAGES dpkg-scanpackages )
if( DPKG_SCANPACKAGES )
	message( STATUS "Found strip: ${DPKG_SCANPACKAGES}" )
else()
	message( ERROR "Not found dpkg-scanpackages: Please install dpkg-dev" )
endif()

################################################################################

include( ExternalProject )
include( Dependencies )

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

##########################################################################DEPLOY

if( NOT DEPLOY_DIR )
	set( DEPLOY_DIR "${CMAKE_BINARY_DIR}/out" )
endif( NOT DEPLOY_DIR )
message( STATUS "Deploy directory: ${DEPLOY_DIR}" ) 

add_custom_target( deploy
	DEPENDS pack
	COMMAND ${CMAKE_COMMAND} -E make_directory "${DEPLOY_DIR}/deb"
	COMMAND ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_BINARY_DIR}/*/*/*.deb" "${DEPLOY_DIR}/deb"
	COMMAND ${DPKG_SCANPACKAGES} "${DEPLOY_DIR}/deb" | gzip -9 > "${DEPLOY_DIR}/deb/Packages.gz"
	COMMAND eval "${LINTIAN} \"${DEPLOY_DIR}/deb/*.deb\" ;:;"
	# Do not care about lintian exit status so here is this syntax with eval and ;:;
	)


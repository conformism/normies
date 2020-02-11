cmake_minimum_required( VERSION 3.11 )

project( Hotspot
	VERSION 1.2.0
	DESCRIPTION "The Linux perf GUI for performance analysis."
	)

####################################################################DEPENDENCIES

AddDebianRepository( "ppa:kubuntu-ppa/backports" )
InstallDebianDependencies( "AddDebianRepository-${PROJECT_NAME}" )

########################################################################DOWNLOAD

ExternalProject_Add( ${PROJECT_NAME}
	DEPENDS "Dependencies-${PROJECT_NAME}"
	URL "https://github.com/KDAB/hotspot/releases/download/v1.2.0/hotspot-v1.2.0.tar.gz"
	URL_MD5 "cb9d01248c3f978998e595d66927faf0"
	CONFIGURE_COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX= <SOURCE_DIR>
	INSTALL_COMMAND make install DESTDIR=<INSTALL_DIR>
#	COMMAND ${STRIP} -s "<INSTALL_DIR>/bin/hotspot"
#	COMMAND ${STRIP} -s "<INSTALL_DIR>/lib/x86_64-linux-gnu/libexec/hotspot-perfparser"
	)

ExternalProject_Add_Step( ${PROJECT_NAME} strip
	COMMAND ${STRIP} -s "<INSTALL_DIR>/bin/hotspot"
	COMMAND ${CMAKE_COMMAND} -E echo_append "-- Stripping: "
	COMMAND ${CMAKE_COMMAND} -E echo "<INSTALL_DIR>/bin/hotspot"
	COMMAND ${STRIP} -s "<INSTALL_DIR>/lib/x86_64-linux-gnu/libexec/hotspot-perfparser"
	COMMAND ${CMAKE_COMMAND} -E echo_append "-- Stripping: "
	COMMAND ${CMAKE_COMMAND} -E echo "<INSTALL_DIR>/lib/x86_64-linux-gnu/libexec/hotspot-perfparser"
	DEPENDEES install
	)

install(
	DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${EP_BASE_DIR}/Install/${PROJECT_NAME}/."
	DESTINATION "."
	USE_SOURCE_PERMISSIONS
	DIRECTORY_PERMISSIONS ${CMAKE_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS}
	)

############################################################################PACK

include( CPackConfig )

set( CPACK_PACKAGE_NAME "hotspot" )
set( CPACK_PACKAGE_DESCRIPTION "This project is a KDAB R&D effort to create a standalone GUI for performance data. As the first goal, we want to provide a UI like KCachegrind around Linux perf. Looking ahead, we intend to support various other performance data formats under this umbrella." )

set( CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://github.com/KDAB/hotspot" )
set( CPACK_DEBIAN_PACKAGE_SECTION "devel" )
set( CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON )

set( CPACK_RPM_PACKAGE_LICENSE "GPL-2.0" )
set( CPACK_RPM_PACKAGE_URL "https://github.com/KDAB/hotspot" )

include( CPack )
CPackRegister( ${PROJECT_NAME} )


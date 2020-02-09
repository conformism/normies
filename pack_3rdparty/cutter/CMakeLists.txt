cmake_minimum_required( VERSION 3.11 )

project( Cutter
	VERSION 1.10.1
	DESCRIPTION "GUI for radare2 reverse engineering framework"
	)

########################################################################DOWNLOAD

ExternalProject_Add( ${PROJECT_NAME}
	URL "https://github.com/radareorg/cutter/releases/download/v1.10.1/Cutter-v1.10.1-x64.Linux.AppImage"
	URL_MD5 "d79f17732e0bf77921ac2143ec556527"
	DOWNLOAD_NO_EXTRACT TRUE
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different "<DOWNLOAD_DIR>/Cutter-v1.10.1-x64.Linux.AppImage" "<INSTALL_DIR>/bin/Cutter"
	)

install(
	PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/${EP_BASE_DIR}/Install/${PROJECT_NAME}/bin/Cutter"
	DESTINATION "bin"
	)

############################################################################PACK

include( CPackConfig )

set( CPACK_STRIP_FILES "bin/Cutter" )

set( CPACK_PACKAGE_NAME "radare2-cutter-appimage" )
set( CPACK_PACKAGE_DESCRIPTION "Cutter is a Qt based GUI for reverse engineering binaries, which makes use of the radare2 framework. Advanced users are expected to use the radare2 CLI tools instead, which are much more powerful." )

set( CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://github.com/radareorg/cutter" )
set( CPACK_DEBIAN_PACKAGE_SECTION "devel" )
set( CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON )

set( CPACK_RPM_PACKAGE_LICENSE "GPL-3.0" )
set( CPACK_RPM_PACKAGE_URL "https://github.com/radareorg/cutter" )

include( CPack )
CPackRegister( ${PROJECT_NAME} )


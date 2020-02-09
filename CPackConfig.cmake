################################################################################
# Here is a workaround to make CPack able to create multiple packages in one project.
# - Avoid CMake creating only one 'CPackConfig.cmake' when using 'include(CPack)'
#   by setting 'CPACK_SOURCE_OUTPUT_CONFIG_FILE' & 'CPACK_OUTPUT_CONFIG_FILE' to
#   '${CMAKE_CURRENT_BINARY_DIR}' instead of '${CMAKE_BINARY_DIR}'.
# - Set 'CPACK_INSTALL_CMAKE_PROJECTS' correctly to warn CPack which CMake
#   projects to deal with.
# - In top CMakeLists.txt, 'add_custom_target(pack)' that do nothing. You will
#   use this target as replacement of 'make package'.
# - For each subproject you want to package, use 'CPackRegister(dependencies)'
#   to register a trigger from 'pack' target.
# - Use 'CPACK_*' vars and 'include(CPack)' as usual.
# - Be aware that 'CPACK_*" vars are global so an unset var might be set by a
#   previous project. So for each project reset all vars you use.
################################################################################
set( CPACK_OUTPUT_CONFIG_FILE        "${CMAKE_CURRENT_BINARY_DIR}/CPackConfig.cmake" )
set( CPACK_SOURCE_OUTPUT_CONFIG_FILE "${CMAKE_CURRENT_BINARY_DIR}/CPackSourceConfig.cmake" )
set( CPACK_INSTALL_CMAKE_PROJECTS    "${CMAKE_CURRENT_BINARY_DIR};${PROJECT_NAME};ALL;/" )

if( UNIX AND NOT APPLE )
	set( CPACK_GENERATOR DEB ) #TXZ
#[[
	find_program( RPMBUILD rpmbuild )
	if( RPMBUILD )
		message( STATUS "Found rpmbuild: ${RPMBUILD}" )
		set( CPACK_GENERATOR ${CPACK_GENERATOR} RPM )
	else( RPMBUILD )
		message( STATUS "Not found rpmbuild: RPM package won't be generated" )
	endif( RPMBUILD )
#]]
endif( UNIX AND NOT APPLE )

set( CPACK_STRIP_FILES "" )
set( CPACK_PACKAGE_DIRECTORY "${CMAKE_BINARY_DIR}/out" )
set( CPACK_PACKAGE_NAME "${PROJECT_NAME}" )
set( CPACK_PACKAGE_VERSION "${PROJECT_VERSION}" )
set( CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}" )
set( CPACK_PACKAGE_FILE_NAME
	"${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_HOST_SYSTEM_PROCESSOR}"
	)

set( CPACK_PACKAGE_VENDOR  "${NORMIES_MAINTAINER}" )
set( CPACK_PACKAGE_CONTACT "${NORMIES_MAINTAINER}" )
set( CPACK_DEBIAN_PACKAGE_HOMEPAGE "${NORMIES_URL}" )
set( CPACK_RPM_PACKAGE_URL         "${NORMIES_URL}" )

set( CPACK_DEBIAN_FILE_NAME DEB-DEFAULT )
set( CPACK_DEBIAN_PACKAGE_CONTROL_STRICT_PERMISSION TRUE )
set( CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON )
set( CPACK_RPM_FILE_NAME RPM-DEFAULT )

macro( CPackRegister )
	add_custom_target( "package-${PROJECT_NAME}"
		COMMAND ${CMAKE_CPACK_COMMAND} --config "${CMAKE_CURRENT_BINARY_DIR}/CPackConfig.cmake"
		DEPENDS ${ARGV}
		)

	add_dependencies( pack "package-${PROJECT_NAME}" )
endmacro()



if( INSTALL_BUILD_TIME_DEP MATCHES TRUE )

	message( STATUS "Build-time packages dependencies will be installed" )

	find_program( APT apt )
	if( APT )
		message( STATUS "Found apt: ${APT}" )
	else()
		message( ERROR "Not found apt: Debian build-time packages dependencies won't be installed" )
	endif()

	macro( InstallDebianDependencies )
		add_custom_target( "Dependencies-${PROJECT_NAME}"
			COMMAND grep '^[^\#]' "${CMAKE_CURRENT_SOURCE_DIR}/dependencies.debian" | xargs -r -- sudo apt install -y
			COMMENT "Install build-time dependencies for ${PROJECT_NAME} target"
			DEPENDS ${ARGV}
			)
	endmacro()

	macro( AddDebianRepositories )
		add_custom_target( "AddDebianRepositories-${PROJECT_NAME}"
			COMMAND grep '^[^\#]' "${CMAKE_CURRENT_SOURCE_DIR}/repositories.debian" | xargs -r -- sudo add-apt-repository -y
			COMMAND sudo apt update
			COMMENT "Add APT repositories for ${PROJECT_NAME} target"
			DEPENDS ${ARGV}
			)
	endmacro()

else()

	message( STATUS "Build-time packages dependencies won't be installed" )

	macro( InstallDebianDependencies )
		add_custom_target( "Dependencies-${PROJECT_NAME}" 
#			COMMENT "Nothing to do"
			DEPENDS ${ARGV}
			)
	endmacro()
	macro( AddDebianRepositories )
		add_custom_target( "AddDebianRepositories-${PROJECT_NAME}"
#			COMMENT "Nothing to do"
			DEPENDS ${ARGV}
			)
	endmacro()

endif()

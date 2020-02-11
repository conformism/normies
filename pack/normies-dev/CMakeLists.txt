cmake_minimum_required( VERSION 3.11 )

project( Normies-dev
	VERSION 0.0.0
	DESCRIPTION "Normies developer starter-pack"
	)

####################################################################DEPENDENCIES

InstallDebianDependencies()

############################################################################PACK

include( CPackConfig )

set( CPACK_PACKAGE_NAME "normies-dev" )

set( CPACK_DEBIAN_PACKAGE_SECTION "devel" )
set( CPACK_DEBIAN_PACKAGE_DEPENDS
	"virt-manager,
	vagrant,
	docker,
	git,
	subversion,
	terminator"
	)

set( CPACK_RPM_PACKAGE_LICENSE "GPL-3.0" )

include( CPack )
CPackRegister( "Dependencies-${PROJECT_NAME}" )


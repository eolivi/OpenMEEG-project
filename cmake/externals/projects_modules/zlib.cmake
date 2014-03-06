# OpenMEEG
#
# Copyright (c) INRIA 2013-2014. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.

function(zlib_project)

    set(ep zlib)

    # List the dependencies of the project

    set(${ep}_dependencies "")
      
    # Prepare the project

    EP_Initialisation(${ep} 
        USE_SYSTEM OFF 
        BUILD_SHARED_LIBS ON
    )

    if (NOT USE_SYSTEM_${ep})

        # Set directories

        EP_SetDirectories(${ep} EP_DIRECTORIES ep_dirs)

        # Define repository where get the sources

        if (NOT DEFINED ${ep}_SOURCE_DIR)
            set(location
                URL "http://sourceforge.net/projects/libpng/files/zlib/1.2.8/zlib-1.2.8.tar.gz"
                URL_MD5 "44d667c142d7cda120332623eab69f40")
        endif()

        # Add specific cmake arguments for configuration step of the project

        set(ep_optional_args)

        # set compilation flags

        if (UNIX)
            set(${ep}_c_flags "${${ep}_c_flags} -w")
        endif()

        set(cmake_args
            ${ep_common_cache_args}
            ${ep_optional_args}
            -DCMAKE_C_FLAGS:STRING=${${ep}_c_flags}
            -DCMAKE_SHARED_LINKER_FLAGS:STRING=${${ep}_shared_linker_flags}  
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep}}
            -DBUILD_TESTING:BOOL=OFF
        )

        # Check if patch has to be applied

        ep_GeneratePatchCommand(zlib ZLIB_PATCH_COMMAND)

        # Add external-project

        ExternalProject_Add(${ep}
            ${ep_dirs}
            ${location}
            UPDATE_COMMAND ""
            ${ZLIB_PATCH_COMMAND}
            CMAKE_GENERATOR ${gen}
            CMAKE_ARGS ${cmake_args}
            INSTALL_COMMAND ""
        )

        # Set variable to provide infos about the project

        ExternalProject_Get_Property(zlib binary_dir)
        set(${ep}_DIR ${binary_dir} PARENT_SCOPE)

        # Add custom targets

        EP_AddCustomTargets(${ep})

    endif() #NOT USE_SYSTEM_ep

endfunction()
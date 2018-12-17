CMAKE_MINIMUM_REQUIRED(VERSION 2.8.5)
PROJECT(IRI Fortran)

SET(VERSION 2018.0)

FUNCTION(DOWNLOAD_URL URL LOCAL_PATH)
    IF (NOT EXISTS ${LOCAL_PATH})
        MESSAGE("-- Download ${URL} ${LOCAL_PATH}")
        FILE(DOWNLOAD
            ${URL}
            "${LOCAL_PATH}"
            HTTPHEADER "User-Agent: Mozilla/5.0"
            STATUS RC)
        LIST(GET RC 0 RC_CODE)
        IF(NOT RC_CODE EQUAL 0)
            MESSAGE(FATAL_ERROR "error: downloading '${URL}' failed")
        ENDIF()
    ENDIF()
ENDFUNCTION()

# if(NOT CMAKE_Fortran_FLAGS MATCHES "-Wall$")
#   set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Wall")
# endif()

# Don't add underscores in symbols for C-compatability
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-underscoring")

GET_FILENAME_COMPONENT(FCNAME ${CMAKE_Fortran_COMPILER} NAME)
IF(FCNAME STREQUAL "pgf90")
    UNSET(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS)
ENDIF(FCNAME STREQUAL "pgf90")

ENABLE_TESTING()

DOWNLOAD_URL(
    http://irimodel.org/indices/apf107.dat
    "${CMAKE_CURRENT_BINARY_DIR}/apf107.dat")

DOWNLOAD_URL(
    http://irimodel.org/indices/ig_rz.dat
    "${CMAKE_CURRENT_BINARY_DIR}/ig_rz.dat")
    
FILE(GLOB LIB_SOURCES "*.for")
LIST(FILTER LIB_SOURCES EXCLUDE  REGEX "iritest\\.for")

ADD_LIBRARY(iri STATIC ${LIB_SOURCES})

file(GLOB TEST_SOURCES "iritest.for")
add_executable(iritest ${TEST_SOURCES})
target_link_libraries(iritest iri)
add_test(NAME iritest COMMAND "${EXECUTABLE_OUTPUT_PATH}/iritest")

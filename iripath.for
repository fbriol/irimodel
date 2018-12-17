** IRIPATH -- Returns the path to the data required by the model.
      FUNCTION IRIPATH (PATH) RESULT(ENVVAR)
      CHARACTER(LEN=*), INTENT(IN) :: PATH

* This routine prefixes the PATH variable with the value contained in the
* environment variable "IRIPATH". If the environment variable is not defined,
* the function returns the value of the PATH parameter passed as an argument.
*
* Arguments:
*   PATH   (input)  : Input file path
*-----------------------------------------------------------------------
      INTEGER STATUS, LENGTH
      CHARACTER(LEN=1024) :: ENVVAR

      CALL GET_ENVIRONMENT_VARIABLE("IRIPATH", ENVVAR, LENGTH, STATUS)
      IF (STATUS /= 0) THEN
        ENVVAR = PATH
      ELSE
        ENVVAR = TRIM(ENVVAR)
        LENGTH = LEN_TRIM(ENVVAR)
        IF (INDEX(ENVVAR, "/", .TRUE.) == LENGTH) THEN
          ENVVAR = ENVVAR(1:LENGTH - 1)
        ENDIF
        ENVVAR = TRIM(ENVVAR) // "/" // PATH
      ENDIF
      END

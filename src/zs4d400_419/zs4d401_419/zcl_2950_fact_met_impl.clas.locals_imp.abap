CLASS lcl_connection DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        i_airlineid        TYPE /dmo/carrier_id
        i_connectionnumber TYPE /dmo/connection_id
        i_fromAirport      TYPE /dmo/airport_from_id
        i_toAirport        TYPE /dmo/airport_to_id.

    CLASS-METHODS
      get_connection IMPORTING airlineId            TYPE /dmo/carrier_id
                               connectionNumber     TYPE /dmo/connection_id
                     RETURNING VALUE(ro_connection) TYPE REF TO lcl_Connection.

  PRIVATE SECTION.
    DATA AirlineId TYPE /dmo/carrier_id.
    DATA ConnectionNumber TYPE /dmo/connection_id.
    DATA fromAirport TYPE /dmo/airport_from_id.
    DATA toAirport TYPE /dmo/airport_to_id.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.

  METHOD constructor.
    me->airlineid = airlineid.
    me->connectionnumber = connectionnumber.
    me->fromAirport = fromAirport.
    me->toAirport = toAirport.

  ENDMETHOD.

  METHOD get_connection.
    DATA fromAirport TYPE /dmo/airport_from_id.
    DATA toAirport TYPE /dmo/airport_to_id.

    SELECT SINGLE FROM /dmo/connection
           FIELDS airport_from_id, airport_to_id
           WHERE carrier_id = @airlineid
           AND connection_id = @connectionnumber
           INTO ( @fromAirport, @toAirport ).

    ro_connection = NEW #( i_airlineid = airlineid
                           i_connectionnumber = connectionnumber
                           i_fromairport = fromairport
                           i_toairport = toairport ).

  ENDMETHOD.

ENDCLASS.

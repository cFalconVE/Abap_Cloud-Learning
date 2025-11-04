CLASS ltcl_find_flights DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CLASS-DATA:
      the_carrier       TYPE REF TO lcl_carrier,
      somre_flight_date TYPE /lrn/cargoflight.

    METHODS:
      test_find_cargo_flight FOR TESTING RAISING cx_static_check.

    CLASS-METHODS:
      class_setup.

ENDCLASS.

CLASS ltcl_find_flights IMPLEMENTATION.

  METHOD test_find_cargo_flight.

*    SELECT SINGLE
*      FROM /lrn/cargoflight
*    FIELDS carrier_id, connection_id, flight_date, airport_from_id, airport_to_id
*      INTO @DATA(somre_flight_date).
*
*    IF sy-subrc <> 0.
*      cl_abap_unit_assert=>fail( `No data in table /LRN/CARGOFLIGHT` ).
*    ENDIF.
*
*    TRY.
*        DATA(the_carrier) = NEW lcl_carrier( somre_flight_date-carrier_id ).
*      CATCH cx_abap_invalid_value.
*        cl_abap_unit_assert=>fail( 'Unable to Instantiati lcl_carrier' ).
*    ENDTRY.

    the_carrier->find_cargo_flight(
      EXPORTING
        i_airport_from_id = somre_flight_date-airport_from_id
        i_airport_to_id   = somre_flight_date-airport_to_id
        i_from_date       = somre_flight_date-flight_date
        i_cargo           = 1
      IMPORTING
        e_flight          = DATA(flight)
        e_days_later      = DATA(days_later) ).


    cl_abap_unit_assert=>assert_bound(
         act = flight
         msg = `Method find_cargo_flight does not return a result` ).

    cl_abap_unit_assert=>assert_equals(
        act = days_later
        exp = 0
        msg = `Method find_cargo_flight returns wrong result` ).

  ENDMETHOD.

  METHOD class_setup.

    SELECT SINGLE
        FROM /lrn/cargoflight
      FIELDS carrier_id, connection_id, flight_date, airport_from_id, airport_to_id
        INTO CORRESPONDING FIELDS OF @somre_flight_date.

    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( `No data in table /LRN/CARGOFLIGHT` ).
    ENDIF.

    TRY.
        the_carrier = NEW lcl_carrier( somre_flight_date-carrier_id ).
      CATCH cx_abap_invalid_value.
        cl_abap_unit_assert=>fail( 'Unable to Instantiati lcl_carrier' ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

CLASS zcl_2950_fs_acce DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_2950_fs_acce IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

* Execute this class using Profile As->ABAP Application
* In the analysis, look at the comparative runtimes of
* the methods loop_work_area( ) and loop_field_symbol( )

    DATA(flights) = NEW lcl_demo( ).

    flights->use_work_area( ).
    flights->use_field_symbol( ).
    out->write( 'Done' ).
  ENDMETHOD.
ENDCLASS.

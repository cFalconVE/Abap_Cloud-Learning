CLASS lhc_zr_419_flight DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Vuelo
        RESULT result,
      validatePrice FOR VALIDATE ON SAVE
        IMPORTING keys FOR Vuelo~validatePrice,
      validateCurrency FOR VALIDATE ON SAVE
        IMPORTING keys FOR Vuelo~validateCurrency.
ENDCLASS.

CLASS lhc_zr_419_flight IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validatePrice.
    DATA failed_record LIKE LINE OF failed-vuelo.
    DATA reported_record LIKE LINE OF reported-vuelo.

    READ ENTITIES OF zr_419_flight IN LOCAL MODE
        ENTITY Vuelo
            FIELDS ( Price )
            WITH CORRESPONDING #( keys )
            RESULT DATA(vuelos).

    LOOP AT vuelos INTO DATA(vuelo).
      IF vuelo-Price <= 0.
        failed_record-%tky = vuelo-%tky.

        APPEND failed_record TO failed-vuelo.

        reported_record-%tky = vuelo-%tky.
        reported_record-%msg = new_message(
                                    id = '/LRN/S4D400'
                                    number = '101'
                                    severity = ms-error ).

        APPEND reported_record TO reported-vuelo.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateCurrency.
    DATA failed_record LIKE LINE OF failed-vuelo.
    DATA reported_record LIKE LINE OF reported-vuelo.

    DATA exits TYPE abap_bool.

    READ ENTITIES OF zr_419_flight IN LOCAL MODE
        ENTITY Vuelo
            FIELDS ( CurrencyCode )
            WITH CORRESPONDING #( keys )
            RESULT DATA(vuelos).

    LOOP AT vuelos INTO DATA(vuelo).
      exits = abap_false.

      SELECT SINGLE FROM I_Currency
          FIELDS @abap_true
          WHERE Currency = @vuelo-CurrencyCode
          INTO @exits.

      IF exits = abap_false.
        failed_record-%tky = vuelo-%tky.

        APPEND failed_record TO failed-vuelo.

        reported_record-%tky = vuelo-%tky.
        reported_record-%msg = new_message(
                                    id = '/LRN/S4D400'
                                    number = '102'
                                    severity = if_abap_behv_message=>severity-error
                                    v1 = vuelo-CurrencyCode ).

        APPEND reported_record TO reported-vuelo.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

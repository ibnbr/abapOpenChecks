CLASS zcl_aoc_check_31 DEFINITION
  PUBLIC
  INHERITING FROM zcl_aoc_super
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor.

    METHODS check
        REDEFINITION.
    METHODS get_attributes
        REDEFINITION.
    METHODS get_message_text
        REDEFINITION.
    METHODS put_attributes
        REDEFINITION.
    METHODS if_ci_test~query_attributes
        REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mt_error TYPE zaoc_slin_desc_key_range_tt.
    DATA mt_warn TYPE zaoc_slin_desc_key_range_tt.
    DATA mt_info TYPE zaoc_slin_desc_key_range_tt.
    DATA mt_ignore TYPE zaoc_slin_desc_key_range_tt.

    METHODS set_flags
      RETURNING
        VALUE(rs_flags) TYPE rslin_test_flags.
ENDCLASS.



CLASS ZCL_AOC_CHECK_31 IMPLEMENTATION.


  METHOD check.

* abapOpenChecks
* https://github.com/larshp/abapOpenChecks
* MIT License

    DATA: lv_obj_name TYPE sobj_name,
          lv_text     TYPE string,
          lv_tmp      TYPE string,
          ls_flags    TYPE rslin_test_flags,
          lv_code     TYPE sci_errc,
          lv_errty    TYPE sci_errty,
          lt_result   TYPE slin_result.

    FIELD-SYMBOLS: <ls_result> LIKE LINE OF lt_result,
                   <ls_line>   LIKE LINE OF <ls_result>-lines.


    ls_flags = set_flags( ).
    CALL FUNCTION 'EXTENDED_PROGRAM_CHECK'
      EXPORTING
        program    = program_name
        test_flags = ls_flags
      IMPORTING
        result     = lt_result.

    LOOP AT lt_result ASSIGNING <ls_result>.            "#EC CI_SORTSEQ

      CLEAR lv_text.
      LOOP AT <ls_result>-lines ASSIGNING <ls_line>.
        CONCATENATE LINES OF cl_slin_io=>old_line_to_src( <ls_line> ) INTO lv_tmp.
        IF lv_text IS INITIAL.
          lv_text = lv_tmp.
        ELSE.
          CONCATENATE lv_text cl_abap_char_utilities=>newline lv_tmp INTO lv_text.
        ENDIF.
      ENDLOOP.

      IF lines( mt_error ) > 0 AND <ls_result>-code IN mt_error.
        lv_errty = c_error.
      ELSEIF lines( mt_warn ) > 0 AND <ls_result>-code IN mt_warn.
        lv_errty = c_warning.
      ELSEIF lines( mt_info ) > 0 AND <ls_result>-code IN mt_info.
        lv_errty = c_note.
      ELSEIF lines( mt_ignore ) > 0 AND <ls_result>-code IN mt_ignore.
        CONTINUE.
      ELSE.
        lv_errty = c_error.
      ENDIF.

      lv_obj_name = <ls_result>-src_incl.
      lv_code = <ls_result>-code.
      inform( p_sub_obj_type = c_type_include
              p_sub_obj_name = lv_obj_name
              p_line         = <ls_result>-src_line
              p_kind         = lv_errty
              p_test         = myname
              p_code         = lv_code
              p_param_1      = lv_text ).
    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    super->constructor( ).

    description    = 'Extended Program Check, Filterable'.  "#EC NOTEXT
    category       = 'ZCL_AOC_CATEGORY'.
    version        = '002'.
    position       = '031'.

    has_attributes = abap_true.
    attributes_ok  = abap_true.

  ENDMETHOD.                    "CONSTRUCTOR


  METHOD get_attributes.

    EXPORT
      mt_error = mt_error
      mt_warn = mt_warn
      mt_info = mt_info
      mt_ignore = mt_ignore
      TO DATA BUFFER p_attributes.

  ENDMETHOD.


  METHOD get_message_text.

    p_text = '&1'.                                          "#EC NOTEXT

  ENDMETHOD.                    "GET_MESSAGE_TEXT


  METHOD if_ci_test~query_attributes.

    zzaoc_top.

    zzaoc_fill_att mt_error 'Error' 'S'.                    "#EC NOTEXT
    zzaoc_fill_att mt_warn 'Warning' 'S'.                   "#EC NOTEXT
    zzaoc_fill_att mt_info 'Info' 'S'.                      "#EC NOTEXT
    zzaoc_fill_att mt_ignore 'Ignore' 'S'.                  "#EC NOTEXT

    zzaoc_popup.
    attributes_ok = abap_true.

  ENDMETHOD.


  METHOD put_attributes.

    IMPORT
      mt_error = mt_error
      mt_warn = mt_warn
      mt_info = mt_info
      mt_ignore = mt_ignore
      FROM DATA BUFFER p_attributes.                 "#EC CI_USE_WANTED
    ASSERT sy-subrc = 0.

  ENDMETHOD.


  METHOD set_flags.

    rs_flags-x_per = abap_true.
    rs_flags-x_cal = abap_true.
    rs_flags-x_dat = abap_true.
    rs_flags-x_opf = abap_true.
    rs_flags-x_unr = abap_true.
    rs_flags-x_ges = abap_true.
    rs_flags-x_mes = abap_true.
    rs_flags-x_pfs = abap_true.
    rs_flags-x_bre = abap_true.
    rs_flags-x_woo = abap_true.
    rs_flags-x_wrn = abap_true.
    rs_flags-x_ste = abap_true.
    rs_flags-x_txt = abap_true.
    rs_flags-x_aut = abap_true.
    rs_flags-x_sub = abap_true.
    rs_flags-x_loa = abap_true.
    rs_flags-x_mls = abap_true.
    rs_flags-x_put = abap_true.
    rs_flags-x_hel = abap_true.

  ENDMETHOD.
ENDCLASS.
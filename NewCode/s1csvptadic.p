    /* Fecha: 24/may/2019
    * Nombre Programa: s1csvptadic.p
    * Descripcion: Genera csv de s1_ptadic (de datos cargados en el 80.1.13) */
    /* **** MIGRACION EE *************************************************** */
    /* REV: EE       DATE: 22-SEP-2020   BY: *DF00* Diego Fernandez          */
    /* REV: EE       DATE: 27-MAY-2021   BY: *AA00* Adriel Arandez          */
          
          
          {us/mf/mfdtitle.i "pp"}
          {us/px/pxmaint.i}
          {us/bbi/gplabel.i}
          
          define variable logOk                  like mfc_logical                             no-undo.
          define variable ctitulo1               as character         format "x(70)"          no-undo.
          define variable cstatus                as character         format 'x(40)'          no-undo.
          define variable cnombre                as character                                 no-undo.
          define variable cetiq                  as character                                 no-undo.
          define variable clabel                 as character                                 no-undo.
          define variable cdesfam                as character                                 no-undo.
          define variable cPath                  as character                                 no-undo.
          define variable ii                     as INTEGER           format "99"             no-undo.
          define variable form_num               as logical                                   no-undo.
          define variable old_numeric_format     as character                                 no-undo.
          
          define variable cSalidaPara            as character                                 no-undo.
          define variable cArch                  as character                                 no-undo.
          define variable cRutaArch              as character                                 no-undo.
          define variable cFullArch              as character                                 no-undo.
          define variable cRutaUser              as character                                 no-undo.
          define variable oplCopiaOK             as logical                                   no-undo.
    /*AA00*/     /*
          define variable cim_part               like   s1_ptsig_part.  
          define variable cim_qadpart            like   s1_ptsig_part.
          define variable cim_site               like   si_site.
          define variable cim_date               like   s1_ptadic_date.
          define variable cim_grupo              like   s1_ptadic_grupo.
          define variable cim_moneda             like   s1_ptadic_moneda.
          define variable cim_scrp_pct           like   s1_ptadic_scrp_pct.
          define variable cim_tipo_com           like   s1_ptadic_tipo_com.
          define variable cim_pm_code            like   s1_ptadic_pm_code.
          define variable cim_element            like   s1_ptadic_element.
          define variable cim_filial             as     character.   
          define variable cim_error              like   s1_ptsig_desc.
    /*AA00*/     */ 
          define stream stExcel.

          session:data-entry-return = true.
          
          form
             skip(1)
             form_num          colon 20       label "Separador Decimal"      format "./,"
             skip(1)
             ctitulo1          at 8        no-label
             cArch             at 8        no-label                          format "x(70)"
             skip(3)
             cstatus           at 8        no-label                          format "x(70)"
          with frame a side-labels width 80 attr-space.
          setFrameLabels(frame a:handle).
          
          
          cSalidaPara = "s1csvptadic.p".
          
          cArch = "PTADIC".
          for first code_mstr no-lock
             where code_domain = global_domain
             and   code_fldname = "archivo_para"
             and   code_value   = cSalidaPara
             :
             cArch = code_cmmt.
          end.
          
          cRutaArch = "".
          for first code_mstr no-lock
             where code_domain = global_domain
             and   code_fldname = "salida_para"
             and   code_value   = cSalidaPara
             :
             assign
                cRutaArch = code_user2
                cRutaUser = code_desc.
          end.
          
          assign
             form_num  = false /* separador decimal coma */
             cArch     = cArch + "_"
                       + string(year(today),"9999") 
                       + string(month(today),"99") 
                       + string(day(today),"99") 
                       + ".csv"
             cstatus   = ""
          
          ctitulo1 = trim(getTermLabel("SS_FILE_NAME",50)).
          if ctitulo1 = "SS_FILE_NAME" then ctitulo1 = "Nombre de Archivo a generar:".
          display ctitulo1 with frame a.
          
          
          repeat on error undo, retry on endkey undo, leave with frame a:
             
             display cstatus with frame a.
             
             update 
                form_num 
                cArch
             with frame a.
             
             cstatus = "".
             display cstatus with frame a.
             
             if cArch = "" then do:
                {us/bbi/pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
                undo, retry.
             end.
             
             if cRutaArch = "" then do:
                {us/bbi/pxmsg.i &MSGNUM=44100 ERRORLEVEL=4} /* No se definio valor de 'salida_para' */
                undo, retry.
             end.
             
             logOk = yes.
             {us/bbi/pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=logOk}
             if not logOk then undo,retry.
             
             
             old_numeric_format = session:numeric-format.
             
             if form_num /* punto */
                then session:numeric-format = "American".
                else session:numeric-format = "European".
             
             {us/bbi/pxmsg.i &MSGNUM=1323 &MSGBUFFER=cstatus}   /* Procesando ... */
             display cstatus with frame a.
             
             cFullArch = cRutaArch + cArch.
             
             output stream stExcel to value(cFullArch).
             
    /*AA00*/ cnombre = "cim_part"           + ";"
                     + "cim_qadpart"         + ";"
                     + "cim_site"           + ";"
                     + "cim_date"          + ";"
                     + "cim_grupo"         + ";"
                     + "cim_moneda"       + ";"
                     + "cim_scrp_pct"        + ";"
                     + "cim_tipo_com"        + ";"
                     + "cim_pm_code"      + ";"
                     + "cim_element[1]"          + ";"
                     + "cim_element[2]"          + ";"
                     + "cim_element[3]"         + ";"
                     + "cim_element[4]" + ";"
                     + "cim_element[5]" + ";"
                     + "cim_filial" +      ";"
                     + "cim_error"
                     .
             
             clabel  = "Item"                + ";"
                     + "Sin-Uso"                  + ";"
                     + "Sin-Uso"           + ";"
                     + "Fecha"    + ";"
                     + "Grupo"           + ";"
                     + "Moneda"  + ";"
                     + "Porc-Desperd"      + ";"
                     + "Tipo-Comp"               + ";"
                     + "Código-PM"         + ";"
                     + "Elem1"         + ";"
                     + "Elem2"         + ";"
                     + "Elem3"        + ";"
                     + "Elem4" +      ";"
                     + "Elem5" 
    /*AA00*/         .
             
             put stream stExcel unformatted 
/*AA00*/      /*cnombre skip*/
                clabel skip.
     
     
             for each s1_ptadic no-lock where s1_ptadic_domain = global_domain:
                export stream stExcel delimiter ";"
    /*AA00*/            s1_ptadic_part           /*cim_part       */
                        ""           /*cim_qadpart    */
                        ""                 /*cim_site       */
                        s1_ptadic_date          /*cim_date       */
                        s1_ptadic_grupo         /*cim_grupo      */
                        s1_ptadic_moneda        /*cim_moneda     */
                        s1_ptadic_scrp_pct      /*cim_scrp_pct   */
                        s1_ptadic_tipo_com      /*cim_tipo_com   */
                        s1_ptadic_pm_code       /*cim_pm_code    */
                        s1_ptadic_element[1]    /*cim_element[1] */
                        s1_ptadic_element[2]    /*cim_element[2] */
                        s1_ptadic_element[3]    /*cim_element[3] */
                        s1_ptadic_element[4]    /*cim_element[4] */
    /*AA00*/            s1_ptadic_element[5]    /*cim_element[5] */
                      skip.
             end.
             
             output stream stExcel close.
             
             /* copia el archivo temporal a su carpeta definitiva */
             {us/t1/t1filetransf.i &tipo='PUT' &programa=cSalidaPara &salida=oplCopiaOK &nombre=cArch}
             
             if oplCopiaOK = true then do:
                {us/bbi/pxmsg.i &MSGNUM=3120 &MSGBUFFER=cstatus}  /* Procedimiento Finalizado */
                display cstatus with frame a.
                
                {us/bbi/pxmsg.i &MSGNUM=44101 ERRORLEVEL=1 &MSGARG1=cRutaUser} /* Archivo generado en # */
             end.
             else do:
                {us/bbi/pxmsg.i &MSGNUM=44102 &MSGBUFFER=cstatus} /* Error copiando archivo a ubicacion definitiva */
                display cstatus with frame a.
                
                {us/bbi/pxmsg.i &MSGNUM=44102 ERRORLEVEL=1} /* Error copiando archivo a ubicacion definitiva */
             end.
             
          end. /* repeat */
          
          hide frame a.
          
          
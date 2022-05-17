/* s1cargaptadic2.p - CIM a Mant.Datos de Productos ppptmt04.p            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                     */
/*K1Q4*/ /*V8:WebEnabled=No                                               */
/* REVISION: 8.6Dgui  MODIFIED DATE: 11/29/05   BY: M.Costigliolo         */
/* REVISION: 8.6Dgui  MODIFIED DATE: 08/21/06   BY: *IGS2* Ignacio Garcia */
/* REVISION: 8.6Dgui  MODIFIED DATE: 08/21/06   BY: *IGS3* Ignacio Garcia */
/* **** MIGRACION EE **************************************************** */
/* REV: EE       DATE: 09-OCT-2020   BY: *DF00* Diego Fernandez           */
/* REV: EE       DATE: 09-ABR-2021   BY: *CM00* Carlos Moreno             */
/* REV: EE       DATE: 26-MAY-2021   BY: *AA00* Adriel Arandez             */

         /*DISPLAY TITLE*/
         {us/mf/mfdtitle.i "b+ "}
         
         define variable linea_entrada          as character   format "x(300)".
         define variable linefield              as character   format "x(255)"
                                                               extent 40.
         define variable group_progress_errors  as integer.
         define variable group_function_errors  as integer.
         define variable mensaje                as character.
         define variable i                      as integer.
         define variable validar                as logical.
         
         define variable yn                     like mfc_logical                          no-undo.
         define variable iFila                  as integer                                no-undo.
         define variable iReg                   as integer                                no-undo.
         define variable iRegOk                 as integer                                no-undo.
         define variable iRegErr                as integer                                no-undo.
         define variable cTxt1                  as character                              no-undo.
         define variable cTxt2                  as character                              no-undo.
         define variable cTxt3                  as character                              no-undo.
         define variable cTxt4                  as character                              no-undo.
         define variable cTxt1a                 as character                              no-undo.
         define variable cTxt2a                 as character                              no-undo.
         define variable cTxt3a                 as character                              no-undo.
         define variable cTxt4a                 as character                              no-undo.
         define variable cTxt1b                 as character                              no-undo.
         define variable cTxt2b                 as character                              no-undo.
         define variable cTxt3b                 as character                              no-undo.
         define variable cTxt4b                 as character                              no-undo.
         define variable cMsg                   as character                              no-undo.
         define variable cLblFila               as character                              no-undo.
         
         define variable cSalidaPara            as character                              no-undo.
         define variable cArch                  as character                              no-undo.
         define variable cArchLog               as character                              no-undo.
         define variable cRutaArch              as character                              no-undo.
         define variable cFullArchLog           as character                              no-undo.
         define variable cFullArch              as character                              no-undo.
         define variable cRutaUser              as character                              no-undo.
         define variable oplCopiaOK             as logical                                no-undo.
         
         define stream strLog.

         define temp-table cim
            field cim_fila          as integer
            field cim_part          like s1_ptsig_part 
            field cim_qadpart       like s1_ptsig_part 
            field cim_site          like si_site
            field cim_date          like s1_ptadic_date
            field cim_grupo         like s1_ptadic_grupo
            field cim_moneda        like s1_ptadic_moneda  
            field cim_scrp_pct      like s1_ptadic_scrp_pct
            field cim_tipo_com      like s1_ptadic_tipo_com
            field cim_pm_code       like s1_ptadic_pm_code 
            field cim_element       like s1_ptadic_element
            field cim_filial        as character
            field cim_error         like s1_ptsig_desc.
         
         form
            skip(1)
            cRutaUser      colon 20       label "Ruta del archivo"         format "x(55)"
            cArch          colon 20       label "Archivo a Importar"       format "x(55)"
            skip(1)
            cArchLog       colon 20       label 'Archivo de Salida'        format "x(55)"
            skip(1)
            cTxt1          at 3        no-label                            format "x(75)"
            cTxt2          at 3        no-label                            format "x(75)"
            cTxt3          at 3        no-label                            format "x(75)"
            cTxt4          at 3        no-label                            format "x(75)"
            skip(1)
            iReg           colon 20       label "Total Leidos"             format ">>>,>>>,>>9"
            iRegOk         colon 20       label "Procesados OK"            format ">>>,>>>,>>9"
            iRegErr        colon 20       label "Reg. con errores"         format ">>>,>>>,>>9"
         with frame a side-labels width 80 attr-space.
         setFrameLabels(frame a:handle).
         

         cSalidaPara = "s1cargaptadic2.p".
         
         cArch = "".
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
         
         cArchLog = "".
         
         cTxt1a = trim(getTermLabel("s1cargaptadic2_formato_csv_cTxt1a",46)).
         if cTxt1a = "s1cargaptadic2_formato_csv_cTxt1a" then cTxt1a = "FORMATO ARCHIVO ENTRADA:".
         cTxt1b = trim(getTermLabel("s1cargaptadic2_formato_csv_cTxt1b",46)).
         if cTxt1b = "s1cargaptadic2_formato_csv_cTxt1b" then cTxt1b = "".
         cTxt1 = cTxt1a + cTxt1b.
         
         cTxt2a = trim(getTermLabel("s1cargaptadic2_formato_csv_cTxt2a",46)).
/*CM00*/ if cTxt2a = "s1cargaptadic2_formato_csv_cTxt2a" then cTxt2a = "ITEM;SIN-USO;SIN-USO;FECHA;GRUPO;MONEDA;PORC-DESPERD;".
/*CM00*  if cTxt2a = "s1cargaptadic2_formato_csv_cTxt2a" then cTxt2a = "ITEM;QAD-ITEM;SIN-USO;ALMACEN;FECHA;GRUPO;MONEDA;PORC-DESPERD;". */
         cTxt2b = trim(getTermLabel("s1cargaptadic2_formato_csv_cTxt2b",46)).
         if cTxt2b = "s1cargaptadic2_formato_csv_cTxt2b" then cTxt2b = "".
         cTxt2 = cTxt2a + cTxt2b.
         
         cTxt3a = trim(getTermLabel("s1cargaptadic2_formato_csv_cTxt3a",46)).
         if cTxt3a = "s1cargaptadic2_formato_csv_cTxt3a" then cTxt3a = " TIPO-COMP;CODIGO-PM;ELEM-1;ELEM-2;ELEM-3;ELEM-4;ELEM-5".
         cTxt3b = trim(getTermLabel("s1cargaptadic2_formato_csv_cTxt3b",46)).
         if cTxt3b = "s1cargaptadic2_formato_csv_cTxt3b" then cTxt3b = "".
         cTxt3 = cTxt3a + cTxt3b.
         
         cTxt4a = trim(getTermLabel("s1cargaptadic2_formato_csv_cTxt4a",46)).
         if cTxt4a = "s1cargaptadic2_formato_csv_cTxt4a" then cTxt4a = "(CON CABECERA)".
         cTxt4b = trim(getTermLabel("s1cargaptadic2_formato_csv_cTxt4b",46)).
         if cTxt4b = "s1cargaptadic2_formato_csv_cTxt4b" then cTxt4b = "".
         cTxt4 = cTxt4a + cTxt4b.
         
         cLblFila = trim(getTermLabel("SS_FILA",20)).
         if cLblFila = "SS_FILA" then cLblFila = "Fila".
         
         
         mainloop:
         repeat on error undo, retry 
                on endkey undo, leave
            :
            
            display
               cRutaUser
               cTxt1
               cTxt2
               cTxt3
               cTxt4
               iReg   
               iRegOk 
               iRegErr
            with frame a.
            
            /*BORRO POSIBLES DATOS ANTERIORES*/    
            for each cim exclusive-lock:
               delete cim.
            end.                
            
            /*SOLICITA EL NOMBRE DE ARCHIVO Y VALIDA QUE SEA <> ""*/
            update 
               cArch
            with frame a.
            
            assign
               iReg    = 0
               iRegOk  = 0
               iRegErr = 0.
               
            display 
               iReg
               iRegOk
               iRegErr
            with frame a.
            
            if cArch = "" then do:
               {us/bbi/pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
               next-prompt cArch with frame a.
               next mainloop.
            end.
            
            if cRutaArch = "" then do:
               {us/bbi/pxmsg.i &MSGNUM=44100 ERRORLEVEL=4} /* No se definio valor de 'salida_para' */
               next mainloop.
            end.
            
            /* traer archivo a ubicacion de trabajo con t1filetransf.i */
            {us/t1/t1filetransf.i &tipo='GET' &programa=cSalidaPara &salida=oplCopiaOK &nombre=cArch}
            
            if oplCopiaOK <> true then do:
               {us/bbi/pxmsg.i &MSGNUM=44103 &ERRORLEVEL=3} /* Error copiando archivo a ubicacion de trabajo */
               next mainloop.
            end.
            
            cFullArch = cRutaArch + cArch.

            if search(cFullArch) = ? then do:
               {us/bbi/pxmsg.i &MSGNUM=53 &ERRORLEVEL=3} /* File does not exist */
               next mainloop.
            end.
            
            cArchLog = cArch + ".log".
            
            do on error undo, retry:
               update 
                  cArchLog 
               with frame a.
               
               if cArchLog = "" then do:
                  {us/bbi/pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
                  undo, retry.
               end.
               
               if cArchLog = cArch then do:
                  {us/bbi/pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}  /* Opcion no valida */
                  undo, retry.
               end.
            end.
            
            display cArchLog with frame a.
            
            
            yn = yes.
            /* Is all information correct */
            {us/bbi/pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
            if yn = no then do:
               {us/bbi/pxmsg.i &MSGNUM=3737 &ERRORLEVEL=1} /* Proceso abortado */
               next mainloop.
            end.
            
            iFila = 0.
            
/*CM00*/    /* Agrega una linea al final del archivo para importarlo correctamente */
/*CM00*/    output to value(cFullArch) append.
/*CM00*/    put skip(1).
/*CM00*/    output close.
            
            /*REDIRECCIONA LA ENTRADA AL ARCHIVO INGRESADO*/ 
            input from value(cFullArch).
               /*LEE EL REGISTRO DE CABECERA*/
               import unformatted linea_entrada.
               
            /*GENERACION DE TEMP-TABLE CON DATOS DE PRODUCTOS*/
            repeat:
               /*LEE EL REGISTRO Y LO ASIGNA A UNA VARIABLE*/
               import unformatted linea_entrada.
/*AA00*/       IF ENTRY(1,linea_entrada,";") = "" THEN NEXT.
               /*CREA LA TABLA*/
               create cim.  
               assign
                  iFila      = iFila + 1
                  cim_fila   = iFila
                  cim_filial = global_domain.
               
               if num-entries(linea_entrada, ";") >= 14 then do: /*AA00: Cambiar a 14 de nuevo*/
                  /*CARGA LOS DATOS A LOS CAMPOS*/
/*CM00*/          assign
/*CM00*/             cim_part       = REPLACE( entry(1,linea_entrada,";"),'"',"")
/*CM00*/             cim_qadpart    = REPLACE( entry(2,linea_entrada,";"),'"',"")
/*CM00*/             cim_site       = REPLACE( entry(3,linea_entrada,";"),'"',"")
/* /*CM00*/             cim_date       = ? */
                     cim_date       = date(entry(4,linea_entrada,";"))
/*CM00*/             cim_grupo      = REPLACE( entry(5,linea_entrada,";"),'"',"")
/*CM00*/             cim_moneda     = REPLACE( entry(6,linea_entrada,";"),'"',"")
/*CM00*/             cim_scrp_pct   = 0
/*CM00*/             cim_tipo_com   = REPLACE( entry(8,linea_entrada,";"),'"',"")
/*CM00*/             cim_pm_code    = REPLACE( entry(9,linea_entrada,";"),'"',"")
/*CM00*/             cim_element[1] = REPLACE( entry(10,linea_entrada,";"),'"',"")
/*CM00*/             cim_element[2] = REPLACE( entry(11,linea_entrada,";"),'"',"")
/*CM00*/             cim_element[3] = REPLACE( entry(12,linea_entrada,";"),'"',"")
/*CM00*/             cim_element[4] = REPLACE( entry(13,linea_entrada,";"),'"',"")
/*CM00*/             cim_element[5] = REPLACE( entry(14,linea_entrada,";"),'"',"")
/*CM00*/             .

/*CM00*           assign                                            */
/*CM00*              cim_part       = entry(1,linea_entrada,";")    */
/*CM00*              cim_qadpart    = entry(2,linea_entrada,";")    */
/*CM00*              cim_site       = entry(4,linea_entrada,";")    */
/*CM00*              cim_date       = ?                             */
/*CM00*              cim_grupo      = entry(6,linea_entrada,";")    */
/*CM00*              cim_moneda     = entry(7,linea_entrada,";")    */
/*CM00*              cim_scrp_pct   = 0                             */
/*CM00*              cim_tipo_com   = entry(9,linea_entrada,";")    */
/*CM00*              cim_pm_code    = entry(10,linea_entrada,";")   */
/*CM00*              cim_element[1] = entry(11,linea_entrada,";")   */
/*CM00*              cim_element[2] = entry(12,linea_entrada,";")   */
/*CM00*              cim_element[3] = entry(13,linea_entrada,";")   */
/*CM00*              cim_element[4] = entry(14,linea_entrada,";")   */
/*CM00*              cim_element[5] = entry(15,linea_entrada,";")   */
/*CM00*              .                                              */
                  
                  cim_date = date(entry(4,linea_entrada,";")) no-error.
                  if error-status:error then do:
                     {us/bbi/pxmsg.i &MSGNUM=2479 &MSGBUFFER=cMsg} /* Error de formato de fecha */
                     if cim_error <> "" then cim_error = cim_error + " | ".
                     assign
                        cim_error = cim_error + cMsg + " (" + cLblFila + " " + string(cim_fila) + ")".
                        cim_date  = ?.
                  end.
                  
                  cim_scrp_pct = decimal(entry(7,linea_entrada,";")) no-error.
                  
                  if error-status:error then do:
                     {us/bbi/pxmsg.i &MSGNUM=5950 &MSGBUFFER=cMsg} /* Formato numero no valido */
                     if cim_error <> "" then cim_error = cim_error + " | ".
                     assign
                        cim_error    = cim_error + cMsg + " (" + cLblFila + " " + string(cim_fila) + ")".
                        cim_scrp_pct = 0.
                  end.
                  
               end.
               else do:
                  cim_part  = REPLACE( entry(1,linea_entrada,";"),'"',"").
                  {us/bbi/pxmsg.i &MSGNUM=44107 &MSGBUFFER=cim_error} /* La cantidad de columnas en la fila es incorrecta */
                  cim_error = cim_error + " (" + cLblFila + " " + string(cim_fila) + ")".
               end.
            end. /*repeat*/ 
            
            input close.  
            
            /*BORRO POSIBLES REGISTROS EN BLANCO*/
            /*for each cim exclusive-lock 
               where cim_error   = "" 
               and   cim_qadpart = ""
               :
               delete cim.
            end.*/
            
            for each cim:
               iReg = iReg + 1.
            end.
            
            
            for each cim where cim_error = "":
/*CM00*        * A pedido se saca validacion *               
               find first cp_mstr no-lock
                  where cp_domain    = global_domain
                  and   cp_cust      = cim_site 
                  and   cp_cust_part = cim_qadpart no-error.
               if not available cp_mstr then do:
                  iRegErr = iRegErr + 1.
                  {us/bbi/pxmsg.i &MSGNUM=44106 &MSGARG1=cim_qadpart &MSGARG2=cim_site &MSGBUFFER=cim_error} /* No existe maestro item/cliente (cp_mstr) con #/# */
                  cim_error = cim_error + " (" + cLblFila + " " + string(cim_fila) + ")".
                  next.
               end.
*CM00*/               
               find first pt_mstr no-lock
                  where pt_domain = global_domain
/*CM00*/          and   pt_part   = cim_part no-error.
/*CM00*           and   pt_part   = cp_part no-error. */
               if available pt_mstr then do:
                  find first s1_ptadic exclusive-lock
                     where s1_ptadic_domain = global_domain
/*CM00*/             and   s1_ptadic_part   = cim_part 
/*CM00*              and   s1_ptadic_part   = cp_part  */
                     and   s1_ptadic_date   = cim_date 
                     and   s1_ptadic_grupo  = cim_grupo no-error.
                  if not available s1_ptadic then do:
                     create s1_ptadic.
                     assign
                        s1_ptadic_domain = global_domain
/*CM00*/                s1_ptadic_part   = cim_part 
/*CM00*                 s1_ptadic_part   = cp_part  */
                        s1_ptadic_date   = cim_date 
                        s1_ptadic_grupo  = cim_grupo.
                  end.
                  
                  assign
                     iRegOk                = iRegOk + 1
                     s1_ptadic_moneda      =  cim_moneda        
                     s1_ptadic_scrp_pct    =  cim_scrp_pct   
                     s1_ptadic_tipo_com    =  cim_tipo_com
                     s1_ptadic_pm_code     =  cim_pm_code    
                     s1_ptadic_element[1]  =  cim_element[1] 
                     s1_ptadic_element[2]  =  cim_element[2] 
                     s1_ptadic_element[3]  =  cim_element[3] 
                     s1_ptadic_element[4]  =  cim_element[4] 
                     s1_ptadic_element[5]  =  cim_element[5]. 
                  
               end.
               else do:
                  {us/bbi/pxmsg.i &MSGNUM=16 &MSGBUFFER=cim_error} /* No existe numero de producto */
                  cim_error = cim_error + " (" + cLblFila + " " + string(cim_fila) + ")" .
               end.
               
            end. /* for each cim */
            
            
            cFullArchLog = cRutaArch + cArchLog.
            output stream strLog to value(cFullArchLog).            
            
            for each cim where cim_error <> "":
               put stream strLog unformatted
                     cim_part        ";"
                     cim_qadpart     ";"
/*CM00*              ""              ";" */
                     cim_site        ";"
                     cim_date        ";"
                     cim_grupo       ";"
                     cim_moneda      ";"
                     cim_scrp_pct    ";"
                     cim_tipo_com    ";"
                     cim_pm_code     ";"
/*AA00*/             cim_element[1]  ";"
                     cim_element[2]     ";"
                     cim_element[3]     ";"
                     cim_element[4]     ";"
/*AA00*/             cim_element[5]     ";"
                     cim_filial      ";"
                     cim_error
                     skip.
               
               iRegErr = iRegErr + 1.
            end.
            
            output stream strLog close.
            
            display
               iReg
               iRegOk
               iRegErr
            with frame a.
            
            /* copia el archivo log a su carpeta definitiva */
            {us/t1/t1filetransf.i &tipo='PUT' &programa=cSalidaPara &salida=oplCopiaOK &nombre=cArchLog}
            
            if oplCopiaOK = true then do:
               {us/bbi/pxmsg.i &MSGNUM=44104 ERRORLEVEL=1 &MSGARG1=cRutaUser} /* Archivo de LOG copiado a # */
            end.
            else do:
               {us/bbi/pxmsg.i &MSGNUM=44102 ERRORLEVEL=1} /* Error copiando archivo a ubicacion definitiva */
            end.
            
            if iRegErr > 0 then do:
               {us/bbi/pxmsg.i &MSGNUM=44105 &ERRORLEVEL=4} /* Consulte errores en archivo LOG */
            end.
            else do:
               {us/bbi/pxmsg.i &MSGNUM=3120 &ERRORLEVEL=1} /* Proceso terminado */
            end.
            
         end.
         
         
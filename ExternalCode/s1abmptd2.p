/* s1abmptd2.p - MANT MASIVO ATRIBUTOS PRODUCTOS/FILIAL                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/* REV: 2013SE        DATE: 06-OCT-2020    BY: Diego Fernandez *DF00*      */
 

         {us/mf/mfdtitle.i " "}
         {us/px/pxmaint.i}
         {us/bbi/gplabel.i}
         
         define stream strLog.
         
         define variable iReg                         as integer                                no-undo.
         define variable iRegOk                       as integer                                no-undo.
         define variable iRegErr                      as integer                                no-undo.
         define variable limppriReg                   like mfc_logical                          no-undo.
         define variable yn                           like mfc_logical                          no-undo.
         define variable cestado                      as character         format "x(20)"       no-undo.
         define variable ctitformato                  as character         format "x(70)"       no-undo.
         define variable cformato                     as character         format "x(70)"       no-undo.
         define variable cblinea                      as character         view-as combo-box inner-lines 6 no-undo.
         define variable cLblTxt                      as character                              no-undo.
         define variable cLbl                         as character                              no-undo.
         define variable cOpcion                      as character                              no-undo.
         define variable cMsg                         as character                              no-undo.
         define variable i                            as integer                                no-undo.
         define variable recid_ptsig                  as recid                                  no-undo.
         define variable cLblTotalLeidos              as character                              no-undo.
         define variable cLblProcesadosOk             as character                              no-undo.
         define variable cLblRegConError              as character                              no-undo.
         define variable cLblCol_1                    as character                              no-undo.
         define variable cLblCol_2                    as character                              no-undo.
         define variable cLblCol_3                    as character                              no-undo.
         define variable cLblCol_4                    as character                              no-undo.
         
         define variable cSalidaPara                  as character                              no-undo.
         define variable cArch                        as character                              no-undo.
         define variable cArchLog                     as character                              no-undo.
         define variable cRutaArch                    as character                              no-undo.
         define variable cFullArchLog                 as character                              no-undo.
         define variable cFullArch                    as character                              no-undo.
         define variable cRutaUser                    as character                              no-undo.
         define variable oplCopiaOK                   as logical                                no-undo.
         
         define temp-table ttImporta
            field tt_pos               as integer
            field tt_filial            as character
            field tt_part              as character
            field tt_valor             as character
            field tt_error             as character
         index ttIdx tt_pos.
         
         
         form
            skip(1)
            cRutaUser      colon 20       label "Ruta del archivo"         format "x(55)"
            cArch          colon 20       label "Archivo a Importar"       format "x(55)"
            cblinea        colon 20       label "Linea"                    format "x(50)"
            skip(1)
            cArchLog       colon 20       label 'Archivo de Salida'        format "x(55)"
            skip(1)
            limppriReg     colon 22       label "Importa 1er registro"
            skip (1)
            ctitformato    at 3        no-label                            format "x(70)"
            cformato       at 3        no-label                            format "x(70)"
            skip(1)
            cestado        colon 15    no-label
            skip(1)
            iReg           colon 20       label "Total Leidos"             format ">>>,>>>,>>9"
            iRegOk         colon 20       label "Procesados OK"            format ">>>,>>>,>>9"
            iRegErr        colon 20       label "Reg. con errores"         format ">>>,>>>,>>9"
         with frame a side-labels width 80 attr-space.
         setFrameLabels(frame a:handle).
         

         cSalidaPara = "s1gerprod.p".
         for first code_mstr no-lock
            where code_domain = global_domain
            and   code_fldname = "s1gerprod.p"
            and   code_value   = "salida_para"
            :
            cSalidaPara = code_cmmt.
         end.
         
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
         
         ctitformato = trim(getTermLabel("S1_FILE_FORMAT",50)).
         if ctitformato = "S1_FILE_FORMAT" then ctitformato = "FORMATO ARCHIVO ENTRADA:".
         
         cformato = trim(getTermLabel("s1gerprod_formato_csv",50)).
         if cformato = "s1gerprod_formato_csv" then cformato = "Cod Producto ; Nuevo Valor".
         
         cLblCol_1 = trim(getTermLabel("s1gerprod_cLblCol_1",50)).
         if cLblCol_1 = "s1gerprod_cLblCol_1" then cLblCol_1 = "Fila Archivo".
         
         cLblCol_2 = trim(getTermLabel("s1gerprod_cLblCol_2",50)).
         if cLblCol_2 = "s1gerprod_cLblCol_2" then cLblCol_2 = "Cod Producto".
         
         cLblCol_3 = trim(getTermLabel("s1gerprod_cLblCol_3",50)).
         if cLblCol_3 = "s1gerprod_cLblCol_3" then cLblCol_3 = "Nuevo Valor".
         
         cLblCol_4 = trim(getTermLabel("s1gerprod_cLblCol_4",50)).
         if cLblCol_4 = "s1gerprod_cLblCol_4" then cLblCol_4 = "Errores".
         
         cLblTotalLeidos = trim(getTermLabel("S1_TOTAL_LEIDOS",50)).
         if cLblTotalLeidos = "S1_TOTAL_LEIDOS" then cLblTotalLeidos = "Total Leidos".
         
         cLblProcesadosOk = trim(getTermLabel("S1_PROCESADOS_OK",50)).
         if cLblProcesadosOk = "S1_PROCESADOS_OK" then cLblProcesadosOk = "Procesados OK".
         
         cLblRegConError = trim(getTermLabel("S1_REG_CON_ERROR",50)).
         if cLblRegConError = "S1_REG_CON_ERROR" then cLblRegConError = "Registros con Error".
         
         cblinea:add-last("").
         
         do i = 1 to 6:
            cLbl = "s1abmptd2_linea_" + string(i, "99"). /* s1abmptd2_linea_01 a 99 */
            cLblTxt = trim(getTermLabel(cLbl,40)).
            cLblTxt = string(i, "99") + ": " + cLblTxt.
            cblinea:add-last(cLblTxt).
            /*
            "01: Linea Promocion"
            "02: Linea Marketing"
            "03: Linea Promocion Nueva"
            "04: Linea Marketing Nueva"
            "05: Linea Propia"
            "06: Prorrateo"
            */
         end.
         
         
         mainloop:
         repeat:
            
            display 
               cRutaUser
               cArchLog
               ctitformato 
               cformato 
               iReg   
               iRegOk 
               iRegErr
            with frame a.
            
            update 
               cArch 
            with frame a.
            
            assign
               cestado = ""
               iReg    = 0
               iRegOk  = 0
               iRegErr = 0.
               
            display 
               cestado
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
                  cblinea
                  cArchLog 
                  limppriReg
               with frame a.
               
               if cblinea = "" then do:
                  {us/bbi/pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
                  next-prompt cblinea with frame a.
                  undo, retry.
               end.
               
               if cArchLog = "" then do:
                  {us/bbi/pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
                  next-prompt cArchLog with frame a.
                  undo, retry.
               end.
               
               if cArchLog = cArch then do:
                  {us/bbi/pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}  /* Opcion no valida */
                  next-prompt cArchLog with frame a.
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
            
            {us/bbi/pxmsg.i &MSGNUM=1323 &MSGBUFFER=cestado}   /* Procesando ... */
            display cestado with frame a.
            
            output to value(cFullArch) append.
            put skip(1).
            output close.
            
            for each ttImporta: delete ttImporta. end.
            
            input from value(cFullArch). 
            
            repeat:
               create ttImporta.
               assign
                  iReg      = iReg + 1
                  tt_pos    = iReg
                  tt_filial = global_domain
                  tt_error  = "".
               
               import delimiter ";" 
                  tt_part
                  tt_valor
                  .
            end.
            
            input close.
            
            if not limpprireg then do:
               /* borrar la 1ra linea */
               for first ttImporta where tt_pos = 1:
                  delete ttImporta.
                  iReg = iReg - 1.
               end.
            end.
            
            for each ttImporta where tt_part = "":
               delete ttImporta.
               iReg = iReg - 1.
            end.
            
            cOpcion = entry(1, cblinea, ":").
            
            
            for each ttImporta:
               
               find first s1_ptsig_mstr no-lock
                  where s1_ptsig_domain = global_domain
                  and   s1_ptsig_part   = tt_part no-error.
               if not available s1_ptsig_mstr then do:
                  {us/bbi/pxmsg.i &MSGNUM=44115 &MSGBUFFER=cMsg} /* No existe el Producto en s1_ptsig_mstr */
                  if tt_error <> "" then tt_error = tt_error + " | ".
                  tt_error = tt_error + cMsg.
               end.
               else do:
                  recid_ptsig = recid(s1_ptsig_mstr).
                  
                  find first s1_ptsigf_det exclusive-lock
                     where s1_ptsigf_domain = global_domain
                     and   s1_ptsigf_filial = tt_filial
                     and   s1_ptsigf_part   = s1_ptsig_part no-error.
                  if not available s1_ptsigf_det then do:
                     {us/bbi/pxmsg.i &MSGNUM=44133 &MSGBUFFER=cMsg} /* No existe el Producto en s1_ptsigf_det */
                     if tt_error <> "" then tt_error = tt_error + " | ".
                     tt_error = tt_error + cMsg.
                  end.
               end.
               
               if tt_error = "" then do:
               
                  case cOpcion:
                     when "01" then do: /* Linea Promocion */
                        find first code_mstr no-lock
                           where code_domain  = global_domain
                           and   code_fldname = 'salnp_mstr%' + tt_filial
                           and code_value     = tt_valor no-error.
                        if not available code_mstr then do:
                           {us/bbi/pxmsg.i &MSGNUM=44134 &MSGBUFFER=cMsg} /* No existe linea de promocion */
                           if tt_error <> "" then tt_error = tt_error + " | ".
                           tt_error = tt_error + cMsg.
                        end.
                     end.
                     when "02" then do: /* Linea Marketing */
                        find first code_mstr no-lock
                           where code_domain  = global_domain
                           and   code_fldname = 'salnt_mstr%' + tt_filial
                           and code_value     = tt_valor no-error.
                        if not available code_mstr then do:
                           {us/bbi/pxmsg.i &MSGNUM=44135 &MSGBUFFER=cMsg} /* No existe linea de marketing */
                           if tt_error <> "" then tt_error = tt_error + " | ".
                           tt_error = tt_error + cMsg.
                        end.
                     end.
                     when "03" then do: /* Linea Promocion Nueva */
                        find first code_mstr no-lock
                           where code_domain  = global_domain
                           and   code_fldname = 'salnpn_mstr%' + tt_filial
                           and code_value     = tt_valor no-error.
                        if not available code_mstr then do:
                           {us/bbi/pxmsg.i &MSGNUM=44136 &MSGBUFFER=cMsg} /* No existe linea de promo nueva */
                           if tt_error <> "" then tt_error = tt_error + " | ".
                           tt_error = tt_error + cMsg.
                        end.
                     end.
                     when "04" then do: /* Linea Marketing Nueva */
                        find first code_mstr no-lock
                           where code_domain  = global_domain
                           and   code_fldname = 'salntn_mstr%' + tt_filial
                           and code_value     = tt_valor no-error.
                        if not available code_mstr then do:
                           {us/bbi/pxmsg.i &MSGNUM=44137 &MSGBUFFER=cMsg} /* No existe linea de Marketing nueva */
                           if tt_error <> "" then tt_error = tt_error + " | ".
                           tt_error = tt_error + cMsg.
                        end.
                     end.
                     when "05" then do: /* Linea Propia */
                        find first code_mstr no-lock
                           where code_domain  = global_domain
                           and   code_fldname = 'salnpp_mstr%' + tt_filial
                           and code_value     = tt_valor no-error.
                        if not available code_mstr then do:
                           {us/bbi/pxmsg.i &MSGNUM=44138 &MSGBUFFER=cMsg} /* No existe linea propia */
                           if tt_error <> "" then tt_error = tt_error + " | ".
                           tt_error = tt_error + cMsg.
                        end.
                     end.
                     when "06" then do: /* Prorrateo */
                        find first s1_pro_mstr no-lock
                           where s1_pro_domain = global_domain
                           and   s1_pro_codigo = tt_valor no-error.
                        if not available s1_pro_mstr then do:
                           {us/bbi/pxmsg.i &MSGNUM=44139 &MSGBUFFER=cMsg} /* No existe Prorrateo */
                           if tt_error <> "" then tt_error = tt_error + " | ".
                           tt_error = tt_error + cMsg.
                        end.
                     end.
                  end. /* case */
                  
                  
                  if tt_error = "" and available s1_ptsigf_det then do:
                     case cOpcion:
                        when "01" then do: /* Linea Promocion */
                           assign
                              iRegOk              = iRegOk + 1
                              s1_ptsigf_linea_pro = tt_valor.
                        end.
                        when "02" then do: /* Linea Marketing */
                           assign
                              iRegOk              = iRegOk + 1
                              s1_ptsigf_linea_mar = tt_valor.
                        end.
                        when "03" then do: /* Linea Promocion Nueva */
                           assign
                              iRegOk                  = iRegOk + 1
                              s1_ptsigf_linea_pro_nue = tt_valor.
                        end.
                        when "04" then do: /* Linea Marketing Nueva */
                           assign
                              iRegOk                  = iRegOk + 1
                              s1_ptsigf_linea_mar_nue = tt_valor.
                        end.
                        when "05" then do: /* Linea Propia */
                           assign
                              iRegOk                 = iRegOk + 1
                              s1_ptsigf_linea_propia = tt_valor.
                        end.
                        when "06" then do: /* Prorrateo */
                           assign
                              iRegOk             = iRegOk + 1
                              s1_ptsigf_chr01[1] = tt_valor.
                        end.
                     end. /* case */
                     
                    /*actualiza saaln_mstr*/
                    {us/bbi/gprun.i ""s1sincpt.p"" "(recid_ptsig, no, yes, no,global_domain)" }

                  end. /* if tt_error = "" */
               end. /* if tt_error = "" */
               
               release s1_ptsigf_det.
            end. /* for each ttImporta */
            
            cFullArchLog = cRutaArch + cArchLog.
            output stream strLog to value(cFullArchLog).
            
            if can-find(first ttImporta where tt_error <> "") then do:
               
               put stream strLog unformatted
                  cLblCol_1     ";"
                  cLblCol_2     ";"
                  cLblCol_3     ";"
                  cLblCol_4
                  skip.
               
               for each ttImporta where tt_error <> "":
                  iRegErr =  iRegErr + 1.
                  
                  put stream strLog unformatted
                     tt_pos        ";"
                     tt_part       ";"
                     tt_valor      ";"
                     tt_error
                     skip.
               end.
            end.
            
            put stream strLog unformatted skip(1).
            put stream strLog unformatted cLblTotalLeidos  ": " iReg    skip.
            put stream strLog unformatted cLblProcesadosOk ": " iRegOk  skip.
            put stream strLog unformatted cLblRegConError  ": " iRegErr skip.
            
            output stream strLog close.
            
            /* copia el archivo log a su carpeta definitiva */
            {us/t1/t1filetransf.i &tipo='PUT' &programa=cSalidaPara &salida=oplCopiaOK &nombre=cArchLog}
            
            if oplCopiaOK = true then do:
               {us/bbi/pxmsg.i &MSGNUM=3120 &MSGBUFFER=cestado}  /* Archivo de LOG copiado a # */
               {us/bbi/pxmsg.i &MSGNUM=44104 ERRORLEVEL=1 &MSGARG1=cRutaUser} /* Archivo de LOG copiado a # */
            end.
            else do:
               {us/bbi/pxmsg.i &MSGNUM=44102 &MSGBUFFER=cestado} /* Error copiando archivo a ubicacion definitiva */
               {us/bbi/pxmsg.i &MSGNUM=44102 ERRORLEVEL=1} /* Error copiando archivo a ubicacion definitiva */
            end.
            
            display 
               cestado 
               iReg
               iRegOk
               iRegErr
            with frame a.
            
            if iRegErr > 0 then do:
               {us/bbi/pxmsg.i &MSGNUM=44105 &ERRORLEVEL=1} /* Consulte errores en archivo LOG */
            end.
            else do:
               {us/bbi/pxmsg.i &MSGNUM=3120 &ERRORLEVEL=1} /* Proceso terminado */
            end.
            
            
         end. /* repeat */
         
         /* ********************************************************** */
         
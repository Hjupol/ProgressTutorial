/* s1actcstpmp.p - Actualizar el costo PEA de material en base al costo     */
/* calculado con porcentaje de venta   									*/
/* GUI CONVERTED from cssccp.p (converter v1.75) Fri Sep  8 09:55:30 2000 	*/
/* cssccp.p - COST ELEMENT COPY                                         	*/
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  	*/
/* All rights reserved worldwide.  This is an unpublished work.         	*/
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   	*/
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 	*/
/* REVISION: 7.3     LAST MODIFIED: 02/18/93    BY: pma *G032*          	*/
/* REVISION: 7.3     LAST MODIFIED: 08/24/94    BY: pxd *GL48*          	*/
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98 BY: *L007* A. Rahane        	*/
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan       	*/
/* REVISION: 8.6E    LAST MODIFIED: 07/16/98 BY: *J2RT* Niranjan R.      	*/
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane 	*/
/* REVISION: 9.1     LAST MODIFIED: 08/11/00 BY: *N0KK* jyn              	*/
/* REVISION: 9.1     LAST MODIFIED: 08/23/00 BY: *N0MW* Mudit Mehta      	*/
/* REVISION: 9.1     LAST MODIFIED: oct/31/19 BY: ** C.Moreno            	*/
/* REVISION: 9.1     LAST MODIFIED: abr/01/20 BY: *CM01* C.Moreno         	*/
/* REVISION: 9.1     LAST MODIFIED: may/20/20 BY: *CM02* C.Moreno           */
/* REVISION: 9.1     LAST MODIFIED: jun/03/20 BY: *CM03* C.Moreno * traspaso 
                     a UY directo cuando filial pertenece a subregion CEA   */
/* REVISION: 9.1     LAST MODIFIED: jun/12/20 BY: *CM04* C.Moreno           */
/* REVISION: 9.1     LAST MODIFIED: jul/30/20 BY: *CM05* C.Moreno           */
/* REVISION: 9.1     LAST MODIFIED: ago/13/20 BY: *CM06* C.Moreno           */
/* REVISION: 9.1     LAST MODIFIED: sep/11/20 BY: *DF01* Diego Fernandez    */
/****************************************************************************/
/* REV: EE   DATE: 19-NOV-2020  BY: *DF01* Diego Fernandez - Migracion a EE */


/*CM04*//* En la filial me debe actualizar materiales por el precio de      */ 
/*CM04*//* venta de la filial con true up más los gastos en uy.             */                     

         {us/mf/mfdtitle.i "b+ "}
         {us/t1/t1sigdef.i "new"}
         /*  {us/s1/s1logsig.i "false"} **DF01: se quita en migracion EE */
         /* DF01: se agrega en migracion EE (inicio) */
         define variable cSubRegionFilial    as character            no-undo.
         
         assign
            filial  = global_domain
            anio    = year(today)
            per     = month(today)
            usuario = global_userid.
         /* DF01: se agrega en migracion EE (fin) */
         
         define variable cSalidaPara                  as character                              no-undo.
         define variable cRutaArch                    as character                              no-undo.
         define variable cArchCim1                    as character                              no-undo.
         define variable cArchLog1                    as character                              no-undo.
         define variable cFullArchCim1                as character                              no-undo.
         define variable cFullArchLog1                as character                              no-undo.
         define variable cArchCim2                    as character                              no-undo.
         define variable cArchLog2                    as character                              no-undo.
         define variable cFullArchCim2                as character                              no-undo.
         define variable cFullArchLog2                as character                              no-undo.
         define variable cRutaUser                    as character                              no-undo.
         define variable oplCopiaOK                   as logical                                no-undo.
         
         /* DISPLAY TITLE */
         /*GUI moved mfdeclre/mfdtitle.*/
         define stream st1.         
         define stream st2.
         
         define variable yn             as logical initial no     no-undo.
         define variable iCont          as integer                no-undo.
         define variable cError         as character              no-undo.
         define variable sim1n          like spt_sim              no-undo.
         define variable sim2c          like spt_sim              no-undo.
         define variable hay_error      like mfc_logical          no-undo.
         define variable v_error        as character              no-undo.
         define variable cElem          as character              no-undo.
         define variable cElem2         as character              no-undo.
         define variable cElemDefault   as character              no-undo.
         define variable cGrupo         as character              no-undo.
         
         define variable iPeriodo       as integer format "99" 
            view-as radio-set radio-buttons s1actcstpmp_lbl_opc1, 1,       /* Anual         */ 
                                            s1actcstpmp_lbl_opc2, 2,       /* Mes Ingresado */ 
                                            s1actcstpmp_lbl_opc3, 3,       /* Ene-Mar       */ 
                                            s1actcstpmp_lbl_opc4, 4,       /* Abr-Jun       */ 
                                            s1actcstpmp_lbl_opc5, 5,       /* Jul-Sep       */
                                            s1actcstpmp_lbl_opc5, 6.       /* Oct-Dic       */
         
         define variable deTot_Vta       as decimal               no-undo.
         define variable iUnid           as integer               no-undo.
         define variable dePcioUni       as decimal               no-undo.   
         define variable dePcioFin       as decimal               no-undo.
         define variable cFilialDestino  as character             no-undo.
         define variable cProdDestino    as character             no-undo.
         define variable cGrupoDestino   as character.
         define variable iPerDesde       as integer format "99".
         define variable iPerHasta       as integer format "99".
         define variable cTipoCosto      as character format "xx".
         define variable cGrupoCosto     as character format "x".
         define variable part            like pt_part             no-undo.
         define variable part1           like pt_part             no-undo.
         define variable cpm             as character             no-undo.
         define variable deCstMat        as decimal               no-undo.
         define variable deCstUni        as decimal               no-undo.
         define variable deCstMatygastos as decimal               no-undo.
         define variable lNoRelProdProv  like mfc_logical         no-undo.
         define variable cSubReg         as character no-undo initial "CEA".
         define variable cFilialUY       as character no-undo initial "UY".
         define variable csalida         as character initial "a.txt".
         define variable cRetorno        as character.
         
         cFilialUY = "UY".
         for first code_mstr no-lock 
            where code_domain  = global_domain
            and   code_fldname = "s1actcstpmp.p"
            and   code_value   = "cFilialUY"
            :
            cFilialUY = code_cmmt.
         end.
         
         cSubReg = "CEA".
         for first code_mstr no-lock 
            where code_domain  = global_domain
            and   code_fldname = "s1actcstpmp.p"
            and   code_value   = "cSubReg"
            :
            cSubReg = code_cmmt.
         end.
         
         cElem = "PT".
         for first code_mstr no-lock 
            where code_domain  = global_domain
            and   code_fldname = "s1actcstpmp.p"
            and   code_value   = "cElem"
            :
            cElem = code_cmmt.
         end.
         
         cElem2 = "MATERIAL".
         for first code_mstr no-lock 
            where code_domain  = global_domain
            and   code_fldname = "s1actcstpmp.p"
            and   code_value   = "cElem2"
            :
            cElem2 = code_cmmt.
         end.
         
         cElemDefault = "PT".
         for first code_mstr no-lock 
            where code_domain  = global_domain
            and   code_fldname = "s1actcstpmp.p"
            and   code_value   = "cElemDefault"
            :
            cElemDefault = code_cmmt.
         end.
         
         
         /* ******************************************************************* */
         function obtmat returns decimal (cFilialDestino as character, 
                                          anio as int, 
                                          per as int,
                                          cProdDestino as character, 
                                          cTipoCosto as character, 
                                          cGrupoCosto as character,
                                          output cRetorno as character
                                          )
            :
            
            def var iultdia as integer.
            def var iultdiaok as integer.
            def var dtdia as date.
            
            define variable decostomat as decimal.
            define variable cSim as character.
            
            cRetorno = "".
            iultdia = 31.
            assign dtdia = date(per,iultdia,anio) no-error.
            if error-status:error then do:
                iultdia = iultdia - 1.
                assign dtdia = date(per,iultdia,anio) no-error.
                if error-status:error then do:
                    iultdia = iultdia - 1.
                    assign dtdia = date(per,iultdia,anio) no-error.
                    if error-status:error then do:
                        iultdia = iultdia - 1.
                        assign dtdia = date(per,iultdia,anio) no-error.
                    end.
                end.
            end.
            
            cSim = trim(cTipoCosto) + trim(cGrupoCosto) + substring(string(anio),3,2) + string(per,"99").
            decostomat = 0.
            
            for each ps_mstr no-lock
               where ps_domain = global_domain
               and   ps_par    = cProdDestino
               and   ps_start <= dtdia     
               and   ps_end   >= dtdia
               by ps_comp
               :
               find first s1_ptsig_mstr no-lock
                  where s1_ptsig_domain = global_domain
                  and   s1_ptsig_part = ps_comp no-error.
               if not available s1_ptsig_mstr then do:
                  cRetorno = ps_comp.
                  return 0.00.
               end.
               
               if s1_ptsig_tipo = "GE" OR s1_ptsig_tipo = "GS" then do:
                  for each sct_det no-lock
                     where sct_domain = global_domain
                     and   sct_site   = cFilialDestino
                     and   sct_sim    = cSim
                     and   sct_part   = ps_comp
                     :
                     decostomat = decostomat + (sct_mtl_tl * ps_qty_per).
                  end.
               end.
            end.
            
            return decostomat.
         end function.
         /* ******************************************************************* */
         
         form
            anio        colon 18    label "Año/Per"         format "9999"
            per                  no-label                   format "99"
            part        colon 18    label "Producto"
            part1                   label "A"
            cGrupo      colon 18    label "Grupo"           format "x(16)"
            iPeriodo    colon 18 no-label
            cTipoCosto  colon 18    label "Costo Destino"
         with frame a side-labels width 80.
         setFrameLabels(frame a:handle). /* SET EXTERNAL LABELS */
         
         cSalidaPara = "s1actcstpmp.p".
         for first code_mstr no-lock
            where code_domain = global_domain
            and   code_fldname = "s1actcstpmp.p"
            and   code_value   = "salida_para"
            :
            cSalidaPara = code_cmmt.
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
         
         /* ASIGNO NOMBRES PARA LOS ARCHIVOS CIM */
         assign
            cArchCim1 = filial + "_actcst_" 
                      + global_userid 
                      + string(year(today),"9999")
                      + string(month(today),"99") 
                      + string(day(today),"99") 
                      + replace(trim(string(time,"hh:mm:ss")),":","") 
                      + ".dat"
            cArchLog1 = filial + "_actcst_" + global_userid + string(year(today),"9999")
                      + string(month(today),"99") 
                      + string(day(today),"99") 
                      + replace(trim(string(time,"hh:mm:ss")),":","") 
                      + ".log".
         
         assign
            cArchCim2 = filial + "_copcst_" 
                     + global_userid 
                      + string(year(today),"9999")
                      + string(month(today),"99") 
                      + string(day(today),"99") 
                      + replace(trim(string(time,"hh:mm:ss")),":","") 
                      + ".dat"
            cArchLog2 = filial + "_copcst_" 
                      + global_userid 
                      + string(year(today),"9999")
                      + string(month(today),"99") 
                      + string(day(today),"99") 
                      + replace(trim(string(time,"hh:mm:ss")),":","") 
                      + ".log".
         
         assign
            cFullArchCim1 = cRutaArch + cArchCim1
            cFullArchCim2 = cRutaArch + cArchCim2
            cFullArchLog1 = cRutaArch + cArchLog1
            cFullArchLog2 = cRutaArch + cArchLog2.
         
         assign
            cGrupo   = "PRESUPUESTADO"
            iPeriodo = 1.
         
         
         mainloop:
         repeat:
            
            display 
               anio 
               per 
            with frame a.
            
            update
               anio
               per
            with frame a.
            
            if anio = 0 then do:
               {us/bbi/pxmsg.i &MSGNUM=44224 &ERRORLEVEL=3} /* Año invalido */
               next-prompt anio with frame a.
               next mainloop.
            end.
            
            if per < 1 or per > 12 then do:
               {us/bbi/pxmsg.i &MSGNUM=44196 &ERRORLEVEL=3} /* Periodo Invalido */
               next-prompt per with frame a.
               next mainloop.
            end.
            
            if cRutaArch = "" then do:
               {us/bbi/pxmsg.i &MSGNUM=44100 ERRORLEVEL=4} /* No se definio valor de 'salida_para' */
               next mainloop.
            end.
            
            loopa:
            do on error undo, retry:
               
               display cGrupo with frame a.
               
               /*** Asigno Set de Costo 1N ***/
               find first code_mstr no-lock
                  where code_domain  = global_domain
                  and   code_fldname = "s1_setcostos"
                  and   code_value   = "Primero" no-error.
               if not available code_mstr then do:
                  /* No se encuentra definido el set de costo Primero. */
                  {us/bbi/pxmsg.i &MSGNUM=44214 &ERRORLEVEL=3}
                  next mainloop.
               end. /* if not available code_mstr */              
               
               assign
                  cTipoCosto = trim(code_user1). 
               
               display cTipoCosto with frame a.
               
               if part1 = hi_char then part1 = "".
               
               update
                  part 
                  part1 
               /* cGrupo *** DF01: no tiene sentido pedirlo porque en el CASE solo entrara si es "PRESUPUESTADO" */ 
                  iPeriodo 
               /* cTipoCosto *** DF01: la version no lo pide */
               with frame a.
               
               assign
                  pres_real = "R" when cGrupo = "REAL"
                  pres_real = "P" when cGrupo = "PRESUPUESTADO".
               
               cGrupoCosto = trim(pres_real).
               
               if part1 = "" then part1 = hi_char.
               
               /* Setear las variables iPerDesde y iPerHasta para recorrer los periodos */
               case iPeriodo:
                  when 1 then     /* periodo anual */
                     assign 
                        iPerDesde = 1
                        iPerHasta = 12.
                  when 2 then     /* periodo actual */
                     assign 
                        iPerDesde = per
                        iPerHasta = per.
                  when 3 then     /* trimestre ene-mar */
                     assign 
                        iPerDesde = 1
                        iPerHasta = 3.
                  when 4 then     /* trimestre abr-jun */
                     assign 
                        iPerDesde = 4
                        iPerHasta = 6.
                  when 5 then     /* trimestre jul-sep */
                     assign 
                        iPerDesde = 7
                        iPerHasta = 9.
                  when 6 then     /* trimestre oct-dic */
                     assign 
                        iPerDesde = 10
                        iPerHasta = 12.
               end.
               
               if cGrupo = "" then do:
                  /*Blank not allowed*/
                  {us/bbi/pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
                  next-prompt cGrupo with frame a. 
                  undo, retry.
               end.
               
               sim1n = cTipoCosto + pres_real + substring(string(anio, "9999"),3,2) + string(iPerHasta, "99").
               
               find first sc_mstr no-lock
                  where sc_domain = global_domain
                  and   sc_sim    = sim1n no-error.
               if not available sc_mstr then do:
                  /* No es un grupo coste simulacion: # */
                  {us/bbi/pxmsg.i &MSGNUM=44248 &ERRORLEVEL=3 &MSGARG1=sim1n} 
                  /* next-prompt cTipoCosto with frame a. *** DF01: la version no lo pide */
                  undo, retry.
               end.
               
               /*** Asigno Set de Costo 2C ***/
               find first code_mstr no-lock
                  where code_domain  = global_domain
                  and   code_fldname = "s1_setcostos"
                  and   code_value   = "Segundo" no-error.
               if not available code_mstr then do:
                  /* No se encuentra definido el set de costo Segundo. */
                  {us/bbi/pxmsg.i &MSGNUM=44215 &ERRORLEVEL=3}
                  next mainloop.
               end.	
               
               sim2c = code_user1 + pres_real + substring(string(anio, "9999"),3,2) + string(per, "99").
               
               find first sc_mstr no-lock
                  where sc_domain = global_domain
                  and   sc_sim    = sim2c no-error.
               if not available sc_mstr then do:
                  /* No es un grupo coste simulacion: # */
                  {us/bbi/pxmsg.i &MSGNUM=44248 &ERRORLEVEL=3 &MSGARG1=sim2c} 
                  undo, retry.
               end.
               
               if iPeriodo = 1 then iPerHasta = 1. /* tomar el anual guardado en enero */
               
               /* valido que este parado en el periodo destino */
               if iPerHasta <> per then do:
                  {us/bbi/pxmsg.i &MSGNUM=44249 &ERRORLEVEL=3} /* Mes no valido */
                  undo, retry.
               end.
               
               
               if not batchrun then do:
                  yn = false.
                  {us/bbi/pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn} /* "Is all information correct?" */
                  if yn = no then undo, retry.
               end.
               
               
               /* GENERO ARCHIVO PARA LA CIM */
               output stream st1 to value(cFullArchCim1).
               
               assign
                  hay_error = false
                  cError    = ""
                  iCont     = 0.
               
               case cGrupo:
                  when "PRESUPUESTADO" then do:
                     
                     put stream st1 unformatted
                        " - " skip.
                        
                     for each s1_cstpc_det no-lock
                        where s1_cstpc_domain    = global_domain
                        and   s1_cstpc_filial    = filial
                        and   s1_cstpc_anio      = anio
                        and   s1_cstpc_mes       = iPerHasta
                        and   s1_cstpc_grupo     = cGrupo
                        and   s1_cstpc_canal     = ""
                        and   s1_cstpc_Producto >= part
                        and   s1_cstpc_Producto <= part1
                        :
                        /* preasigno si no llego a encontrar relación en s1_ptvp */
                        assign
                           cFilialDestino = filial
                           cProdDestino   = s1_cstpc_producto
                           cGrupoDestino  = "P".
                        
                        /* si la filial pertenece a la subregion CEA pasa directo a UY */
                        cSubRegionFilial = "".
                        for first code_mstr no-lock
                           where code_domain  = global_domain
                           and   code_fldname = "SIG_SUBREGION"
                           and   code_value   = "SIG_SUBREGION"
                           :
                           cSubRegionFilial = code_cmmt.
                        end.
                        
                        if cSubRegionFilial = cSubReg then do:
                           assign cFilialDestino = cFilialUY.
                        end.
                        else do:
                           lNoRelProdProv = false.
                           
                           find last s1_ptvp no-lock
                              where s1_ptvp_domain  = global_domain
                              and   s1_ptvp_part    = s1_cstpc_producto
                              and   s1_ptvp_filial  = filial
                              and   s1_ptvp_grupo  = "P" no-error.
                           if available s1_ptvp then do:
                              assign
                                 cFilialDestino    = s1_ptvp_filialpro
                                 cProdDestino   = s1_ptvp_partpro
                                 cGrupoDestino   = s1_ptvp_grupo.
                           end.
                           
                           if available s1_ptvp then do:
                              assign
                                 cFilialDestino    = s1_ptvp_filialpro
                                 cProdDestino   = s1_ptvp_partpro
                                 cGrupoDestino   = s1_ptvp_grupo.
                           end.
                           else do:
                              lNoRelProdProv = true.
                              leave.
                           end.
                        end.
                        
                        /* Buscar elemento material en datos adicionales de producto */
                        cElem = cElemDefault. /* "PT" seteo por default */    
                        for last s1_ptadic no-lock
                           where s1_ptadic_domain = global_domain
                           and   s1_ptadic_part   = cProdDestino
                           and   s1_ptadic_filial = cFilialDestino
                           and   s1_ptadic_grupo  = cGrupoDestino
                           use-index s1_ptadic_part
                           :
                           assign
                              cpm   = s1_ptadic_pm_code
                              cElem = s1_ptadic_element[1] when s1_ptadic_element[1] <> "".
                        end.
                        
                        if s1_cstpc_costo_uni <> ? 
                           then deCstUni = s1_cstpc_costo_uni.
                        else do:
                           /* Costo '?' en producto # */
                           {us/bbi/pxmsg.i &MSGNUM=44246 &ERRORLEVEL=1 &MSGARG1=s1_cstpc_Producto &MSGBUFFER=cError}
                           undo, retry.
                        end.
                        
                        if cpm = "M" then do:
                           deCstMat = obtmat(cFilialDestino, 
                                             anio, 
                                             per, 
                                             cProdDestino, 
                                             cTipoCosto, 
                                             cGrupoCosto,
                                             output cRetorno).
                           if cRetorno <> "" then do:
                              /* Falta cargar producto # en MANT Atributos Producto */
                              {us/bbi/pxmsg.i &MSGNUM=44243 &ERRORLEVEL=1 &MSGARG1=cRetorno &MSGBUFFER=cError}
                              undo, retry.
                           end.
                           deCstUni = s1_cstpc_costo_uni - deCstMat.
                        end.
                        
                        assign deCstUni = truncate(deCstUni,5).
                        
                        put stream st1 unformatted
                           anio ' ' 
                           per  ' '
                           '"' cProdDestino  '" ' 
                           skip
                           '"' cFilialDestino '" ' 
                           skip
                           '"' cTipoCosto '" '
                           '"' cGrupoCosto '" ' 
                           skip
                           '"' cElem '" ' 
                           deCstUni 
                           skip
                           '" " '
                           skip
                           .
                        
                        iCont = iCont + 1.
                     end. /* for each s1_cstpc_det */
                     
                     put stream st1 unformatted
                        "." skip.
                     
                     output stream st1 close.
                     
                     if lNoRelProdProv = true then do:
                        /* No existe relacion producto-proveedor para producto # */
                        {us/bbi/pxmsg.i &MSGNUM=44244 &ERRORLEVEL=4 &MSGARG1=s1_cstpc_producto}
                        undo,retry.
                     end.
                     
                     if cError <> "" then do:
                        {us/bbi/pxmsg.i &MSGNUM=44247 &ERRORLEVEL=4 &MSGARG1=cError}
                        undo,retry.
                     end.
                     
                     transaccion:            
                     do transaction on error undo, return:            
                        /* CIM  CARGA COSTO A ELEMENTO */
                        loop-cim1:
                        do /*transaction on error undo loop-cim1, leave loop-cim1*/:
                           batchrun = yes.
                           input from value(cFullArchCim1).
                           output to value(cFullArchLog1).
                           {us/bbi/gprun.i ""s1csbtld.p""}.
                           output close.
                           input close.
                           batchrun = no.
                           
                           /* Rutina validacion de cim */
                           hay_error = false.
                           input from value(cFullArchLog1).
                           
                           bus_log:
                           repeat:
                              import unformatted v_error.
                              if v_error begins "**" or v_error begins "ERRO" then do:
                                 hay_error = true.
                                 leave bus_log.
                              end.
                           end.  /* repeat */
                           
                           input close.
                           
                           if hay_error then do:
                              {us/t1/t1filetransf.i &tipo='PUT' &programa=cSalidaPara &salida=oplCopiaOK &nombre=cArchCim1}
                              if oplCopiaOK then do:
                                 {us/t1/t1filetransf.i &tipo='PUT' &programa=cSalidaPara &salida=oplCopiaOK &nombre=cArchLog1}
                              end.
                              
                              /* Error en carga CIM. Revise Archivo log # */
                              {us/bbi/pxmsg.i &MSGNUM=44152 &ERRORLEVEL=4 &MSGARG1=cArchLog1}
                              
                              if oplCopiaOK then do:
                                 /* Archivo de LOG copiado a # */
                                 {us/bbi/pxmsg.i &MSGNUM=44104 &ERRORLEVEL=4 &MSGARG1=cRutaUser}
                              end.
                              else do:
                                 /* Error copiando archivo a ubicacion definitiva */
                                 {us/bbi/pxmsg.i &MSGNUM=44102 ERRORLEVEL=1}
                              end.
                              
                              undo transaccion, leave transaccion.   
                           end.
                           else do:
                              if can-find(first code_mstr where code_domain  = global_domain
                                                          and   code_fldname = "s1actcstpmp.p"
                                                          and   code_value   = "NO_BORRAR_" + global_userid
                                                          and   code_cmmt    = "YES")
                              then .
                              else do:
                                 {us/bbi/gpfildel.i &filename=cFullArchCim1}
                                 {us/bbi/gpfildel.i &filename=cFullArchLog1}
                              end.
                           end.
                        end.   /* loop-cim1 */
                        
                        run actualizarCostoFilialOrigen(output hay_error).
                        if hay_error then do:
                           undo transaccion, leave transaccion.
                        end.
                        
                     end. /* do transaction */
                     
                     if hay_error then do:
                        /* Proceso abortado */
                        {us/bbi/pxmsg.i &MSGNUM=44237 &ERRORLEVEL=1}
                     end.
                     else do:
                        /* Modificacion finalizada */
                        {us/bbi/pxmsg.i &MSGNUM=44245 &ERRORLEVEL=1}
                     end.
                  end. /* when */
               end. /* case */
            
            end. /* loopa */
            
            if not hay_error then do:
               /* Proceso finalizado. Registrados # */
               {us/bbi/pxmsg.i &MSGNUM=44234 &ERRORLEVEL=1 &MSGARG1=string(iCont)}
            end.
         end. /* mainloop */
         
         
         /* ******************************************************************* */
         /* ******************************************************************* */
         /*CM03*//* Actualizar costo en filial origen */
         procedure actualizarCostoFilialOrigen:
            define output parameter oplError       as logical.
            
            
            define variable cSim       as character   no-undo.
            define variable lEntra     as logical     no-undo.
            
            assign
               oplError = false
               lEntra   = false
               cSim     = trim(cTipoCosto) + trim(cGrupoCosto) + substring(string(anio),3,2) + string(per,"99"). 
            
            output stream st2 to value(cFullArchCim2).
            
            put stream st2 unformatted
               " - " skip.
            
            for each s1_cstpc_det no-lock
               where s1_cstpc_domain    = global_domain
               and   s1_cstpc_filial    = filial
               and   s1_cstpc_anio      = anio
               and   s1_cstpc_mes       = iPerHasta
               and   s1_cstpc_grupo     = cGrupo
               and   s1_cstpc_canal     = ""
               and   s1_cstpc_Producto >= part
               and   s1_cstpc_Producto <= part1
               :
               /* preasigno si no llego a encontrar relación en s1_ptvp */
               assign
                  cProdDestino  = s1_cstpc_producto
                  cGrupoDestino = "R".
               
               deCstMatygastos = 0.
               
               find first sct_det no-lock
                  where sct_domain = global_domain
                  and   sct_site   = cFilialDestino
                  and   sct_sim    = cSim
                  and   sct_part   = cProdDestino no-error.
               
               assign deCstMatygastos = sct_cst_tot.
               assign deCstMatygastos = truncate(deCstMatygastos,5).
               
               put stream st2 unformatted
                  anio ' ' 
                  per  ' '
                  '"' cProdDestino  '" '
                  skip
                  '"' filial '" '
                  skip
                  '"' cTipoCosto '" '
                  '"' cGrupoCosto '" '
                  skip
                  '"' cElem2 '" '
                  deCstMatygastos 
                  skip
                  '" " '
                  skip
                  . 
               
               lEntra = true.
            end.
            
            put stream st2 unformatted
               "." skip.
            
            output stream st2 close.
            
            /* CIM  CARGA COSTO A ELEMENTO */
            
            if lEntra then do /*transaction on error undo loop-cim2, leave loop-cim2*/:
               batchrun = yes.
               input from value(cFullArchCim2).
               output to value(cFullArchLog2).
               {us/bbi/gprun.i ""s1csbtld.p""}.
               output close.
               input close.
               batchrun = no.
               
               /* Rutina validacion de cim */
               hay_error = false.
               input from value(cFullArchLog2).
               
               bus_log:
               repeat:
                  import unformatted v_error.
                  if v_error begins "**" or v_error begins "ERRO" then do:
                     hay_error = true.
                     leave bus_log.
                  end.
               end.  /* repeat */
               
               input close.
               
               if hay_error then do:
                  {us/t1/t1filetransf.i &tipo='PUT' &programa=cSalidaPara &salida=oplCopiaOK &nombre=cArchCim2}
                  if oplCopiaOK then do:
                     {us/t1/t1filetransf.i &tipo='PUT' &programa=cSalidaPara &salida=oplCopiaOK &nombre=cArchLog2}
                  end.
                  
                  /* Error en carga CIM. Revise Archivo log # */
                  {us/bbi/pxmsg.i &MSGNUM=44152 &ERRORLEVEL=4 &MSGARG1=cArchLog2}
                  
                  if oplCopiaOK then do:
                     /* Archivo de LOG copiado a # */
                     {us/bbi/pxmsg.i &MSGNUM=44104 &ERRORLEVEL=4 &MSGARG1=cRutaUser}
                  end.
                  else do:
                     /* Error copiando archivo a ubicacion definitiva */
                     {us/bbi/pxmsg.i &MSGNUM=44102 ERRORLEVEL=1}
                  end.
                  
                  oplError = true.
                  /* undo transaccion, leave transaccion.    */
               end.
            end.
            
            if can-find(first code_mstr where code_domain  = global_domain
                                        and   code_fldname = "s1actcstpmp.p"
                                        and   code_value   = "NO_BORRAR_" + global_userid
                                        and   code_cmmt    = "YES")
            then .
            else do:
               {us/bbi/gpfildel.i &filename=cFullArchCim2}
               {us/bbi/gpfildel.i &filename=cFullArchLog2}
            end.
         end procedure.
/*CM03*//* FIN Actualizar costo en filial origen */


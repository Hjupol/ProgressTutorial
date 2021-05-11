/*                                                  
 * Fecha: 25/07/2005                                
 * Nombre Programa: s1abmptd.p                      
 * Descripcion: Datos Especificos de cada filial.
 * IBC ARGENTINA                                    
 * Andres Alleva                                    
 */
/* REVISION: 9.1      LAST MODIFIED: 06/08/06   BY: *MCT2* M.Costigliolo   */
/* REVISION: 9.1      LAST MODIFIED: 06/26/06   BY: *MCT4* M.Cosigliolo   */
/* REVISION: 9.1      LAST MODIFIED: 09/15/06   BY: *MCS1* M.Cosigliolo   */
/* REVISION: 9.1      LAST MODIFIED: 01/19/07   BY: *JDC1* Julio Cerviño  */
/* REVISION: 9.1      LAST MODIFIED: 10/12/07   BY: *MCS2* M.Cosigliolo   */
/* REVISION: eB       MODIFIED DATE: 10/19/07   BY: *JC05* Julio Cerviño  */
/* REVISION: eB       MODIFIED DATE: 04/22/10   BY: *CM00* Carlos Moreno - Agregar nuevas lineas */
/* REVISION: eB       MODIFIED DATE: 07/16/12   BY: *CM01* Carlos Moreno - Avisar cuando no existe s1_ptsig_mstr */
/* REVISION: eB       MODIFIED DATE: 11/06/14   BY: *CM02* Carlos Moreno - Actualizar líneas en base a excel */
/* ************************************************************************ */
/* REV: 2013SE        DATE: 07-OCT-2020    BY: Diego Fernandez *DF00* Migracion a EE */

         {us/mf/mfdtitle.i " "}
         {us/px/pxmaint.i}
         {us/bbi/gplabel.i}
         
         define variable passwd           like  s1_user_passwd                            no-undo.
         define variable filial           as character                  format "x(8)"     no-undo.
         define variable per              as integer                    format "99"       no-undo.
         define variable anio             as integer                    format "9999"     no-undo.
         define variable usuario          like s1_user_id                                 no-undo.
         define variable dFilial          as character                  format "x(40)"    no-undo.
         define variable moneda           as character                  format "x(3)"     no-undo.
         define variable del-yn           like mfc_logical              initial NO        no-undo.
         define variable ans              like mfc_logical              initial NO        no-undo.
         define variable clave_lpro       as character                                    no-undo.
         define variable clave_lmar       as character                                    no-undo.
         define variable clave_lproNue    as character                                    no-undo.
         define variable clave_lmarNue    as character                                    no-undo.
         define variable clave_lpropia    as character                                    no-undo.
         define variable lineaPro         like code_cmmt                                  no-undo.
         define variable lineaMar         like code_cmmt                                  no-undo.
         define variable lineaProNue      like code_cmmt                                  no-undo.
         define variable lineaMarNue      like code_cmmt                                  no-undo.
         define variable lineaPropia      like code_cmmt                                  no-undo.
         define variable desc1            as character                  format "x(40)"    no-undo. 
         
         define new shared variable s1_execname as character no-undo.
         
         define variable recid_ptsig as recid .
         
         /* {s1logsig.i "true"} * se quita en migracion EE */
         /* se agrega en migracion EE */
         assign
            filial  = global_domain
            anio    = year(today)
            per     = month(today)
            usuario = global_userid
            moneda  = base_curr
            dFilial = global_domain.
         
         for first Domains no-lock where Domains.DomainCode = global_domain
            ,first DomainProperty no-lock where DomainProperty.Domain_ID = Domains.Domain_ID
            ,first Currency no-lock where Currency.Currency_ID = DomainProperty.Currency_ID
            :
            assign
               moneda  = Currency.CurrencyCode
               dFilial = DomainProperty.DomainPropertyName.
         end.
         /* se agrega en migracion EE */
         
         session:data-entry-return = true.
         
         form                                                                         
            s1_ptsig_part              colon 10    label "Producto"
            s1_ptsig_desc                       no-label                            format "x(45)"
            skip(1)
            s1_ptsigf_linea_pro        colon 22    label "Linea Promocion"
            lineaPro                   at 30    no-label                            format "x(43)"
            s1_ptsigf_linea_mar        colon 22    label "Linea Marketing"
            lineaMar                   at 30    no-LABEL                            format "x(43)"
            s1_ptsigf_linea_pro_nue    colon 22    label "Linea Promocion Nueva"
            lineaProNue                at 30    no-label                            format "x(43)"
            s1_ptsigf_linea_mar_nue    colon 22    label "Linea Marketing Nueva"
            lineaMarNue                at 30    no-label                            format "x(43)"
            s1_ptsigf_linea_propia     colon 22    label "Linea Propia"             
            lineaPropia                at 30    no-label                            format "x(43)"
            s1_ptsigf_chr01[1]         colon 22    label "Prorrateo"                format "x(2)" 
            desc1                      at 30    no-label                            format "x(43)"                             
         with frame a side-labels width 80 attr-space.
         setFrameLabels(frame a:handle).
         
/* se quita en migracion EE 
*        find first s1_filial no-lock
*           where s1_filial_domain = global_domain
*           and   s1_filial_filial = filial no-error.
*        if available s1_filial then do:
*           assign
*              moneda  = s1_filial_moneda                                  
*              dFilial = s1_filial_descripcion.                        
*        end.
*/
         
         assign
            s1_execname   = filial
            clave_lpro    = "salnp_mstr%"  + filial
            clave_lmar    = "salnt_mstr%"  + filial
            clave_lproNue = "salnpn_mstr%" + filial
            clave_lmarNue = "salntn_mstr%" + filial
            clave_lpropia = "salnpp_mstr%" + filial
            .
         
         mainloop:                
         repeat:
            
            prompt-for 
               s1_ptsig_part 
            with frame a editing:
               
               /* FIND NEXT/PREVIOUS RECORD */
               /* {mfnp05.i cp_mstr cp_cust "cp_cust = filial" cp_part "input s1_ptsig_part" } se quita en migracion, no se usa mas en el programa */
               {us/mf/mfnp05.i 
                  s1_ptsig_mstr 
                  s1_ptsig_index 
                  " s1_ptsig_domain = global_domain "
                  s1_ptsig_part 
                  "input s1_ptsig_part"}
               
               if recno <> ? then do:
                  display
                    s1_ptsig_part 
                    s1_ptsig_desc
                  with frame a.
                  
                  find first s1_ptsigf_det no-lock
                     where s1_ptsigf_domain = global_domain
                     and   s1_ptsigf_filial = filial 
                     and   s1_ptsigf_part   = input s1_ptsig_part no-error.
                  if available s1_ptsigf_det then do:
                     lineaPro = "".
                     for first code_mstr fields(code_cmmt)
                        where code_domain  = global_domain
                        and   code_fldname = clave_lpro
                        and   code_value   = s1_ptsigf_linea_pro
                     no-lock:
                        lineaPro = code_cmmt.
                     end.
                     
                     lineaMar = "".
                     for first code_mstr fields(code_cmmt)
                        where code_domain  = global_domain
                        and   code_fldname = clave_lmar
                        and   code_value   = s1_ptsigf_linea_mar
                     no-lock:
                        lineaMar = code_cmmt.
                     end.
                     
                     lineaProNue = "".
                     for first code_mstr fields(code_cmmt)
                        where code_domain  = global_domain
                        and   code_fldname = clave_lproNue
                        and   code_value   = s1_ptsigf_linea_pro_nue
                     no-lock:
                        lineaProNue = code_cmmt.
                     end.
                     
                     lineaMarNue = "".
                     for first code_mstr fields(code_cmmt)
                        where code_domain  = global_domain
                        and   code_fldname = clave_lmarNue
                        and   code_value   = s1_ptsigf_linea_mar_nue
                     no-lock:
                        lineaMarNue = code_cmmt.
                     end.
                     
                     lineaPropia = "".
                     for first code_mstr fields(code_cmmt)
                        where code_domain  = global_domain
                        and   code_fldname = clave_lpropia
                        and   code_value   = s1_ptsigf_linea_propia
                     no-lock:
                        lineaPropia = code_cmmt.
                     end.
                     
                     desc1 = "".
                     for first s1_pro_mstr fields(s1_pro_desc)
                        where s1_pro_domain = global_domain
                        and   s1_pro_codigo = s1_ptsigf_chr01[1] 
                     no-lock:
                        desc1 = s1_pro_desc.
                     end.
                     
                     display
                        s1_ptsigf_linea_pro
                        s1_ptsigf_linea_mar
                        s1_ptsigf_linea_pro_nue
                        s1_ptsigf_linea_mar_nue
                        s1_ptsigf_linea_propia
                        s1_ptsigf_chr01[1]
                        lineapro  
                        lineamar
                        lineaproNue  
                        lineamarNue
                        lineapropia  
                        desc1
                     with frame a.
                  end.
                  else do:
                     display
                        "" @ s1_ptsigf_linea_pro
                        "" @ s1_ptsigf_linea_mar
                        "" @ s1_ptsigf_linea_pro_nue
                        "" @ s1_ptsigf_linea_mar_nue
                        "" @ s1_ptsigf_linea_propia
                        "" @ s1_ptsigf_chr01[1]
                        "" @ lineapro
                        "" @ lineamar
                        "" @ lineaproNue
                        "" @ lineamarNue
                        "" @ lineapropia
                        "" @ desc1
                     with frame a.                
                  end.
               end.
            end. /* editing */
            
            display
               "" @ s1_ptsig_desc
               "" @ s1_ptsigf_linea_pro
               "" @ s1_ptsigf_linea_mar
               "" @ s1_ptsigf_linea_pro_nue
               "" @ s1_ptsigf_linea_mar_nue
               "" @ s1_ptsigf_linea_propia
               "" @ s1_ptsigf_chr01[1]
               "" @ lineapro
               "" @ lineamar
               "" @ lineaproNue
               "" @ lineamarNue
               "" @ lineapropia
               "" @ desc1
            with frame a.
            
            /* ADD/MOD/DELETE  */
            find first s1_ptsig_mstr no-lock
               where s1_ptsig_domain = global_domain
               and   s1_ptsig_part   = input s1_ptsig_part no-error.
            if not available s1_ptsig_mstr then do:
               {us/bbi/pxmsg.i &MSGNUM=44115 &ERRORLEVEL=3} /* No existe el Producto en s1_ptsig_mstr */
               undo, retry.
            end.
            
            display
               s1_ptsig_part 
               s1_ptsig_desc
            with frame a.
            
            recid_ptsig = recid(s1_ptsig_mstr) .
            
            find first s1_ptsigf_det exclusive-lock
               where s1_ptsigf_domain = global_domain
               and   s1_ptsigf_filial = filial 
               and   s1_ptsigf_part   = input s1_ptsig_part no-error.
            if not available s1_ptsigf_det then do:
               {us/bbi/mfmsg.i 1 1}
               create s1_ptsigf_det.
               assign
                  s1_ptsigf_domain = global_domain
                  s1_ptsigf_filial = filial
                  s1_ptsigf_part   = input s1_ptsig_part.
            end.
            else do:
               {us/bbi/mfmsg.i 8221 1}.
            end.
            
            lineaPro = "".
            for first code_mstr fields(code_cmmt)
               where code_domain  = global_domain
               and   code_fldname = clave_lpro
               and   code_value   = s1_ptsigf_linea_pro
            no-lock:
               lineaPro = code_cmmt.
            end.
            
            lineaMar = "".
            for first code_mstr fields(code_cmmt)
               where code_domain  = global_domain
               and   code_fldname = clave_lmar
               and   code_value   = s1_ptsigf_linea_mar
            no-lock:
               lineaMar = code_cmmt.
            end.
            
            lineaProNue = "".
            for first code_mstr fields(code_cmmt)
               where code_domain  = global_domain
               and   code_fldname = clave_lproNue
               and   code_value   = s1_ptsigf_linea_pro_nue
            no-lock:
               lineaProNue = code_cmmt.
            end.
            
            lineaMarNue = "".
            for first code_mstr fields(code_cmmt)
               where code_domain  = global_domain
               and   code_fldname = clave_lmarNue
               and   code_value   = s1_ptsigf_linea_mar_nue
            no-lock:
               lineaMarNue = code_cmmt.
            end.
            
            lineaPropia = "".
            for first code_mstr fields(code_cmmt)
               where code_domain  = global_domain
               and   code_fldname = clave_lpropia
               and   code_value   = s1_ptsigf_linea_propia
            no-lock:
               lineaPropia = code_cmmt.
            end.
            
            desc1 = "".
            for first s1_pro_mstr fields(s1_pro_desc)
               where s1_pro_domain = global_domain
               and   s1_pro_codigo = s1_ptsigf_chr01[1]
            no-lock:
               desc1 = s1_pro_desc.
            end.
            
            display
               s1_ptsigf_linea_pro
               s1_ptsigf_linea_mar
               s1_ptsigf_linea_pro_nue
               s1_ptsigf_linea_mar_nue
               s1_ptsigf_linea_propia
               s1_ptsigf_chr01[1]
               lineapro
               lineamar
               lineaproNue  
               lineamarNue
               lineapropia  
               desc1
            with frame a.
            
            
            loopb:
            do on error undo, retry:
               
               ststatus = stline[2].
               status input ststatus.
               
               prompt-for
                  s1_ptsigf_linea_pro 
                  s1_ptsigf_linea_mar
                  s1_ptsigf_linea_pro_nue
                  s1_ptsigf_linea_mar_nue
                  s1_ptsigf_linea_propia
                  s1_ptsigf_chr01[1]
               go-on(F5 CTRL-D) with frame a.
               
               /* DELETE */
               if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
                  del-yn = false.
                  {us/bbi/pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                  if del-yn = false then undo loopb, retry.
                  
                  delete s1_ptsigf_det.
                  
                  display
                     "" @ s1_ptsigf_linea_pro
                     "" @ s1_ptsigf_linea_mar
                     "" @ s1_ptsigf_linea_pro_nue
                     "" @ s1_ptsigf_linea_mar_nue
                     "" @ s1_ptsigf_linea_propia
                     "" @ s1_ptsigf_chr01[1]
                     "" @ lineaPro
                     "" @ lineaMar
                     "" @ lineaProNue
                     "" @ lineaMarNue
                     "" @ lineaPropia
                     "" @ desc1
                  with frame a.
                  
                  next mainloop.
               end.
               
               assign
                  lineaPro    = ""
                  lineaMar    = ""
                  lineaProNue = ""
                  lineaMarNue = ""
                  lineaPropia = ""
                  desc1       = ""
                  .
                  
               find first code_mstr no-lock
                  where code_domain  = global_domain
                  and   code_fldname = clave_lpro
                  and   code_value   = input s1_ptsigf_linea_pro no-error.
               if not available code_mstr then do:
                  {us/bbi/pxmsg.i &MSGNUM=44134 &ERRORLEVEL=3} /* No existe linea de promocion */
                  next-prompt s1_ptsigf_linea_pro with frame a.
                  undo loopb, retry.
               end.
               lineaPro = code_cmmt.
               display lineaPro with frame a.
               
               find first code_mstr no-lock
                  where code_domain  = global_domain
                  and   code_fldname = clave_lmar
                  and   code_value   = input s1_ptsigf_linea_mar no-error.
               if not available code_mstr then do:
                  {us/bbi/pxmsg.i &MSGNUM=44135 &ERRORLEVEL=3} /* No existe linea de marketing */
                  next-prompt s1_ptsigf_linea_mar with frame a.
                  display lineaMar with frame a.
                  undo loopb, retry.
               end.
               lineaMar = code_cmmt.
               display lineaMar with frame a.
               
               find first code_mstr no-lock
                  where code_domain  = global_domain
                  and   code_fldname = clave_lproNue
                  and   code_value   = input s1_ptsigf_linea_pro_nue no-error.
               if not available code_mstr then do:
                  {us/bbi/pxmsg.i &MSGNUM=44136 &ERRORLEVEL=3} /* No existe linea de promocion nueva */
                  next-prompt s1_ptsigf_linea_pro_nue with frame a.
                  display lineaProNue with frame a.
                  undo loopb, retry.
               end.
               lineaProNue = code_cmmt.
               display lineaProNue with frame a.
               
               find first code_mstr no-lock
                  where code_domain  = global_domain
                  and   code_fldname = clave_lmarNue
                  and   code_value   = input s1_ptsigf_linea_mar_nue no-error.
               if not available code_mstr then do:
                  {us/bbi/pxmsg.i &MSGNUM=44137 &ERRORLEVEL=3} /* No existe linea de Marketing nueva */
                  next-prompt s1_ptsigf_linea_mar_nue with frame a.
                  display lineaMarNue with frame a.
                  undo loopb, retry.
               end.
               lineaMarNue = code_cmmt.
               display lineaMarNue with frame a.
               
               find first code_mstr no-lock
                  where code_domain  = global_domain
                  and   code_fldname = clave_lpropia
                  and   code_value   = input s1_ptsigf_linea_propia no-error.
               if not available code_mstr then do:
                  {us/bbi/pxmsg.i &MSGNUM=44138 &ERRORLEVEL=3} /* No existe linea propia */
                  next-prompt s1_ptsigf_linea_propia with frame a.
                  display lineaPropia with frame a.
                  undo loopb, retry.
               end.
               lineaPropia = code_cmmt.
               display lineaPropia with frame a.
               
               find first s1_pro_mstr no-lock
                  where s1_pro_domain = global_domain
                  and   s1_pro_codigo = input s1_ptsigf_chr01[1] no-error.
               if not available s1_pro_mstr then do:
                  {us/bbi/pxmsg.i &MSGNUM=44139 &ERRORLEVEL=3} /* No existe Prorrateo */
                  next-prompt s1_ptsigf_chr01[1] with frame a.
                  display desc1 with frame a.
                  undo loopb, retry.
               end.
               desc1 = s1_pro_desc.
               display desc1 with frame a.
               
               assign
                  s1_ptsigf_linea_pro 
                  s1_ptsigf_linea_mar
                  s1_ptsigf_linea_pro_nue
                  s1_ptsigf_linea_mar_nue
                  s1_ptsigf_linea_propia
                  s1_ptsigf_chr01[1].
               
               assign
                  s1_ptsigf_usuario    = usuario
                  s1_ptsigf_fecha_alta = today.
               
               /* ASK TO CONTINUE */
               ans = true.                         
               {us/bbi/pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=ans}
               if ans = false then do:
                  undo loopb, retry.
               end.
               
               {us/bbi/gprun.i ""s1sincpt.p"" "(recid_ptsig,no,yes,no,global_domain)" }
            
            end. /* loopb */
            
         end. /* mainloop */
         
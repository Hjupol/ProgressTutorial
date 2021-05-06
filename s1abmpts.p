/*                                   
 * Fecha: 25/07/2005                 
 * Nombre Programa: s1abmpts.p      
 * Descripcion: Genera ABM productos (s1_ptsig_mstr)
 * IBC ARGENTINA                     
 * Andres Alleva                    
 */
/* REVISION: 9.1      LAST MODIFIED: 06/08/06   BY: *MCT2* M.Costigliolo  */
/* REVISION: 9.1      LAST MODIFIED: 06/26/06   BY: *MCT4* M.Cosigliolo   */
/* REVISION: 9.1      LAST MODIFIED: 07/12/06   BY: *MCT8* M.Cosigliolo   */
/* REVISION: 9.1      LAST MODIFIED: 08/07/06   BY: *MCT9* M.Cosigliolo   */
/* REVISION: 9.1      LAST MODIFIED: 01/19/07   BY: *JDC1* Julio Cerviño  */
/* REVISION: eB       MODIFIED DATE: 10/19/07   BY: *JC05* Julio Cerviño  */
/* REVISION: 9.1      LAST MODIFIED: 03/27/08   BY: *MCS3* M.Cosigliolo   */
/* REVISION: 9.1      LAST MODIFIED: 06/11/10   BY: *CM00* Carlos Moreno  */
/* REVISION: 9.1      LAST MODIFIED: 06/28/10   BY: *CM01* Carlos Moreno  */ /* Heradar atributos */
/* REVISION: 9.1      LAST MODIFIED: 14/ene/11  BY: *ES35* E.Somoza       */ /*agregar campos*/
/* REVISION: 9.1      LAST MODIFIED: 06/30/11   BY: *CM05* Carlos Moreno */
/* REVISION: 9.1      LAST MODIFIED: 09/08/11   BY: *CM06* Carlos Moreno  - Anular Herencia */
/* REVISION: 9.1      LAST MODIFIED: 11/16/11   BY: *CM07* Carlos Moreno  - Ampliar descripcion con s1_ptsig_chr01[4] */
/* REVISION: 9.1      LAST MODIFIED: 03/17/15   BY: *CM08* Carlos Moreno  - MOT con s1_ptsig_dec01[2] */
/* REVISION: 9.1      LAST MODIFIED: 02/10/16   BY: *CM09* Carlos Moreno  - 3ra concentracion */
/* REVISION: 9.1      LAST MODIFIED: jun/06/20  BY: *CM10* Carlos Moreno  - Tkt_370959 - validacion y autocompletado desde 80.1.31 */
/* **************************************************************************************** */
/* REV: EE            DATE: 01-OCT-2020         BY: *DF01* Diego Fernandez - Migracion a EE */
/* REV: EE            DATE: 05-FEB-2021         BY: *CM11* Carlos Moreno   - Migracion a EE */
      
      {us/mf/mfdtitle.i "b+ "}
      {us/px/pxmaint.i}
      {us/bbi/gplabel.i}
      
      define variable passwd                    like s1_user_passwd                                         no-undo.
      define variable filial                    as character         format "x(8)"                          no-undo.
      define variable per                       as integer           format "99"                            no-undo.
      define variable anio                      as integer           format "9999"                          no-undo.
      define variable usuario                   like s1_user_id                                             no-undo.
      define variable dFilial                   as character         format "x(40)"                         no-undo.
      define variable moneda                    as character         format "x(3)"                          no-undo.
      define variable del-yn                    like mfc_logical     initial no                             no-undo.
      define variable ans                       like mfc_logical     initial no                             no-undo.
      define variable clave_marca               as character                                                no-undo.
      define variable clave_supermarca          as character                                                no-undo.
      define variable clave_tipo                as character                                                no-undo.
      define variable clave_droga               as character                                                no-undo.
      define variable clave_forma               as character                                                no-undo.
      define variable clave_envase              as character                                                no-undo.
      define variable clave_especialidad        as character                                                no-undo.
      define variable clave_lcnue               as character                                                no-undo.
      define variable clave_lcvie               as character                                                no-undo.
      define variable DESC_linea_corp_vie       like code_cmmt                                              no-undo.
      define variable DESC_linea_corp_nue       like code_cmmt                                              no-undo.
      define variable DESC_especial             like code_cmmt                                              no-undo.
      define variable DESC_marca                like code_cmmt                                              no-undo.
      define variable DESC_supermarca           like code_cmmt                                              no-undo.
      define variable DESC_tipo                 like code_cmmt                                              no-undo.
      define variable DESC_droga                like code_cmmt                                              no-undo.
      define variable DESC_forma                like code_cmmt                                              no-undo.
      define variable DESC_envase               like code_cmmt                                              no-undo.
      define variable SUPERMARCA                like code_user1                                             no-undo.
      define variable linea_ppal                like code_user1                                             no-undo.
      define variable s1ptsigpart               as character                                                no-undo.
      
      define new shared variable s1_execname    as character                                                no-undo.
      
      define variable validar_campos            as logical                                                  no-undo.
      define variable recid_ptsig               as recid.
      
      define variable desc2                     as character                                                no-undo.
      define variable yn                        like mfc_logical.
      
      define temp-table ttFiliales
         field ttFiliales_filial as character
         field ttFiliales_domain as character.
      
      /* {us/s1/s1logsig.i "false"} */ /* se quita en migracion EE */
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
         s1_ptsig_part                    colon 20       label "Producto"
         s1_ptsig_desc                    colon 20       label "Descripcion SIG" 
                                                         view-as fill-in size 45 by 1
                                                         format "x(70)"
         s1_ptsig_tipo                    colon 20       label "Tipo Producto"
         DESC_tipo                        colon 35    no-label
         s1_ptsig_cant_con                colon 20       label "Cant.Concentracion"
         s1_ptsig_uni_con                             no-label 
         s1_ptsig_cant_con_ref            colon 20       label "Cant.Conc.Referenc"
         s1_ptsig_uni_con_ref                         no-label
         s1_ptsig_cant_con3               colon 20       label "Cant.Concentrac 3"
                                                         format "->>>,>>>,>>9.99"
         s1_ptsig_uni_con3                            no-labels 
                                                         format "x(3)"
         s1_ptsig_linea_corp_vie          colon 12       label "Ln Clasica"
         DESC_linea_corp_vie                          no-label
         s1_ptsig_linea_corp_nue          colon 12       label "Ln Corporat"
         DESC_linea_corp_nue                          no-label
         linea_ppal                                   no-label
         s1_ptsig_especial                colon 12       label "Especialid"
         DESC_especial                                no-label
         s1_ptsig_marca                   colon 12       label "Marca"
         DESC_marca                                   no-label
         SUPERMARCA                       colon 12       label "Familia"
         DESC_supermarca                              no-label
         s1_ptsig_droga                   colon 12       label "Droga"
         DESC_droga                                   no-label
         s1_ptsig_forma                   colon 12       label "Forma"
         DESC_forma                                   no-label                      format "x(35)"
         s1_ptsig_cant_forma              colon 60       label "Cant"
         s1_ptsig_envase                  colon 12       label "Envase"
         DESC_envase                                  no-label                      format "x(35)"
         s1_ptsig_cant_env                colon 60       label "Cant"
         s1_ptsig_dec01[1]                colon 12       label "Pack"
         s1_ptsig_gerente_prod            colon 12       label "Gte.Product"
         s1_ptsig_abc                     colon 68       label "ABC"
         desc2                            colon 12       label "Descrip QAD" 
                                                         format "x(50)"
         s1_ptsig_dec01[2]                colon 68       label "MOT" 
                                                         format '>9.9' 
         s1_ptsig_drogaxforma             colon 12       label "Drog x Frma"
         s1_ptsig_chr01[4]                colon 68       label "Detalle"
      with frame a side-labels width 80 attr-space.
      setFrameLabels(frame a:handle).
      
      assign
         s1_execname = execname.
      
/* se quita en migracion EE *
*     find first s1_filial no-lock
*        where s1_filial_domain = global_domain
*        and   s1_filial_filial = filial no-error.
*     if available s1_filial then do:
*        assign
*           moneda  = s1_filial_moneda
*           dFilial = s1_filial_descripcion.
*     end.
* migracion EE */

      
      
      assign
         clave_marca         = "samr_mstr"
         clave_supermarca    = "sasm_mstr"
         clave_tipo          = "s1_tipo_producos"
         clave_droga         = "sadr_mstr"
         clave_forma         = "saff_mstr"
         clave_envase        = "saen_mstr"
         clave_especialidad  = "saes_mstr"
         clave_lcnue         = "salncn_mstr"
         clave_lcvie         = "salnc_mstr".
      
      
      mainloop:
      repeat for s1_ptsig_mstr:
         
         innerloop: 
         repeat on endkey undo, leave mainloop:
            
            prompt-for s1_ptsig_part with frame a editing:
               /* FIND NEXT/PREVIOUS RECORD */
               {us/mf/mfnp05.i
                  s1_ptsig_mstr
                  s1_ptsig_index 
                  "true "
                  s1_ptsig_part 
                  "input s1_ptsig_part"}
               
               if recno <> ? then do:
                  {us/s1/s1descPro.i}
                  
                  display
                     s1_ptsig_part
                     s1_ptsig_desc
                     s1_ptsig_cant_con
                     s1_ptsig_uni_con
                     s1_ptsig_cant_con_ref
                     s1_ptsig_uni_con_ref
                     s1_ptsig_cant_con3
                     s1_ptsig_uni_con3
                     s1_ptsig_linea_corp_vie
                     s1_ptsig_linea_corp_nue
                     s1_ptsig_chr01[1] @ linea_ppal
                     s1_ptsig_especial
                     s1_ptsig_marca
                     s1_ptsig_droga
                     s1_ptsig_forma
                     s1_ptsig_cant_forma
                     s1_ptsig_envase
                     s1_ptsig_cant_env
                     s1_ptsig_gerente_prod
                     s1_ptsig_dec01[1]
                     s1_ptsig_tipo
                     s1_ptsig_drogaxforma
                     s1_ptsig_abc
                     s1_ptsig_chr01[4]
                     s1_ptsig_dec01[2]
                  with frame a.
                  
                  find first pt_mstr no-lock
                     where pt_domain = global_domain
                     and   pt_part   = input s1_ptsig_part no-error.
                  if available pt_mstr then assign desc2 = pt_desc1 + pt_desc2.
                                       else assign desc2 = "".
                  display desc2 with frame a.
               end.
            end. /* editing */
            
            /* obtener lista de filiales SIG para replicarle los datos a sus dominios */
            for each ttFiliales: delete ttFiliales. end.
            for each Domains no-lock where DomainType <> "SYSTEM":
               create ttFiliales.
               assign
                  ttFiliales_filial = DomainCode
                  ttFiliales_domain = DomainCode.
               release ttFiliales.
            end. 
            
            /* ADD/MOD/DELETE */
            find first s1_ptsig_mstr exclusive-lock
               where s1_ptsig_part   = input s1_ptsig_part no-error.
            if not available s1_ptsig_mstr then do:
               /* BUSCO QUE EL PRODUCTO EXISTA EN LA PT_MSTR */
               find first pt_mstr no-lock
                  where pt_domain = global_domain
                  and   pt_part   = input s1_ptsig_part no-error.
               if not available pt_mstr then do:
                  {us/bbi/pxmsg.i &MSGNUM=44117 &ERRORLEVEL=4} /* Producto no parametrizado */
                  undo, retry.
               end.
               else do:
                  {us/bbi/mfmsg.i 1 1}
                  create s1_ptsig_mstr.
                  assign
                     s1_ptsig_part
                     s1_ptsig_desc   = pt_desc1 + pt_desc2
                     desc2           = pt_desc1 + pt_desc2
                     .
                  display desc2 with frame a.
               end.
            end.
            else do:
               {us/bbi/mfmsg.i 8221 1}.
            end.
            
            {us/s1/s1descPro.i}
            
            /* Siempre regrabar la descripcion armada cuando es Tipo "LI" (literatura) segun solicitud Diego Leguiza */
            if s1_ptsig_tipo = 'LI' then do:
               find first pt_mstr no-lock
                  where pt_domain = global_domain
                  and   pt_part   = input s1_ptsig_part no-error.
               if available pt_mstr then assign s1_ptsig_desc = pt_desc1 + pt_desc2. 
                                    else assign s1_ptsig_desc = "".
            end.
            
            display
               s1_ptsig_part
               s1_ptsig_desc
               s1_ptsig_cant_con
               s1_ptsig_uni_con
               s1_ptsig_cant_con_ref
               s1_ptsig_uni_con_ref
               s1_ptsig_cant_con3
               s1_ptsig_uni_con3
               s1_ptsig_linea_corp_vie
               s1_ptsig_linea_corp_nue
               s1_ptsig_chr01[1] @ linea_ppal
               s1_ptsig_especial
               s1_ptsig_marca
               s1_ptsig_droga
               s1_ptsig_forma
               s1_ptsig_cant_forma
               s1_ptsig_envase
               s1_ptsig_cant_env
               s1_ptsig_gerente_prod
               s1_ptsig_dec01[1]
               s1_ptsig_tipo
               s1_ptsig_drogaxforma
               s1_ptsig_abc
               s1_ptsig_chr01[4]
               s1_ptsig_dec01[2]
            with frame a.
            
            
            
            loopb:
            do on error undo, retry:
            
               ststatus = stline[2].
               status input ststatus.
               
               set
                  s1_ptsig_tipo
                  s1_ptsig_cant_con
                  s1_ptsig_uni_con
                  s1_ptsig_cant_con_ref
                  s1_ptsig_uni_con_ref
                  s1_ptsig_cant_con3
                  s1_ptsig_uni_con3
                  s1_ptsig_marca
                  s1_ptsig_droga
                  s1_ptsig_forma
                  s1_ptsig_cant_forma
                  s1_ptsig_envase
                  s1_ptsig_cant_env
                  s1_ptsig_dec01[1]
                  s1_ptsig_drogaxforma
                  s1_ptsig_abc
                  s1_ptsig_chr01[4]
                  s1_ptsig_dec01[2]
               go-on(F5 CTRL-D) with frame a.
               
               
               /* DELETE */
               if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:                                                           
                  del-yn = YES.
                  {us/mf/mfmsg01.i 11 1 del-yn}
                  if del-yn = NO then next mainloop.
                  
                  for each ttFiliales:
                     if can-find(s1_ptsigf_det where s1_ptsigf_domain = ttFiliales_domain and s1_ptsigf_part = input s1_ptsig_part) then do:
                        /* Existen filiales parametrizadas para este producto (filial #) */ 
                        {us/bbi/pxmsg.i &MSGNUM=44161 &ERRORLEVEL=4 &MSGARG1=ttFiliales_filial}
                        undo loopb, retry.
                     end.
                  end.
                  
                  s1ptsigpart = input s1_ptsig_part.
                  delete s1_ptsig_mstr.
                  
                  for each ttFiliales where ttFiliales_domain <> global_domain:
                     find first s1_ptsig_mstr exclusive-lock
                        where s1_ptsig_part   = s1ptsigpart no-error.
                     if available s1_ptsig_mstr then delete s1_ptsig_mstr.
                  end.
                  
                  display
                     "" @ s1_ptsig_part
                     "" @ s1_ptsig_desc
                     "" @ s1_ptsig_cant_con
                     "" @ s1_ptsig_uni_con
                     "" @ s1_ptsig_cant_con_ref
                     "" @ s1_ptsig_uni_con_ref
                     "" @ s1_ptsig_cant_con3
                     "" @ s1_ptsig_uni_con3
                     "" @ s1_ptsig_linea_corp_vie
                     "" @ s1_ptsig_linea_corp_nue
                     "" @ s1_ptsig_especial
                     "" @ s1_ptsig_marca
                     "" @ s1_ptsig_droga
                     "" @ s1_ptsig_forma
                     "" @ s1_ptsig_cant_forma
                     "" @ s1_ptsig_envase
                     "" @ s1_ptsig_cant_env
                     "" @ s1_ptsig_gerente_prod
                     "" @ s1_ptsig_tipo
                     "" @ DESC_linea_corp_vie
                     "" @ DESC_linea_corp_nue
                     "" @ linea_ppal
                     "" @ DESC_especial
                     "" @ DESC_marca
                     "" @ DESC_droga
                     "" @ DESC_forma
                     "" @ DESC_envase
                     "" @ supermarca
                     "" @ DESC_supermarca
                     "" @ DESC_tipo
                     "" @ s1_ptsig_dec01[1]
                     "" @ desc2
                     "" @ s1_ptsig_drogaxforma
                     "" @ s1_ptsig_abc
                     "" @ s1_ptsig_chr01[4]
                     "" @ s1_ptsig_dec01[2]
                  with frame a.
                  
                  {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}    /* Registro borrado */
                  
                  leave innerloop.
               end. /* f5 */
               
               for first code_mstr fields(code_cmmt code_user1)
                  where code_domain  = global_domain
                  and   code_fldname = clave_tipo 
                  and   code_value   = s1_ptsig_tipo 
                  no-lock:
                  DESC_tipo = code_cmmt.
                  assign
                     validar_campos = if code_user1 begins "N" then false else true.
                  
                  display DESC_tipo with frame a.
               end.
               if not available code_mstr then do:
                  {us/bbi/pxmsg.i &MSGNUM=44118 &ERRORLEVEL=4} /* Tipo Producto no parametrizado */
                  next-prompt s1_ptsig_tipo with frame a.
                  undo, retry.
               end.
               
               for first code_mstr fields(code_cmmt code_user1)
                  where code_domain  = global_domain
                  and   code_fldname = clave_marca 
                  and   code_value   = s1_ptsig_marca
                  no-lock:
                  assign
                     DESC_marca = code_cmmt
                     supermarca = code_user1.
                  
                  display DESC_marca supermarca with frame a.
               end.
               if not available code_mstr and validar_campos then do:
                  {us/bbi/pxmsg.i &MSGNUM=44119 &ERRORLEVEL=4} /* Marca no parametrizada */
                  next-prompt s1_ptsig_marca with frame a.
                  undo, retry.
               end.
               else do:
                  s1_ptsig_supermarca = if validar_campos then code_user1 else "".
                  
                  if validar_campos then do:
                     for first code_mstr fields(code_cmmt)
                        where code_domain  = global_domain
                        and   code_fldname = clave_supermarca 
                        and   code_value   = s1_ptsig_supermarca
                        no-lock:
                        assign
                           DESC_supermarca = code_cmmt.
                        display DESC_supermarca with frame a.
                     end. 
                  end.
               end.
               
               for first code_mstr fields(code_cmmt)
                  where code_domain  = global_domain
                  and   code_fldname = clave_droga 
                  and   code_value   = s1_ptsig_droga
                  no-lock:
                  assign
                     DESC_droga = code_cmmt.
                  
                  display DESC_droga with frame a.
               end.
               if not available code_mstr and validar_campos then do:
                  {us/bbi/pxmsg.i &MSGNUM=44120 &ERRORLEVEL=4} /* Droga no parametrizado */
                  next-prompt s1_ptsig_droga with frame a.
                  undo, retry.
               end.
               
               for first code_mstr fields(code_cmmt)
                  where code_domain  = global_domain
                  and   code_fldname = clave_forma 
                  and   code_value   = s1_ptsig_forma
                  no-lock:
                  assign DESC_forma = code_cmmt.
                  
                  display DESC_forma with frame a.
               end.
               if not available code_mstr and validar_campos then do:
                  {us/bbi/pxmsg.i &MSGNUM=44121 &ERRORLEVEL=4} /* Forma no parametrizada */
                  next-prompt s1_ptsig_forma with frame a.
                  undo, retry.
               end.
               
               for first code_mstr fields(code_cmmt)
                  where code_domain  = global_domain
                  and   code_fldname = clave_envase 
                  and   code_value   = s1_ptsig_envase
                  no-lock:
                  assign DESC_envase = code_cmmt.
                  
                  display DESC_envase with frame a.
               end.
               if not available code_mstr and validar_campos then do:
                  {us/bbi/pxmsg.i &MSGNUM=44122 &ERRORLEVEL=4} /* Envase no parametrizado */
                  next-prompt s1_ptsig_envase with frame a.
                  undo, retry.
               end.
               
               find first s1_drogval_det exclusive-lock
                  where s1_drogval_droga  = s1_ptsig_droga
                  and   s1_drogval_forma  = s1_ptsig_forma
                  and   s1_drogval_envase = s1_ptsig_envase 
                  no-error. 
               if not available s1_drogval_det then do:
                  yn = true.
                  /* 44261 DCF no existe en punto 80.1.31, desea continuar? */
                  {us/bbi/pxmsg.i &MSGNUM=44261 &ERRORLEVEL=1 &CONFIRM=yn}
                  if yn = no then do:
                     undo, retry.
                  end.
               end.
               else do:
                  assign
                     s1_ptsig_linea_corp_vie = s1_drogval_linea_corp_vie
                     s1_ptsig_linea_corp_nue = s1_drogval_linea_corp_nue
                     s1_ptsig_especial       = s1_drogval_especial      
                     s1_ptsig_gerente_prod   = s1_drogval_gerente_prod.
                     
                     display 
                        s1_ptsig_linea_corp_vie
                        s1_ptsig_linea_corp_nue
                        s1_ptsig_especial
                        s1_ptsig_gerente_prod
                     with frame a.  
               end.
               
               if not available s1_drogval_det then do:
               
                  loop-c:
                  do on error undo, retry:
                     
                     ststatus = stline[1].
                     status input ststatus.
                  
                     set 
                        s1_ptsig_linea_corp_vie
                        s1_ptsig_linea_corp_nue
                        s1_ptsig_especial      
                        s1_ptsig_gerente_prod 
                     with frame a.
                     
                     /* Validaciones */
                     for first code_mstr fields(code_cmmt)
                        where code_domain  = global_domain
                        and   code_fldname = clave_lcvie 
                        and   code_value   = s1_ptsig_linea_corp_vie
                        no-lock:
                        assign DESC_linea_corp_vie = code_cmmt.
                        
                        display DESC_linea_corp_vie with frame a.
                     end.
                     if not available code_mstr and validar_campos then do:
                        {us/bbi/pxmsg.i &MSGNUM=44123 &ERRORLEVEL=4} /* Linea Clasica no parametrizada */
                        next-prompt s1_ptsig_linea_corp_vie with frame a.
                        undo, retry.
                     end.
                     
                     for first code_mstr fields(code_cmmt code_user1)
                        where code_domain  = global_domain
                        and   code_fldname = clave_lcnue 
                        and   code_value   = s1_ptsig_linea_corp_nue
                        no-lock:
                        assign 
                           DESC_linea_corp_nue = code_cmmt
                           linea_ppal          = code_user1.
                        
                        display 
                           DESC_linea_corp_nue 
                           linea_ppal 
                        with frame a. 
                     end.
                     if not available code_mstr and validar_campos then do:
                        {us/bbi/pxmsg.i &MSGNUM=44124 &ERRORLEVEL=4} /* Linea Corporativa no parametrizada */
                        next-prompt s1_ptsig_linea_corp_nue with frame a.
                        undo, retry.
                     end.
                     
                     for first code_mstr fields(code_cmmt)
                        where code_domain  = global_domain
                        and   code_fldname = clave_especialidad 
                        and   code_value   = s1_ptsig_especial
                        no-lock:
                        assign DESC_especial = code_cmmt.                                                                  
                        
                        display DESC_especial with frame a.                                                         
                     end.
                     if not available code_mstr and validar_campos then do:
                        {us/bbi/pxmsg.i &MSGNUM=44125 &ERRORLEVEL=4} /* Especialidad no parametrizada */
                        next-prompt s1_ptsig_especial with frame a.
                        undo, retry.
                     end.
                     
                  end. /* loop-c */
               end. /* if not available s1_drogval_det */
               
               if validar_campos then do:
                  
                  assign s1_ptsig_desc = trim(upper(DESC_marca)).
                  
                  if s1_ptsig_cant_con <> 0 then do:
                     
                     if s1_ptsig_cant_con - integer(s1_ptsig_cant_con) = 0 then assign s1_ptsig_desc = s1_ptsig_desc  + " " + (string(s1_ptsig_cant_con,">>>9")).
                                                                           else assign s1_ptsig_desc = s1_ptsig_desc  + " " + (string(s1_ptsig_cant_con,">>>9.9<")).
                     
                     assign s1_ptsig_desc = s1_ptsig_desc  + " " + trim(upper(s1_ptsig_uni_con)).
                     
                     if s1_ptsig_cant_con_ref <> 0 then do:
                        
                        if s1_ptsig_cant_con_ref - integer(s1_ptsig_cant_con_ref) = 0 then assign s1_ptsig_desc = s1_ptsig_desc  + " en " + (string(s1_ptsig_cant_con_ref,">>>9")).
                                                                                      else assign s1_ptsig_desc = s1_ptsig_desc  + " en " + (string(s1_ptsig_cant_con_ref,">>>9.9<")).        
                        
                        assign s1_ptsig_desc = s1_ptsig_desc  + " " + trim(upper(s1_ptsig_uni_con_ref)).
                        
                        if s1_ptsig_cant_con3 <> 0 then do:
                           if s1_ptsig_cant_con3 - integer(s1_ptsig_cant_con3) = 0 then assign s1_ptsig_desc = s1_ptsig_desc  + " en " + (string(s1_ptsig_cant_con3,">>>9")).
                                                                                   else assign s1_ptsig_desc = s1_ptsig_desc  + " en " + (string(s1_ptsig_cant_con3,">>>9.9<")).
                           
                           assign s1_ptsig_desc = s1_ptsig_desc  + " " + trim(upper(s1_ptsig_uni_con3)).
                        end.
                     end.
                  end.
                  
                  if s1_ptsig_cant_con <> 0 and s1_ptsig_cant_forma <> 0 then do:
                     assign s1_ptsig_desc = s1_ptsig_desc  + " x ".
                  end.
                  
                  if s1_ptsig_cant_forma <> 0 then do:
                     
                     if s1_ptsig_cant_forma - integer(s1_ptsig_cant_forma) = 0 then assign s1_ptsig_desc = s1_ptsig_desc  + "" + (string(s1_ptsig_cant_forma,">>>9")).
                                                                               else assign s1_ptsig_desc = s1_ptsig_desc  + "" + (string(s1_ptsig_cant_forma,">>>9.9<")).
                     
                     assign s1_ptsig_desc = s1_ptsig_desc  + " " + trim(upper(s1_ptsig_forma)).
                  end.
                  
                  if s1_ptsig_cant_forma <> 0 and s1_ptsig_cant_env <> 0 then do:
                     assign s1_ptsig_desc = s1_ptsig_desc  + " x ".
                  end.
                  
                  if s1_ptsig_cant_env <> 0 then do:
                     if s1_ptsig_cant_env - integer(s1_ptsig_cant_env) = 0 then assign s1_ptsig_desc = s1_ptsig_desc  + "" + (string(s1_ptsig_cant_env,">>9")).
                                                                           else assign s1_ptsig_desc = s1_ptsig_desc  + "" + (string(s1_ptsig_cant_env,">>9.9<")).
                     
                     assign s1_ptsig_desc = s1_ptsig_desc  + " " + trim(upper(s1_ptsig_env)).
                  end.
                  
                  if s1_ptsig_dec01[1] > 1 then do:
                     assign s1_ptsig_desc = s1_ptsig_desc  + " [x" + trim(string(integer(s1_ptsig_dec01[1]),">>9")) + "]".
                  end.
                  
                  if s1_ptsig_chr01[4] <> "" then do:
                     assign s1_ptsig_desc = s1_ptsig_desc  + " " + upper(trim(s1_ptsig_chr01[4])).
                  end.
               
               end.
               
               assign
                  s1_ptsig_chr01[1]   = linea_ppal
                  s1_ptsig_usuario    = usuario
                  s1_ptsig_fecha_alta = TODAY.
               
               recid_ptsig = recid(s1_ptsig_mstr) .
               
            end. /* loopb */
            
            
            
            /* ASK TO CONTINUE */             
            ans = YES.
            {us/mf/mfmsg01.i 12 1 ans}
            if not ans then do:
               display
                  "" @ s1_ptsig_part
                  "" @ s1_ptsig_desc
                  "" @ s1_ptsig_cant_con
                  "" @ s1_ptsig_uni_con
                  "" @ s1_ptsig_cant_con_ref
                  "" @ s1_ptsig_uni_con_ref
                  "" @ s1_ptsig_cant_con3
                  "" @ s1_ptsig_uni_con3
                  "" @ s1_ptsig_linea_corp_vie
                  "" @ s1_ptsig_linea_corp_nue
                  "" @ s1_ptsig_especial
                  "" @ s1_ptsig_marca
                  "" @ s1_ptsig_droga
                  "" @ s1_ptsig_forma
                  "" @ s1_ptsig_cant_forma
                  "" @ s1_ptsig_envase
                  "" @ s1_ptsig_cant_env
                  "" @ s1_ptsig_gerente_prod
                  "" @ s1_ptsig_tipo
                  "" @ DESC_linea_corp_vie
                  "" @ DESC_linea_corp_nue
                  "" @ linea_ppal
                  "" @ DESC_especial
                  "" @ DESC_marca
                  "" @ DESC_droga
                  "" @ DESC_forma
                  "" @ DESC_envase
                  "" @ supermarca
                  "" @ DESC_supermarca
                  "" @ DESC_tipo
                  "" @ s1_ptsig_dec01[1]
                  "" @ desc2
                  "" @ s1_ptsig_drogaxforma
                  "" @ s1_ptsig_abc        
                  "" @ s1_ptsig_chr01[4]
                  "" @ s1_ptsig_dec01[2]
               with frame a.
               
               undo mainloop, retry mainloop.
            end.
            
            
            /* BLANQUEA */
            display                        
               "" @ s1_ptsig_part          
               "" @ s1_ptsig_desc          
               "" @ s1_ptsig_cant_con      
               "" @ s1_ptsig_uni_con       
               "" @ s1_ptsig_cant_con_ref  
               "" @ s1_ptsig_uni_con_ref
               "" @ s1_ptsig_cant_con3
               "" @ s1_ptsig_uni_con3
               "" @ s1_ptsig_linea_corp_vie
               "" @ s1_ptsig_linea_corp_nue
               "" @ s1_ptsig_especial      
               "" @ s1_ptsig_marca         
               "" @ s1_ptsig_droga         
               "" @ s1_ptsig_forma      
               "" @ s1_ptsig_cant_forma      
               "" @ s1_ptsig_envase        
               "" @ s1_ptsig_cant_env     
               "" @ linea_ppal
               "" @ s1_ptsig_gerente_prod  
               "" @ s1_ptsig_tipo
               "" @ DESC_linea_corp_vie
               "" @ DESC_linea_corp_nue
               "" @ DESC_especial
               "" @ DESC_marca
               "" @ DESC_droga
               "" @ DESC_forma
               "" @ DESC_envase
               "" @ supermarca
               "" @ DESC_supermarca
               "" @ DESC_tipo
               "" @ s1_ptsig_dec01[1]
               "" @ desc2
               "" @ s1_ptsig_drogaxforma
               "" @ s1_ptsig_abc        
               "" @ s1_ptsig_chr01[4]
               "" @ s1_ptsig_dec01[2]
            with frame a.               
            
            {us/bbi/gprun.i ""s1sincpt.p"" "(recid_ptsig,yes,no,no,global_domain)" }
            
            /* replica el registro a los demas dominios */
            run replicarRegistros(input recid_ptsig).
            
            {us/bbi/pxmsg.i &MSGNUM=5494 &ERRORLEVEL=1} /* Registro actualizado */
            
         end. /* innerloop */
         
      end. /* mainloop */
      
/* ******************************************************************************* */
      procedure replicarRegistros:
         define input parameter recid_from     as recid.
         
         define variable recid_to      as recid       no-undo.
         
         define buffer bfrom for s1_ptsig_mstr.
         define buffer bto   for s1_ptsig_mstr.
         
         find first bfrom where recid(bfrom) = recid_from no-lock no-error.
         
         for each ttFiliales where ttFiliales_domain <> global_domain:
/*CM11*            
            find first bto exclusive-lock
               where bto.s1_ptsig_part   = bfrom.s1_ptsig_part no-error.
            if not available bto then do:
               create bto.
               assign
                  bto.s1_ptsig_part   = bfrom.s1_ptsig_part.
            end.
            
            buffer-copy bfrom except s1_ptsig_part to bto.
            
            recid_to = recid(bto).
            
            release bto.
*CM11*/            
/*CM11*/    recid_to = recid_from.            
            
            {us/bbi/gprun.i ""s1sincpt.p"" "(recid_to,yes,no,no,ttFiliales_domain)" }
         end. /* for each ttFiliales */
      end.
      
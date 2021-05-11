/* NOMBRE PROGRAMA: s1abmfil.p    BY: Andres Alleva  04/05/2005                      IBC ARGENTINA */
/* REVISION: 9.1      LAST MODIFIED: 06/30/06   BY: *MCT6* M.Cosigliolo   */
/* REVISION: 9.1      LAST MODIFIED: 01/19/07   BY: *JCF1* Julio Cerviño  */
/* *************************************************************************************** */
/* REV: EE            DATE: 20-JUL-2020        BY: *DF01* Diego Fernandez - Migracion a EE */
         
         
         {us/mf/mfdtitle.i "b+ "}
         {us/px/pxmaint.i}
         {us/bbi/gplabel.i}
         
         define variable filial                 like s1_filial_filial                                 no-undo.
         define variable per                    as integer                    format "99"             no-undo.
         define variable anio                   as integer                    format "9999"           no-undo.
         define variable usuario                like s1_user_id                                       no-undo.
         define variable dFilial                like s1_filial_descripcion                            no-undo.
         define variable passwd                 like s1_user_passwd                                   no-undo.
         define variable moneda                 like s1_filial_moneda                                 no-undo.
         define variable del-yn                 like mfc_logical              initial no              no-undo.
         define variable ans                    like mfc_logical              initial no              no-undo.
         
         define variable clave_pais             like code_fldname             initial "saps_mstr"     no-undo.
      /* define variable clave_region           like code_fldname             initial "sarg_mstr"     no-undo. */
         define variable clave_subregion        like code_fldname             initial "sasr_mstr"     no-undo.
      /* define variable clave_pacto            like code_fldname             initial "sapc_mstr"     no-undo. */
         define variable clave_uci              like code_fldname             initial "sauc_mstr"     no-undo.
         define variable desc1                  as character                                          no-undo.
         define variable desc3                  as character                                          no-undo.
         define variable desc5                  as character                                          no-undo.
         
         define new shared variable s1_execname as character                                          no-undo.
         
         {us/s1/s1logsig.i "false"}    
         
         session:data-entry-return = true.
         
         form
            dFilial                    colon 15       label "Filial"             format "x(30)"
            usuario                    colon 60       label "Usuario"
            per                        colon 15       label "Periodo/Año" 
            "/"
            anio                                   no-label
            moneda                     colon 60       label "Moneda"
            skip(1)
            s1_filial_filial           colon 15       label "Filial"
            s1_filial_descripcion      colon 15       label "Descripcion"
            s1_filial_moneda           colon 15       label "Moneda"
            s1_filial_pais             colon 15       label "Pais"
            desc1                                  no-label                      format "x(40)"
            s1_filial_subregion        colon 15       label "Sub-Region"
            desc3                                  no-label                      format "x(40)"
            s1_filial_uci              colon 15       label "UCI"
            desc5                                  no-label                      format "x(40)"
         with frame a side-labels width 80 attr-space.
         setFramelabels(frame a:handle).
         
         
         find first s1_filial no-lock
            where s1_filial_domain = global_domain
            and   s1_filial_filial = filial no-error.
         if available s1_filial then do:
            assign
               moneda  = s1_filial_moneda
               dFilial = s1_filial_descripcion.
         end.
         
         display
            dFilial 
            per 
            anio 
            moneda 
            usuario 
         with frame a.
         
         mainloop:
         repeat:
            
            innerloop: 
            repeat on endkey undo, leave mainloop:
               
               prompt-for 
                  s1_filial_filial 
               with frame a editing:
                  /* find NEXT/PREVIOUS RECORD */
                  {us/mf/mfnp05.i 
                     s1_filial 
                     s1_filial_index 
                     " s1_filial_domain = global_domain " 
                     s1_filial_filial 
                     "input s1_filial_filial"}
                  if recno <> ? then do:
                     find first code_mstr no-lock
                        where code_domain  = global_domain 
                        and   code_fldname = clave_pais 
                        and   code_value   = s1_filial_pais no-error.
                     if  available code_mstr then desc1 = code_cmmt. else desc1 = "".
                     
                     find first code_mstr no-lock
                        where code_domain  = global_domain 
                        and   code_fldname = clave_subregion 
                        and   code_value   = s1_filial_subregion no-error.
                     if  available code_mstr then desc3 = code_cmmt. else desc3 = "".
                     
                     find first code_mstr no-lock
                        where code_domain  = global_domain 
                        and   code_fldname = clave_uci 
                        and   code_value   = s1_filial_uci no-error.
                     if  available code_mstr then desc5 = code_cmmt. else desc5 = "".
                     
                     display 
                        s1_filial_filial
                        s1_filial_descripcion 
                        s1_filial_moneda    
                        s1_filial_pais       
                        desc1
                        s1_filial_subregion                  
                        desc3
                        s1_filial_uci                        
                        desc5
                     with frame a.
                  end.
               end. /* editing */
               
               /* ADD/MOD/DELETE  */
               find first s1_filial exclusive-lock
                  where s1_filial_domain = global_domain
                  and   s1_filial_filial = input s1_filial_filial no-error.
                  if not available s1_filial then do:
                     {us/bbi/mfmsg.i 1 1}
                     display
                        "" @ s1_filial_descripcion 
                     with frame a.
                     
                     create s1_filial.
                     assign 
                        s1_filial_domain = global_domain
                        s1_filial_filial 
                        s1_filial_descripcion.
                  if s1_filial_filial = "" then do:
                     {us/bbi/mfmsg.i 40 3}
                     undo, retry.
                  end. 
               end.
               else do:
                  {us/bbi/mfmsg.i 8221 1}
               end.
               
               find first code_mstr no-lock
                  where code_domain  = global_domain 
                  and   code_fldname = clave_pais 
                  and   code_value   = s1_filial_pais no-error.
               if  available code_mstr then desc1 = code_cmmt. else desc1 = "".
               
               find first code_mstr no-lock
                  where code_domain  = global_domain 
                  and   code_fldname = clave_subregion 
                  and   code_value   = s1_filial_subregion no-error.
               if  available code_mstr then desc3 = code_cmmt. else desc3 = "".
               
               find first code_mstr no-lock
                  where code_domain  = global_domain 
                  and   code_fldname = clave_uci 
                  and   code_value   = s1_filial_uci no-error.
               if  available code_mstr then desc5 = code_cmmt. else desc5 = "".
               
               display 
                  s1_filial_descripcion 
                  s1_filial_moneda
                  s1_filial_pais       
                  desc1
                  s1_filial_subregion                  
                  desc3
                  s1_filial_uci                        
                  desc5
               with frame a.
               
               loopb:
               do on error undo, retry:
                  
                  set
                     s1_filial_descripcion
                     s1_filial_moneda
                     s1_filial_pais
                     s1_filial_subregion
                     s1_filial_uci
                  go-on(F5 CTRL-D) with frame a.
                  
                  /* VALIDA MONEDA NO BLANCO */
                  if s1_filial_moneda = "" then do:
                     {us/bbi/mfmsg.i 1260 3}
                     undo, retry.
                  end.
                  
                  /* VALIDA MONEDA cu_curr */
                  find first cu_mstr no-lock where cu_curr = s1_filial_moneda no-error.
                  if not available cu_mstr then do:
                     {us/bbi/mfmsg.i 3109 3}
                     undo, retry.
                  end.
                  
                  /* VALIDA Pais */
                  find first code_mstr no-lock
                     where code_domain  = global_domain 
                     and   code_fldname = clave_pais 
                     and   code_value   = s1_filial_pais no-error.
                  if not available code_mstr then do:
                     {us/bbi/pxmsg.i &MSGNUM=861 &ERRORLEVEL=3}  /* No existe el codigo del pais */
                     next-prompt s1_filial_pais with frame a.
                     undo, retry.
                  end.
                  else do:
                     desc1 = code_cmmt. 
                     display desc1 with frame a.
                  end.
                  
                  /* VALIDA Sub-Region */
                  find first code_mstr no-lock
                     where code_domain  = global_domain 
                     and   code_fldname = clave_subregion 
                     and   code_value   = s1_filial_subregion no-error.
                  if not available code_mstr then do:
                     {us/bbi/pxmsg.i &MSGTEXT="'Codigo de Sub-Region Invalido'" &ERRORLEVEL=3}
                     next-prompt s1_filial_subregion with frame a.
                     undo, retry.
                  end.
                  else do:
                     desc3 = code_cmmt. 
                     display desc3 with frame a.
                  end.
                  
                  /* VALIDA UCI */
                  find first code_mstr no-lock
                     where code_domain  = global_domain 
                     and   code_fldname = clave_uci 
                     and   code_value   = s1_filial_uci no-error.
                  if not available code_mstr then do:
                     {us/bbi/pxmsg.i &MSGTEXT="'Codigo de UCI Invalido'" &ERRORLEVEL=3}
                     next-prompt s1_filial_uci with frame a.
                     undo, retry.
                  end.
                  else do:
                     desc5 = code_cmmt. 
                     display desc5 with frame a.
                  end.
                  
                  assign
                     s1_filial_usuario =  usuario
                     s1_filial_fecha   =  today.
                     
                  /* COMENTADA EN FUENTE PARA COMPILAR EN OFICINA */ 
                  /*
                  find first sasc_mstr exclusive-lock
                     where sasc_domain = global_domain
                     and   sasc_filial = s1_filial_filial no-error.
                  if not available sasc_mstr then do:
                     create sasc_mstr.
                     assign
                        sasc_domain = global_domain
                        sasc_filial = upper(s1_filial_filial).
                  end.
                  
                  assign
                     sasc_desc    = upper(s1_filial_descripcion)
                     sasc_pacto   = upper(s1_filial_pacto)
                     sasc_pais    = upper(s1_filial_pais)
                     sasc_region  = upper(s1_filial_region)
                     sasc_sub_reg = upper(s1_filial_subregion)
                     sasc_uci     = upper(s1_filial_uci).
                  */
               
               end. /* LOOPB */
               
               del-yn = no.  
               /* DELETE */
               if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
                  del-yn = yes.
                  {us/mf/mfmsg01.i 11 1 del-yn}
                  
                  if del-yn = no then next mainloop.
                  
                  if can-find(first s1_periodo where s1_per_domain = global_domain
                                               and   s1_per_filial =  s1_filial_filial) 
                  then do:
                     {us/bbi/pxmsg.i &MSGTEXT="'Existen PERIODOS definidos para esta FILIAL'" &ERRORLEVEL=4}
                     undo, retry.
                  end.
                  
                  delete s1_filial.
                  
                  display
                     "" @ s1_filial_filial
                     "" @ s1_filial_descripcion         
                     "" @ s1_filial_moneda    
                     "" @ s1_filial_pais                       
                     "" @ s1_filial_subregion                  
                     "" @ s1_filial_uci                        
                     "" @ desc1
                     "" @ desc3
                     "" @ desc5
                  with frame a.
                  
                  leave innerloop.
               end.
               
               /* ASK TO CONTINUE */
               ans = yes.
               {us/mf/mfmsg01.i 12 1 ans}
               if not ans then do:
                  display
                     "" @ s1_filial_filial
                     "" @ s1_filial_descripcion
                     "" @ s1_filial_moneda
                     "" @ s1_filial_pais
                     "" @ s1_filial_subregion
                     "" @ s1_filial_uci
                     "" @ desc1
                     "" @ desc3
                     "" @ desc5
                  with frame a.
               
               undo mainloop, retry mainloop.
            end.
            
            /* BLANQUEA */ 
            display
               "" @ s1_filial_filial
               "" @ s1_filial_descripcion
               "" @ s1_filial_moneda
               "" @ s1_filial_pais
               "" @ s1_filial_subregion
               "" @ s1_filial_uci
               "" @ desc1
               "" @ desc3
               "" @ desc5
            with frame a.
         
         end.  /* innerloop */
         
      end. /* mainloop */
      
      

/* d1nrafip.p - Renombrado o Borrado de Número Fiscal de Factura              */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 0.1       CREATED: 26/07/21   BY: *AA00* Adriel Arández          */

/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

DEFINE VARIABLE tipo_doc        AS CHARACTER format "x(2)" NO-UNDO
LABEL "Tipo documento".
DEFINE VARIABLE letra_doc       AS CHARACTER format "x(1)" NO-UNDO
LABEL "Letra documento".
DEFINE VARIABLE boca_doc        AS CHARACTER format "x(4)" NO-UNDO
LABEL "Boca documento".
DEFINE VARIABLE num_doc         AS CHARACTER format "x(9)" NO-UNDO
LABEL "Número documento".


DEFINE VARIABLE temp_tipo_doc   AS CHARACTER FORMAT "x(2)" NO-UNDO.
DEFINE VARIABLE temp_letra_doc  AS CHARACTER FORMAT "x(1)" NO-UNDO.
DEFINE VARIABLE temp_boca_doc   AS CHARACTER FORMAT "x(4)" NO-UNDO.
DEFINE VARIABLE temp_num_doc    AS CHARACTER FORMAT "x(9)" NO-UNDO.
DEFINE VARIABLE temp_xx2_date   AS DATE.
DEFINE VARIABLE temp_xx2_type   AS CHARACTER.
DEFINE VARIABLE temp_xx2_class  AS CHARACTER.
DEFINE VARIABLE temp_xx2_branch AS CHARACTER.
DEFINE VARIABLE temp_xx2_nbr    AS CHARACTER.
DEFINE VARIABLE temp_string     AS CHARACTER.

DEFINE VARIABLE borrar_numFis   AS LOGICAL NO-UNDO INITIAL FALSE.

define variable del-yn          AS LOGICAL NO-UNDO.
define variable camb-fact          AS LOGICAL NO-UNDO.

DEFINE VARIABLE cmensaje AS CHARACTER  NO-UNDO.
cmensaje = 'mensaje de error'.

/* DISPLAY SELECTION FORM */
form
        tipo_doc        COLON 30 
        letra_doc       COLON 30 
        boca_doc        COLON 30 
        num_doc         COLON 30 
        SKIP(1)                
        xx2_date        COLON 30 LABEL "Fecha de documento"
        xx2_bill        COLON 30 LABEL ""
        xx2_type        COLON 30 LABEL "Tipo"
        xx2_class       COLON 30 LABEL "L"
        xx2_branch      COLON 30 LABEL "Boca"
        xx2_nbr         COLON 30 LABEL "Numero"
        ad_name         COLON 30 LABEL "Nombre del cliente"
        ar_amt          COLON 30 LABEL "Monto total del documento"
        ar_curr         COLON 30 LABEL "Moneda del documento"
        borrar_numFis   COLON 30 LABEL "Borrar numero fiscal"

with frame a side-labels width 100.

/* SET EXTERNAL LABELS */
/*setFrameLabels(frame a:handle).*/

mainloop:
repeat with frame a:

    UPDATE tipo_doc
           letra_doc
           boca_doc
           num_doc.

    IF tipo_doc = "" OR tipo_doc = "RC" THEN DO:
       cmensaje = 'El tipo de documento no puede ser RC ni blanco.'.
       {pxmsg.i &MSGTEXT="""AVISO: "" + cmensaje" &ERRORLEVEL=3} /*AVISO:El tipo de documento no puede ser RC ni blanco.*/
       next-prompt tipo_doc with frame a.
       undo mainloop , retry mainloop.
    END. /* IF tipo_doc*/
  
    FIND FIRST xx2_mstr WHERE xx2_domain = global_domain
                        AND xx2_type = tipo_doc
                        AND xx2_class = letra_doc
                        AND xx2_branch = boca_doc
                        AND xx2_nbr = INTEGER(num_doc)
                        EXCLUSIVE-LOCK NO-ERROR.
                        
    IF NOT AVAILABLE xx2_mstr THEN DO:
    cmensaje = 'Registro no encontrado.'.
     {pxmsg.i &MSGTEXT="""AVISO: "" + cmensaje" &ERRORLEVEL=3} /*Registro no encontrado*/
    next-prompt tipo_doc with frame a.
    UNDO mainloop, RETRY mainloop. 
    END. /*IF NOT AVAILABLE xx2_mstr*/
    
    
    find FIRST ad_mstr  where ad_mstr.ad_domain = global_domain 
                        and ad_addr = xx2_bill 
                        NO-lock no-error.
                       
    find FIRST ar_mstr  where ar_mstr.ar_domain = global_domain 
                        AND ar_nbr = xx2_nbr_mfg
                        NO-lock no-error.
    
    DISPLAY xx2_date
            xx2_bill
            ad_name 
            ar_amt  
            ar_curr WITH FRAME a. 
    UPDATE  borrar_numFis.
    
    
    IF borrar_numFis = TRUE THEN DO:
        del-yn = yes.
         /*cmensaje = 'Confirma el borrado del numero fiscal?'.
         {pxmsg.i &MSGNUM=12 &MSGTEXT="""AVISO: "" + cmensaje" &ERRORLEVEL=1 &CONFIRM=del-yn}*/
        {mfmsg01.i 12 1 del-yn} /*TODO*//*“Confirma el borrado del numero fiscal”?*/
        if del-yn = no then DO:
            
            delloop:
            repeat with frame a:
            
                ASSIGN  temp_tipo_doc   = tipo_doc
                        temp_letra_doc  = letra_doc
                        temp_boca_doc   = boca_doc
                        temp_num_doc    = num_doc
                        temp_xx2_date   = DATE(xx2_date)
                        temp_xx2_type   = xx2_type  
                        temp_xx2_class  = xx2_class 
                        temp_xx2_branch = xx2_branch
                        temp_xx2_nbr    = STRING(xx2_nbr) .
                
                UPDATE  tipo_doc
                        letra_doc
                        boca_doc
                        num_doc
                        xx2_date
                        xx2_type  
                        xx2_class 
                        xx2_branch
                        xx2_nbr.
                
                IF  tipo_doc        = temp_tipo_doc
                    AND letra_doc   = temp_letra_doc   
                    AND boca_doc    = temp_boca_doc   
                    AND num_doc     = temp_num_doc    
                    AND xx2_date    = temp_xx2_date THEN DO: 
                        cmensaje = 'No se hicieron cambios en el sistema.'.
                        {pxmsg.i &MSGTEXT="""AVISO: "" + cmensaje" &ERRORLEVEL=2} /*“AVISO: No se hicieron cambios en el sistema”*/
                        NEXT mainloop.
                END. /*IF  tipo_doc ...*/
                
                IF xx2_date <> temp_xx2_date THEN DO:
                    
                    find FIRST  ih_hist  where ih_domain = global_domain 
                                and ih_inv_nbr  = xx2_nbr_mfg 
                                no-error.
                                
                    find FIRST  ar_mstr  where ar_domain = global_domain 
                                and ar_nbr  = xx2_nbr_mfg 
                                no-error.            
                                
                    ASSIGN  ih_inv_date = xx2_date
                            ar_date     = xx2_date.
                            
                    cmensaje = 'Se cambió la fecha de la factura, se generó un log de control.'.
                    {pxmsg.i &MSGTEXT="""AVISO: "" + cmensaje" &ERRORLEVEL=3} /*“AVISO: Se cambió la fecha de la factura, se generó un log de control.”*/  
                END. /*IF xx2_date*/
                
                FIND FIRST xx2_mstr WHERE   xx2_domain = global_domain 
                                        AND xx2_type = tipo_doc 
                                        AND xx2_class = letra_doc
                                        AND xx2_branch = boca_doc
                                        AND xx2_nbr = INTEGER(num_doc) NO-ERROR.
                                        
                IF AVAILABLE xx2_mstr THEN DO:
                    cmensaje = 'El nuevo número ya existe.'.
                    {pxmsg.i &MSGTEXT="""AVISO: "" + cmensaje" &ERRORLEVEL=3} /*“ERROR: El nuevo número ya existe”*/  
                    next-prompt tipo_doc with frame a.
                    UNDO delloop, RETRY delloop. 
                END. /*IF AVAILABLE xx2_mstr*/
                ELSE DO:
                    /*cmensaje = 'Confirma el cambio de numero de Factura?'.
                    {pxmsg.i &MSGTEXT="""AVISO: "" + cmensaje" &ERRORLEVEL=1 &CONFIRM=camb-fact} */
                    {mfmsg01.i 12 1 camb-fact} /*TODO*//*“Confirma el cambio de numero de Factura?*/
                    IF camb-fact = NO THEN DO:
                        UNDO delloop, RETRY delloop.
                    END. /*IF camb-fact*/
                    ELSE DO: 
                        cmensaje = 'Se cambió el numero de documento, se generó un log de control.'.
                        {pxmsg.i &MSGTEXT="""AVISO: "" + cmensaje" &ERRORLEVEL=3} /*“AVISO: Se cambió el numero de documento, se generó un log de control”*/  
                    END. /*else do*/
                END. /*else do*/
                
                FIND FIRST usrw_wkfl WHERE   usrw_domain = global_domain 
                                        AND usrw_key1 = "NUMERO_FISCAL"  
                                        AND usrw_key2 = xx2_nbr_mfg NO-ERROR.
                IF AVAILABLE usrw_wkfl THEN DO:
                    IF usrw_key2 MATCHES "*~~-*" /*"*-*"*/ THEN DO:
                        temp_string = usrw_key2.
                        temp_string = SUBSTRING (temp_string , INDEX(temp_string , "-") + 1 , LENGTH(temp_string) , "CHARACTER").
                        temp_string = STRING(INTEGER(temp_string) + 1).
                        xx2_nbr_mfg = xx2_nbr_mfg + "-" + temp_string.
                    END. /*IF usrw_key2 MATCHES...*/
                    ELSE xx2_nbr_mfg = xx2_nbr_mfg + "-001". 
                END. /*IF AVAILABLE usrw_wkfl*/
                
                CREATE  usrw_wkfl.
                ASSIGN  usrw_key1 = "NUMERO_FISCAL"                    
                        usrw_key2 = xx2_nbr_mfg                  
                        usrw_key3 = "MODIFICADO"                 
                        usrw_key4 = xx2_nbr_mfg                  
                        usrw_charfld[1] = temp_xx2_type          
                        usrw_charfld[2] = temp_xx2_class         
                        usrw_charfld[3] = temp_xx2_branch        
                        usrw_charfld[4] = xx2_type               
                        usrw_charfld[5] = xx2_class              
                        usrw_charfld[6] = xx2_branch             
                        usrw_intfld[1] = INTEGER(temp_xx2_nbr)   
                        usrw_intfld[2] = INTEGER(xx2_nbr)        
                        usrw_datefld[1] = DATE(temp_xx2_date)    
                        usrw_datefld[1] = xx2_date               
                        usrw_charfld[15] = global_userid         
                        usrw_intfld[15] = TIME
                        usrw_datefld[4] = DATE(TODAY).
                NEXT mainloop.
            END. /*delloop*/    
        END. /*if del-yn = no*/
        ELSE DO:
        
            ASSIGN xx2_domain = "BORRADO".
            cmensaje = 'Se borró el numero fiscal, se generó un log de control.'.
            {pxmsg.i &MSGTEXT="""AVISO: "" + cmensaje" &ERRORLEVEL=3} /*"Se borró el numero fiscal, se generó un log de control"*/
            CREATE  usrw_wkfl.
            ASSIGN  usrw_key1 = "NUMERO_FISCAL"
                    usrw_key2 = xx2_nbr_mfg
                    usrw_key3 = "BORRADO"
                    usrw_key4 = xx2_nbr_mfg
                    usrw_charfld[1] = xx2_type
                    usrw_charfld[2] = xx2_class
                    usrw_charfld[3] = xx2_branch
                    usrw_intfld[1] = INTEGER(xx2_nbr)
                    usrw_datefld[1] = xx2_date
                    usrw_charfld[15] = global_userid
                    usrw_intfld[15] = TIME
                    usrw_datefld[4] = DATE(TODAY).
        END. /*else do*/
    END. /*if borrar_numFis*/



END. /*mainloop*/
def stream inputStream.
def stream outStream.

def var dntData           as char extent 1 no-undo.

def var vl-CIN# as integer.

def var vl-error as char.
def var vl-match as char.


input stream inputStream from "/home/xxx/xxx/xxx/xxx/FirstInput.csv".

output stream outStream to "/home/xxx/xxx/xxx/xxx/FirstOutput.csv".

export stream outStream delimiter "'" "CustomerID" "Match" "Error".
 
Repeat:   
   
    assign
    dntData = "".
        
    import stream inputStream delimiter "'" dntData.

    assign
    vl-CIN# = integer(dntnData[1]).

 
   

   find first members where cin# = vl-CIN#.
       
           if not available(members) then
             assign
               vl-error = "Could Not Find".
           if available(members) then
             assign
                vl-match = "Account Exists".
 

    

export stream outStream delimiter "'" vl-CIN# vl-match vl-error.

--------------------------------------------------------------------------------------------------------------------------------------------------------------

define temp-table tt
   field id as int
   .

create tt. tt.id = 1.
/* create tt. tt.id = 2.*/
create tt. tt.id = 3.

def var cc as char extent 1.
def var id as int.

input from "C:\Users\QAD\Desktop\Documentos_Trabajo\input.csv".
 
repeat:
   
   cc = ''.
   import delimiter "'" cc.

   id = integer( cc[1] ).

   find first tt where tt.id = id no-error.       
   if not available tt then 
      message 'not found' id.
   else
      message 'found' tt.id.

end.



define temp-table tt
   field id as int.
create tt. tt.id = 1.
/* create tt. tt.id = 2.*/
create tt. tt.id = 3.

def var cc as char extent 1.
def var id as int.
DEFINE VARIABLE a AS char. 

input from "C:\Users\QAD\Desktop\Documentos_Trabajo\input.csv".
 
repeat: 
   cc = ''.
   import delimiter "'" cc.

   id = integer( cc[1] ).

   find first tt where tt.id = id no-error.       
   if not available tt then 
      message 'not found' id.
   else
      message 'found' tt.id.
      
    IMPORT a.
   
    DISPLAY a.

end.

--------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Se define el nombre de la tabla que se quiera exportar.*/
&SCOPED-DEFINE TableToExport clientes

/*Se define la ubicación donde se quiere exportar*/
DEFINE VARIABLE lv-output-path AS CHARACTER NO-UNDO INITIAL "C:\Users\QAD\Desktop\Documentos_Trabajo\".
DEFINE VARIABLE lv-output-type AS CHARACTER NO-UNDO INITIAL "csv".
/*Registran las cabeceras de columnas de datos.*/
DEFINE VARIABLE lv-headings    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv-count       AS INTEGER   NO-UNDO.

DEFINE STREAM data-export.

/* Make a list of field-headings */

FOR EACH _file NO-LOCK WHERE _file-name = "{&TableToExport}":
    FOR EACH _field OF _file NO-LOCK BY _field._Order:
        ASSIGN lv-count = 1.
        IF _field._extent = 0 THEN
            ASSIGN lv-headings = lv-headings + "," + _field._field-name.
        ELSE 
            ASSIGN lv-headings = lv-headings + "," + _field._field-name + "[1]".
        DO WHILE lv-count < _field._extent:
            ASSIGN lv-count    = lv-count + 1
                   lv-headings = lv-headings + "," + _field._field-name + "[" + STRING(lv-count) + "]".
        END.
    END.
END.

/* Output the  field-headings */
/*Escribe las cabeceras de datos*/
OUTPUT STREAM data-export TO VALUE(lv-output-path + "{&TableToExport}" + "1." + lv-output-type).
/*PUT STREAM data-export UNFORMATTED LEFT-TRIM(lv-headings, ",") SKIP.*/

/* Output the table contents */
/*Escribe elcontenido de la tabla*/
FOR EACH {&TableToExport} NO-LOCK.
    EXPORT STREAM data-export DELIMITER "," {&TableToExport}.
END.

OUTPUT STREAM data-export CLOSE.


--------------------------------------------------------------------------------------------------------------------------------------------------------------


DEFINE TEMP-TABLE tabla NO-UNDO
    FIELD f1 AS CHARACTER
    FIELD f2 AS INTEGER
    FIELD f3 AS INTEGER.

DEFINE STREAM strImport.
DEFINE VARIABLE cCsvFile AS CHARACTER   NO-UNDO.

cCsvFile = "C:\Users\QAD\Desktop\Documentos_Trabajo\firmas.csv".

INPUT STREAM strImport FROM VALUE(cCsvFile).
REPEAT :
    CREATE tabla.
    /* Default separator is space so use , instead */
    IMPORT STREAM strImport DELIMITER "," tabla.

END.
INPUT CLOSE.


FOR EACH tabla:
    DISPLAY tabla.
END.

------------------------------------------------------------------------------------------------------------------------------------------------------------

&SCOPED-DEFINE TableToExport clientes

/*Se define la ubicación donde se quiere exportar*/
DEFINE VARIABLE lv-output-path AS CHARACTER NO-UNDO INITIAL "C:\Users\QAD\Desktop\Documentos_Trabajo\".
DEFINE VARIABLE lv-output-type AS CHARACTER NO-UNDO INITIAL "csv".
/*Registran las cabeceras de columnas de datos.*/
DEFINE VARIABLE lv-headings    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv-count       AS INTEGER   NO-UNDO.

DEFINE STREAM data-export.

/* Make a list of field-headings */

FOR EACH _file NO-LOCK WHERE _file-name = "{&TableToExport}":
    FOR EACH _field OF _file NO-LOCK BY _field._Order:
        ASSIGN lv-count = 1.
        IF _field._extent = 0 THEN
            ASSIGN lv-headings = lv-headings + "," + _field._field-name.
        ELSE 
            ASSIGN lv-headings = lv-headings + "," + _field._field-name + "[1]".
        DO WHILE lv-count < _field._extent:
            ASSIGN lv-count    = lv-count + 1
                   lv-headings = lv-headings + "," + _field._field-name + "[" + STRING(lv-count) + "]".
        END.
    END.
END.

/* Output the  field-headings */
/*Escribe las cabeceras de datos*/
OUTPUT STREAM data-export TO VALUE(lv-output-path + "{&TableToExport}" + "1." + lv-output-type).
/*PUT STREAM data-export UNFORMATTED LEFT-TRIM(lv-headings, ",") SKIP.*/

/* Output the table contents */
/*Escribe elcontenido de la tabla*/
FOR EACH {&TableToExport} NO-LOCK.
    EXPORT STREAM data-export DELIMITER "," {&TableToExport}.
END.

OUTPUT STREAM data-export CLOSE.
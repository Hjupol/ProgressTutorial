/*pasar una tabla a csv, ver transaction(cargar datos a dos tablas, displayarlo, y deshacerlo), ver clases.*/
FUNCTION dynExport RETURNS CHARACTER
    (INPUT hRecord  AS HANDLE,
     INPUT cDelim   AS CHARACTER):

  DEFINE VARIABLE hFld     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCnt     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iExtnt   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cTmp     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cArray   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cResult  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLobname AS CHARACTER NO-UNDO.

  IF hRecord:TYPE <> "BUFFER" THEN
      RETURN ?.

  DO iCnt = 1 TO hRecord:NUM-FIELDS:

      ASSIGN hFld = hRecord:BUFFER-FIELD(iCnt).

/* Handle EXPORT for large objects by writing them out to .blb files. Omit this section in Progress 9 
 * EXPORT adds extra "" for output compatible with the INPUT statement.
 * Names for blobs are not guaranteed the same as the static EXPORT statement, IMPORT handles them correctly. 
*/
      IF hFld:DATA-TYPE = "clob" OR hFld:DATA-TYPE = "blob" THEN DO:
          IF hFld:BUFFER-VALUE = ? THEN DO:
             cResult = cResult + "?" + cDelim.
          END.
          ELSE DO:
              cLobname = hFld:NAME +
               (IF hFld:DATA-TYPE = "clob" THEN "!" + GET-CODEPAGE(hFld:BUFFER-VALUE) + "!" ELSE "") 
                   + hRecord:TABLE + "_" + STRING(hRecord:RECID) + ".blb".
              COPY-LOB FROM hFld:BUFFER-VALUE TO FILE cLobname NO-CONVERT.
              cResult = cResult + QUOTER(cLobname) + cDelim.
          END.
          NEXT.
      END.
      
      IF hFld:EXTENT = 0 THEN DO:
         IF hFld:BUFFER-VALUE = ? then cTmp = "?".
            ELSE 
         
  CASE hFld:DATA-TYPE:
  WHEN "character" THEN cTmp = QUOTER(hFld:BUFFER-VALUE).
  WHEN "raw"  THEN cTmp = '"' + STRING(hFld:BUFFER-VALUE) + '"'.
  WHEN "datetime" OR 
  WHEN "datetime-tz" THEN
        cTmp = string(year(hFld:BUFFER-VALUE),"9999") 
        + "-" + string(month(hFld:BUFFER-VALUE),"99") 
        + "-" + string(day(hFld:BUFFER-VALUE),"99") 
        + "T" + substring(string(hFld:BUFFER-VALUE),12).
  OTHERWISE  cTmp = STRING(hFld:BUFFER-VALUE).
  END CASE.
         
         cResult = cResult + cTmp + cDelim.
      END.
      ELSE DO:
          cArray = "".   
          DO iExtnt = 1 TO hFld:EXTENT:
              IF hFld:BUFFER-VALUE(iExtnt) = ? THEN cTmp = "?".
                 ELSE

              CASE hFld:DATA-TYPE:
                  WHEN "character" THEN cTmp = QUOTER(hFld:BUFFER-VALUE(iExtnt)).
                  WHEN "raw"          THEN cTmp = '"' + STRING(hFld:BUFFER-VALUE(iExtnt)) + '"'.
                  WHEN "datetime" OR 
                  WHEN "datetime-tz" THEN 
                        cTmp = string(year(hFld:BUFFER-VALUE(iExtnt)),"9999") 
                        + "-" + string(month(hFld:BUFFER-VALUE(iExtnt)),"99") 
                        + "-" + string(day(hFld:BUFFER-VALUE(iExtnt)),"99") 
                        + "T" + substring(string(hFld:BUFFER-VALUE(iExtnt)),12).
                 OTHERWISE  cTmp = STRING(hFld:BUFFER-VALUE(iExtnt)).
              END CASE.

              cArray = cArray + cTmp + cDelim.
          END.
          cResult = cResult + RIGHT-TRIM(cArray,cDelim) + cDelim.
      END.
  END.
  RETURN RIGHT-TRIM(cResult,cDelim).
END.

DEFINE INPUT PARAMETER tabla AS CHARACTER.

/*Se define la ubicación donde se quiere exportar*/
 
DEFINE VARIABLE lv-output-path AS CHARACTER NO-UNDO INITIAL "C:\Users\QAD\Documents\GitHub\ProgressTutorial\".
DEFINE VARIABLE lv-output-type AS CHARACTER NO-UNDO INITIAL "csv".
/*Registran las cabeceras de columnas de datos.*/
DEFINE VARIABLE lv-headings    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv-count       AS INTEGER   NO-UNDO.
DEFINE VARIABLE hBufferHandle AS HANDLE  NO-UNDO.
DEFINE VARIABLE hQueryHandle AS HANDLE  NO-UNDO.

DEFINE STREAM data-export.
/*
DEFINE TEMP-TABLE tablaTemporal LIKE tabla.

ASSIGN tablaTemporal=tabla.*/
/* Make a list of field-headings */

FOR EACH _file NO-LOCK WHERE _file-name = tabla:
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
/*OUTPUT STREAM data-export TO VALUE(lv-output-path + tabla + "nuevos." + lv-output-type).*/
/*PUT STREAM data-export UNFORMATTED LEFT-TRIM(lv-headings, ",") SKIP.*/

/* Output the table contents */
/*Escribe elcontenido de la tabla*/

/*
FOR EACH '"' + tabla + '"' NO-LOCK.
    EXPORT STREAM data-export DELIMITER "," tabla.
END.*/
DEFINE VARIABLE cExportData AS CHARACTER NO-UNDO.
/*FIND FIRST clientes.*/
CREATE BUFFER  hBufferHandle FOR TABLE  tabla.
CREATE QUERY  hQueryHandle.
hQueryHandle:SET-BUFFERS(hBufferHandle).
hQueryHandle:QUERY-PREPARE("for each " + tabla + " NO-LOCK").
hQueryHandle:QUERY-OPEN.

OUTPUT TO VALUE(lv-output-path + tabla + "nuevos." + lv-output-type).
    REPEAT:
        hQueryHandle:GET-NEXT().
        IF hQueryHandle:QUERY-OFF-END THEN LEAVE.
        ELSE DO:
            cExportData = dynExport(INPUT hBufferHandle, INPUT ",").
            PUT UNFORMATTED cExportData SKIP.
        /*PUT hBufferHandle:CREATE-RESULT-LIST-ENTRY().*/
            /*EXPORT STREAM data-export DELIMITER "," clientes. /*hBufferHandle:NAME*/*/
        END.
    END.
    hQueryHandle:QUERY-CLOSE.
OUTPUT CLOSE.
DELETE OBJECT hBufferHandle.
    DELETE OBJECT hQueryHandle.




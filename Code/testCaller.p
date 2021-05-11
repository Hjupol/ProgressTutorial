/*DEFINE TEMP-TABLE tablaTemporal LIKE clientes.*/
DEFINE VARIABLE handlerPersistent AS HANDLE NO-UNDO.
DEFINE VARIABLE messagestring AS CHARACTER NO-UNDO.

DEFINE NEW SHARED VARIABLE variableCompartida AS CHARACTER NO-UNDO INITIAL "Variable compartida.".
/*Muestra una tabla temporal en base a clientes*/   
/* 
RUN C:\Users\QAD\Documents\GitHub\ProgressTutorial\CODE\displayer.p(INPUT-OUTPUT TABLE tablaTemporal).
*/

/*Convierte en csv la tabla otorgada*/
/*
RUN C:\Users\QAD\Documents\GitHub\ProgressTutorial\CODE\toCSV.p("clientes").
*/

/*Prueba de procesos persistentes*/

RUN C:\Users\QAD\Documents\GitHub\ProgressTutorial\CODE\persistentProc1.p PERSISTENT SET handlerPersistent.

RUN sharedVar IN handlerPersistent.
MESSAGE variableCompartida VIEW-AS ALERT-BOX.

/*
RUN cabra IN handlerPersistent ( OUTPUT messagestring ).
MESSAGE messagestring VIEW-AS ALERT-BOX.

RUN rueda IN handlerPersistent ( OUTPUT messagestring ).
MESSAGE messagestring VIEW-AS ALERT-BOX.

RUN sea IN handlerPersistent ( OUTPUT messagestring ).
MESSAGE messagestring VIEW-AS ALERT-BOX.
*/
DELETE OBJECT handlerPersistent.
/*
FOR EACH tablaTemporal:
DISPLAY tablaTemporal.
END.
*/
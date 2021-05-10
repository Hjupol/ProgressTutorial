/*DEFINE TEMP-TABLE tablaTemporal LIKE clientes.*/
DEFINE VARIABLE handlerPersistent AS HANDLE NO-UNDO.
DEFINE VARIABLE messagestring AS CHARACTER NO-UNDO.

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

RUN cabra IN handlerPersistent ( OUTPUT messagestring ).
MESSAGE messagestring VIEW-AS ALERT-BOX.

RUN rueda IN handlerPersistent ( OUTPUT messagestring ).
MESSAGE messagestring VIEW-AS ALERT-BOX.

RUN sea IN handlerPersistent ( OUTPUT messagestring ).

DELETE OBJECT handlerPersistent.

MESSAGE messagestring VIEW-AS ALERT-BOX.


/*
FOR EACH tablaTemporal:
DISPLAY tablaTemporal.
END.
*/
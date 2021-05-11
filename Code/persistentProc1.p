DEFINE SHARED VARIABLE variableCompartida AS CHARACTER NO-UNDO.

PROCEDURE sharedVar:
    MESSAGE variableCompartida VIEW-AS ALERT-BOX.
    ASSIGN variableCompartida = "keloke cabron".
END PROCEDURE.

PROCEDURE sea:
   DEFINE OUTPUT PARAMETER messagestring AS CHARACTER NO-UNDO.

   messagestring = "see sea".

END PROCEDURE.

PROCEDURE rueda:
   DEFINE OUTPUT PARAMETER messagestring AS CHARACTER NO-UNDO.

   messagestring = "rueda redonda".

END PROCEDURE.

PROCEDURE cabra:
   DEFINE OUTPUT PARAMETER messagestring AS CHARACTER NO-UNDO.

   messagestring = "cabra cabrona".

END PROCEDURE.


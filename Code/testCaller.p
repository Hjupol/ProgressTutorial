DEFINE TEMP-TABLE tablaTemporal LIKE clientes.
    
RUN C:\Users\QAD\Documents\GitHub\ProgressTutorial\CODE\displayer.p(INPUT-OUTPUT TABLE tablaTemporal).

FOR EACH tablaTemporal:
DISPLAY tablaTemporal.
END.
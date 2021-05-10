DEFINE TEMP-TABLE tablaTemporal LIKE clientes.
    
RUN C:\Users\QAD\Documents\GitHub\ProgressTutorial\CODE\displayer.p(INPUT-OUTPUT TABLE tablaTemporal).

RUN C:\Users\QAD\Documents\GitHub\ProgressTutorial\CODE\toCSV.p("clientes").

FOR EACH tablaTemporal:
DISPLAY tablaTemporal.
END.
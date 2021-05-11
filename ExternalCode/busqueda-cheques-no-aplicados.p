for each debtor no-lock where debtor.debtorcode = "cli-raff":
  foR EACH ddocument no-lock where ddocument.debtor_id = debtor.debtor_id:
    if not ddocument.ddocumentreference begins "CHQ3-080" then next.
    disp ddocument.ddocumentisopen ddocument.DDocumentReference
    ddocumentstatus ddocumenttype ddocumentsubtype.
  for each DDocumentInvoiceXRef no-lock where 
    ddocumentInvoiceXRef.DDocument_ID = 
    ddocument.ddocument_id:
    message ddocument.DDocumentReference 
    DDocumentOriginalDebitTC abs(DDocumentInvoiceXrefAlloTC).
  end.                  
  end.
end.  

; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_substatt.lsp 1.0

    Replace a text attribut in objet model.

    Place the files, odbx_substatt.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_substatt in Autocad, the old text, the new and choose folder.

    Drawings are not open.
	
    PLEASE NOTE, there is no going back.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2021 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_substatt (/ axdoc lfil dir old new tat)
    (setq old (getstring "Old text?")
          new (getstring "New text?")
    )
        ; Choose folder.
    (if (and (setq dir (getdir)) 
              ; dwg liste.
            (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over objects in model space.
                (vlax-for obj (vla-get-modelspace axdoc)
                    ; If it's a block.
                    (if (= (vla-get-ObjectName obj) "AcDbBlockReference")
                      ; Loop over eventuals attributs
                      (foreach att (vlax-invoke obj 'GetAttributes)
                        (if (vl-string-search old (setq tat (vla-get-textstring att)))
                            (vlax-put att 'TextString (vl-string-subst new old tat))
                        )
                       )
                    )
                )
                (vla-saveas axdoc (strcat dir f))
                (vlax-release-object axdoc)
              )
              (princ (strcat "\n" f ": Illegible or corrupt."))
            )
        )
        (princ (strcat "\nHave you lost your way?"))
    )
(princ)
)

;É;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


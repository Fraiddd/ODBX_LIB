; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_substmtext.lsp 1.0

    Replace a text in a multiline text in the model space.

    Place the files, odbx_substmtext.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_substmtext in Autocad, the old text, the new  and choose folder.

    Drawings are not open.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2021 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_substmtext (/ axdoc lfil dir old new text flag)
    (setq old (getstring "Old text?")
          new (getstring "New text?")
    )
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over objects in model space.
                (vlax-for obj (vla-get-modelspace axdoc)
                    ; If it's a mtext.
                    (if (and (= (vla-get-ObjectName obj) "AcDbMText")
                         (vl-string-search old (setq text (vla-get-textstring obj)))
                         )
                         (progn
                           (vlax-put obj 'TextString (vl-string-subst new old text))
                           (setq flag 1)
                         )
                    )
                )
                (if flag (vla-saveas axdoc (strcat dir f)))
                (vlax-release-object axdoc)
              )
            )
            
            (setq flag nil)
        )
    )
(princ)
)

;É;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


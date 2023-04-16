; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_substmlead.lsp 1.0

    Replace a text in a MLeader in the model space.

    Place the files, odbx_substmlead.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_substmlead in Autocad, the old text, the new  and choose folder.

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
(defun c:odbx_substmlead (/ axdoc lfil dir old new text flag)
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
                    ; If it's a MLeader.
                    (if (and (= (vla-get-ObjectName obj) "AcDbMLeader")
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
              (princ (strcat "\n" f ": Illegible or corrupt."))
            )
            (setq flag nil)
        )
        (princ "\nHave you lost your way?")
    )
(princ)
)

;É;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


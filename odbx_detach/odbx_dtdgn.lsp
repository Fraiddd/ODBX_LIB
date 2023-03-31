; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_dtdgn.lsp 1.0

    Detach DGN from drawings contained in a folder.

    Place the files, odbx_dtdgn.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_dtdgn in Autocad and choose folder.

    Drawings are not open.

    PLEASE NOTE, there is no going back.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2021 by Fr�d�ric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_dtdgn (/ axdoc lfil dir)
        ; Choose folder.
    (if (and (setq dir (getdir)) 
              ; dwg liste.
            (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over objects.
                (vlax-for obj (vla-get-modelspace axdoc)
                    (if (= (vla-get-objectname obj) "AcDbDgnReferencee")
                        (vla-delete obj)
                    )
                )
                (vlax-for di (vla-get-dictionaries axdoc)
                    (if (eq (vl-catch-all-apply 'vla-get-name (list di)) 
                            "ACAD_DGNDEFINITIONS")
                        (vlax-for d di
                            (vla-delete d)
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

;�;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


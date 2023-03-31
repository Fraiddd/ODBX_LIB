; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_dtdwf.lsp 1.0

    Detach DWF from drawings contained in a folder.

    Place the files, odbx_dtdwf.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_dtdwf in Autocad and choose folder.

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
(defun c:odbx_dtdwf (/ axdoc lfil dir)
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
                    (if (= (vla-get-objectname obj) "AcDbDwfReferencee")
                        (vla-delete obj)
                    )
                )
                ; Loop over dictionaries.
                (vlax-for di (vla-get-dictionaries axdoc)
                    (if (eq (vl-catch-all-apply 'vla-get-name (list di)) "ACAD_DWFDEFINITIONS")
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

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


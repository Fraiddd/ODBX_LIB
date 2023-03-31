; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_delgroup.lsp 1.0

    Delete groups.

    Place the files, odbx_delgroup.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_delgroup in Autocad and choose folder.

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
(defun c:odbx_delgroup (/ axdoc lfil dir u)
        ; Choose folder.
    (if (and (setq dir (getdir)) 
              ; dwg liste.
            (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if(setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                (setq u 0)
                ; Loop over groups while a group was deleted
                (while (= u 0)
                    (setq u 1)
                    (vlax-for group (vla-get-groups axdoc)
                        (if (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-delete (list group))))
                            (setq u 0)
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


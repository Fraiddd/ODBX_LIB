; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_purgeLinetype.lsp 1.0

    Removes Linetypes not used.

    Place the files, odbx_purgeLinetype.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_purgeLinetype in Autocad and choose folder.

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
(defun c:odbx_purgeLinetype (/ axdoc lfil dir)
        ; Choose folder.
    (if (and (setq dir (getdir)) 
              ; dwg liste.
            (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over Linetypes
                (vlax-for lty (vla-get-Linetypes axdoc)
                    (vl-catch-all-apply 'vla-delete (list lty))
                )
                (vla-saveas axdoc (strcat dir f))
                (vlax-release-object axdoc)
              )
              (princ (strcat "\n" f ": Illegible or corrupt."))
            )
        )
        (princ "\nHave you lost your way?")
    )
(princ)
)

;�;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


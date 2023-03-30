; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_getlistlayer.lsp 1.0

   Get the list of layers.

    Place the files, odbx_getlistlayer.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_getlistlayer in Autocad and choose folder.

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
(defun c:odbx_getlistlayer (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1))
      (progn
        ; Loop over files.
        (foreach f lfil 
            (princ (strcat "\n" f ":"))
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over lay
                (vlax-for lay (vla-get-layers axdoc)
                    (princ (strcat "\n    " (vla-get-name lay)))
                )
                (vla-saveas axdoc (strcat dir f))
                (vlax-release-object axdoc)
              )
            )
        )
        (textscr)
      )
    )
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


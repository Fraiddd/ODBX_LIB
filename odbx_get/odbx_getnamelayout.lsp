; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_getnamelayout.lsp 1.0

    Get the name of layouts.

    Place the files, odbx_getnamelayout.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_getnamelayout in Autocad and choose folder.

    Drawings are not open.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2021 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_getnamelayout (/ axdoc lfil dir name)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
      (progn
        (foreach f lfil 
            (princ (strcat "\n" f ":"))
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
                (vlax-for layout (vla-get-layouts axdoc)
                    (setq name (vla-get-name layout))
                    (if (/= name "Model")
                        (princ (strcat "\n    " name))
                    )
                )
            )
            (vlax-release-object axdoc)
        )
        (textscr)
      )
    )
(princ)
)

;É;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


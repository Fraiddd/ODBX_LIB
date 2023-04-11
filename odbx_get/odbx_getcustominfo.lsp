; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_getcustominfo.lsp 1.0

    Get the custom infos.

    Place the files, odbx_getcustominfo.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_getcustominfo in Autocad and choose folder.

    Drawings are not open.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2023 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_getcustominfo (/ axdoc lfil dir cpt sinfo key val nbinfo)
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
                ; If there is any CustomInfo.
                (setq cpt 0 sinfo (vla-get-SummaryInfo axdoc))
                (if (> (setq nbinfo (vla-NumCustomInfo sinfo)) 0)
                    ; Loop over custom info
                    (while (< cpt nbinfo)
                        (vla-GetCustomByIndex sinfo cpt 'key 'val)
                        (princ (strcat "\n  " key ": " val))
                        (setq cpt (1+ cpt))
                    )
                    (princ "\n  No custom info")
                )
                (vlax-release-object axdoc)
              )
              (princ (strcat "\n" f ": Illegible or corrupt."))
            )
        )
        (textscr)
      )
      (princ (strcat "\nHave you lost your way?"))
    )
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


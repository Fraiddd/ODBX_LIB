; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_sendsel.lsp 1.0

    Sends the selection to a drawing folder.

    Place the files, odbx_sendsel.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_sendsel in Autocad and choose folder.

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
(defun c:odbx_sendsel (/ acdc axdoc sel lfil dir)
    (setq acdc (vla-get-activedocument(vlax-get-acad-object))
          sel (if (ssget)(vla-get-activeselectionset acdc)))
        ; Choose folder.
    (if (and (setq dir (getdir)) 
          ; dwg liste.
        (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                  (vlax-for obj sel
                    (vla-copyobjects acdc (vlax-safearray-fill (vlax-make-safearray vlax-vbobject(cons 0 0))
                            (list obj))
                            (vla-get-modelspace axdoc))
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

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


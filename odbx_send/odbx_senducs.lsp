; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_senducs.lsp 1.0

    Sends the UCS to a drawing folder.

    Place the files, odbx_senducs.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_senducs in Autocad and choose folder.

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
(defun c:odbx_senducs (/ acdc axdoc ucss lfil dir)
    (setq acdc (vla-get-activedocument(vlax-get-acad-object))
          ucss (vla-get-UserCoordinateSystems acdc))
        ; Choose folder.
    (if (and (setq dir (getdir)) 
          ; dwg liste.
        (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                  (vlax-for ucs ucss
                    (vl-catch-all-apply 'vla-copyobjects (list acdc (vlax-safearray-fill (vlax-make-safearray vlax-vbobject(cons 0 0))
                            (list ucs))
                            (vla-get-modelspace axdoc)))
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


; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_sendTextStyle.lsp 1.0

    Sends the text styles to a drawing folder.

    Place the files, odbx_sendTextStyle.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_sendTextStyle in Autocad and choose folder.

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
(defun c:odbx_sendTextStyle (/ acdc axdoc lts lfil dir)
    (setq acdc (vla-get-activedocument(vlax-get-acad-object))
          lts (vla-get-TextStyles acdc))
        ; Choose folder.
    (if (and (setq dir (getdir)) 
          ; dwg liste.
        (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                  (vlax-for lt lts
                    (vl-catch-all-apply 'vla-copyobjects (list acdc (vlax-safearray-fill (vlax-make-safearray vlax-vbobject(cons 0 0))
                            (list lt))
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

;�;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


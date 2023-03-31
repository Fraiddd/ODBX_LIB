; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_delobjinlay.lsp 1.0

    Delete all objects in a layer and purge layers.

    Place the files, odbx_delobjinlay.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_delobjinlay in Autocad, the layer name and choose folder.

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
(defun c:odbx_delobjinlay (/ axdoc lfil dir lay)
    (setq lay (getstring "What Layer?"))
        ; Choose folder.
    (if (and (setq dir (getdir)) 
              ; dwg liste.
            (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if(setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over objects in model space.
                (vlax-for obj (vla-get-modelspace axdoc)
                    ; If object in the layer.
                    (if (= (vla-get-layer obj) lay)
                        (vl-catch-all-apply 'vla-delete (list obj ))
                    )
                )
                 ; Loop over lay
                (vlax-for layer (vla-get-layers axdoc)
                    ; Layers containing objects, "0", locked layer and current, raise an exception.
                    (vl-catch-all-apply 'vla-delete (list layer))
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

;É;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




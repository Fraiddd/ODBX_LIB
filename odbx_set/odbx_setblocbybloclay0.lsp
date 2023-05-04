; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_setblocbybloclay0.lsp 1.0

    Place all block objects in layer "0" and force color, linetype and thickness to "byblock".
    
    Place the files, odbx_setblocbybloclay0.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_setblocbybloclay0 in Autocad and choose folder.

    Drawings are not open.

    PLEASE NOTE, there is no going back.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2023 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_setblocbybloclay0 (/ axdoc lfil dir)
        ; Choose folder.
    (if (and (setq dir (getdir)) 
              ; dwg liste.
            (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over blocks
                (vlax-for bloc (vla-get-blocks axdoc)
                    (if (= (vla-get-islayout bloc) :vlax-false)
                        (vlax-for obj bloc
                            (vla-put-layer obj "0")
                            (vla-put-color obj 0)
                            (vla-put-linetype obj "ByBlock")
                            (vla-put-lineweight obj -2)
                        )
                    )
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


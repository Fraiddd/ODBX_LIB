; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    unldxref.lsp 1.0

    Reload XREF from drawings contained in a folder.

    Place the files, unldxref.lsp and fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load unldxref.lsp and fct.lsp.

    Enter dtimg in Autocad and choose folder.

    Drawings are not open.

    PLEASE NOTE, there is no going back.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2021 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:unldxref (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
        (foreach f lfil 
            ; Loop over blocks.
			(vlax-for bloc (vla-get-blocks (setq axdoc (getaxdbdoc (strcat dir f))))
				; If the block is an xref, it's unloaded.
				(if	(= :vlax-true (vla-get-isxref bloc))
					(vla-unload (vla-item (vla-get-Blocks axdoc)
										  (eval (vla-get-Name bloc))))
				)
			)
			(vla-saveas axdoc (strcat dir f))
			(vlax-release-object axdoc)
        )
    )
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


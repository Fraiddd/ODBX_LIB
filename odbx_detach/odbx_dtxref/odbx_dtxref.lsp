; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_dtxref.lsp 1.0

    Detach XREF from drawings contained in a folder.

    Place the files, odbx_dtxref.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_dtxref in Autocad and choose folder.

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
(defun c:odbx_dtxref (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
        (foreach f lfil 
			(if (setq axdoc (getaxdbdoc (strcat dir f)))
			  (progn
				; Loop over blocks.
				(vlax-for bloc (vla-get-blocks axdoc)
					(if	(= :vlax-true (vla-get-isxref bloc))
						(vl-catch-all-apply 'vla-delete (list bloc))
					
					)
				)
				(vla-saveas axdoc (strcat dir f))
				(vlax-release-object axdoc)
			  )
			)
        )
    )
(princ)
)

;�;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


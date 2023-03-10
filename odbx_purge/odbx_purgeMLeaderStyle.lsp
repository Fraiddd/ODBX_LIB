; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_purgeMLeaderStyle.lsp 1.0

    Removes DimStyles not used.

    Place the files, odbx_purgeMLeaderStyle.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_purgeMLeaderStyle in Autocad and choose folder.

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
(defun c:odbx_purgeMLeaderStyle (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over MLeaderStyle
				(vlax-for di (vla-get-dictionaries axdoc)
					(if (= (vl-catch-all-apply 'vla-get-name (list di))
							"ACAD_MLEADERSTYLE")
						(vlax-for d di
							(vl-catch-all-apply 'vla-delete (list d))
						)
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

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


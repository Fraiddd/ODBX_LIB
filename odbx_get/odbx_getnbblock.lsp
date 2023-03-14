; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_getnbblock.lsp 1.0

	Count the number of blocks.

    Place the files, odbx_getnbblock.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_getnbblock in Autocad and choose folder.

    Drawings are not open.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2021 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_getnbblock (/ axdoc lfil dir objlst model bloc tot stot)
	(setq model (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))
		  bloc (getstring "What Block?")
		  tot 0
	)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
	  (progn
        (foreach f lfil 
			(setq stot 0)
			(if (setq axdoc (getaxdbdoc (strcat dir f)))
			  (progn
				(setq objlst '())
				; Sorting objects.
				(vlax-for obj (vla-get-modelspace axdoc)
					(and (= (vla-get-ObjectName obj) "AcDbBlockReference")
						 (or (= (vla-get-name obj) bloc)
							 (= (vla-get-effectivename obj) bloc))
						 (setq stot (+ 1 stot))
					)
				)
				(if (> stot 0)
				  (progn
					(princ (strcat "\n  " (vla-get-name axdoc)": " (itoa stot) " Blocks"))
					(setq tot (+ tot stot))
					(vlax-release-object axdoc)
				  )
				  (princ (strcat "\n  " (vla-get-name axdoc)": No Block named " bloc))
			    )
			  )
            )
        )
		(princ (strcat "\n  Total : " (itoa tot) " Blocks"))
		(textscr)
	  )
	)
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


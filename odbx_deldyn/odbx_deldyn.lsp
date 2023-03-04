; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_deldyn.lsp 1.0

    Remove dynamisms in blocks

    Place the files, odbx_deldyn.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load odbx_deldyn.lsp and odbx_fct.lsp.

    Enter odbx_deldyn in Autocad and choose folder.

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
(defun c:odbx_deldyn (/ axdoc lfil dir nom)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
        (foreach f lfil 
            (if(setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over blocks.
                (vlax-for bloc (vla-get-blocks axdoc)
					(if (and (= (vla-get-ObjectName bloc) "AcDbBlockReference")
							 (= (vla-get-IsDynamicBlock bloc) :vlax-true))
					  (progn
						 (setq nom (strcat (vla-get-effectivename bloc) "_ND"))
						 (vla-ConvertToAnonymousBlock bloc)
						 (vla-converttostaticblock bloc nom)
						 (vlax-release-object bloc)
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


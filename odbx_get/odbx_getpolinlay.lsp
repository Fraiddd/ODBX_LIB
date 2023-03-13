; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_getpolinlay.lsp 1.0

	Copy all Polylines in a layer, and paste in current dwg.

    Place the files, odbx_getpolinlay.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_getpolinlay in Autocad and choose folder.

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
(defun c:odbx_getpolinlay (/ axdoc lfil dir objlst model lay)
	(setq acobj (vlax-get-acad-object)
		  model (vla-get-modelspace (vla-get-activedocument acobj))
		  lay (getstring "What layer?")
	)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
	  (progn
        (foreach f lfil 
			(if (setq axdoc (getaxdbdoc (strcat dir f)))
			  (progn
				(setq objlst '())
				; Sorting objects.
				(vlax-for obj (vla-get-modelspace axdoc)
					(and (= (vla-get-ObjectName obj) "AcDbPolyline")
						 (= (vla-get-layer obj) lay)
						 (setq objlst (cons obj objlst))
					)
				)
				(if objlst
				  (progn
					; Copy the objects in the current drawing.
					(vla-copyobjects axdoc (vlax-safearray-fill
						(vlax-make-safearray vlax-vbobject(cons 0 (1- (length objlst))))
						objlst)
						model)
					(vlax-release-object axdoc)
				  )
			    )
			  )
            )
        )
		(vla-zoomextents acobj)
	  )
	)
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


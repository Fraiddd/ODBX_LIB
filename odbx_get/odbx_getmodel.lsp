; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_getmodel.lsp 1.0

	Copy all objects in Model space, and paste in current dwg.

    Place the files, odbx_getmodel.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_getmodel in Autocad and choose folder.

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
(defun c:odbx_getmodel (/ axdoc lfil dir objlst model)
	(setq model (vla-get-modelspace(vla-get-activedocument (vlax-get-acad-object))))
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
        (foreach f lfil 
			(if (setq axdoc (getaxdbdoc (strcat dir f)))
			  (progn
				(setq objlst '())
				(vlax-for obj (vla-get-modelspace axdoc)
					(setq objlst (cons obj objlst))			
				)
				(if objlst
				  (progn
					(vla-copyobjects axdoc (vlax-safearray-fill
												(vlax-make-safearray vlax-vbobject(cons 0 (1- (length objlst))))
												objlst)
										   model)
					(vla-saveas axdoc (strcat dir f))
					(vlax-release-object axdoc)
				  )
			  )
			)
        )
    )
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


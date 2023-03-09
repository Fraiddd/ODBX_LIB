; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_dtcloud.lsp 1.0

    Detach point Clouds from drawings contained in a folder.

    Place the files, odbx_dtcloud.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load it.

    Enter odbx_dtcloud in Autocad and choose folder.

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
(defun c:odbx_dtcloud (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
        (foreach f lfil 
			(if (setq axdoc (getaxdbdoc (strcat dir f)))
			  (progn
				; Loop over objects.
				(vlax-for obj (vla-get-modelspace axdoc)
					(if (= (vla-get-objectname obj) "AcDbPointCloudEx")
						(vla-delete obj)
					)
				)
				(vlax-for di (vla-get-dictionaries axdoc)
					(if (eq (vl-catch-all-apply 'vla-get-name (list di))
							"ACAD_POINTCLOUD_EX_DICT")
						(vlax-for d di
							(vla-delete d)
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


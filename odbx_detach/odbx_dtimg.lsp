; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_dtimg.lsp 1.0

    Detach images from drawings contained in a folder.

    Place the files, odbx_dtimg.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_dtimg in Autocad and choose folder.

    Drawings are not open.

    PLEASE NOTE, there is no going back.

    Tested on Windows 10 and Autocad 2015.

    First broadcast : 
    https://cadxp.com/topic/49580-détacher-une-image/#comment-298000

    No copyright: (!) 2021 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_dtimg (/ axdoc lfil dir)
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
					; If the object is an image.
					(if (= (vla-get-objectname obj) "AcDbRasterImage")
						; Delete it from the dictionary "ACAD_IMAGE_DICT".
						(vla-delete 
							(vla-item 
								(vla-item (vla-get-dictionaries axdoc )
										  "ACAD_IMAGE_DICT") 
								(vla-get-name obj)
							)
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


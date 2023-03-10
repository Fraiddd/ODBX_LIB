; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_dxf2dwg.lsp 1.0

    Convert dxf in dwg.

    Place the files, odbx_dxf2dwg.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load odbx_dxf2dwg.lsp and odbx_fct.lsp.

    Enter odbx_dxf2dwg in Autocad and choose folder.

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
(defun c:odbx_dxf2dwg (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dxf" 1)) 
        ; Loop over files.
        (foreach f lfil 
		  (if(setq axdoc (getaxdbdocdxf (strcat dir f)))
			(progn
				(vla-saveas axdoc (strcat dir (vl-string-subst ".dwg" ".dxf" f)))
				(vlax-release-object axdoc)
			)
		  )
        )
    )
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


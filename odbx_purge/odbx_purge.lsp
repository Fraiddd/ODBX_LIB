; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_purge.lsp 1.0

    Removes unused named references such as unused blocks or layers from the documents.

    Place the files, odbx_purge.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load odbx_purge.lsp and odbx_fct.lsp.

    Enter odbx_purge in Autocad and choose folder.

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
(defun c:odbx_purge (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
        (foreach f lfil 
			(if(setq axdoc (getaxdbdoc (strcat dir f)))
			  (progn
				(vlax-dump-object axdoc T)
				(vla-saveas axdoc (strcat dir f))
				(vlax-release-object axdoc)
			  )
			)
        )
    )
(princ)
)
;(defun purgeall ( doc / )



;)
;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


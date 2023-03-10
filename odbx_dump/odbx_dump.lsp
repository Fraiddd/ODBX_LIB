; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_dump.lsp 1.0

    To know the applicable properties and methods of ObjectDBX.

    Place the files, odbx_dump.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load it.

    Enter odbx_dump in Autocad and choose folder.

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
(defun c:odbx_dump (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
        (foreach f lfil 
            (if(setq axdoc (getaxdbdoc (strcat dir f)))
					(vlax-dump-object axdoc t)
                (vlax-release-object axdoc)
              
            )
        )
    )
(princ)
)

;�;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


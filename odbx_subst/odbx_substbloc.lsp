; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_substbloc.lsp 1.0

    Replace a block with another with the same name.

    Place the files, odbx_substbloc.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_substbloc in Autocad, the old text, the new  and choose folder.

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
(defun c:odbx_substbloc (/ acdc axdoc lfil bl)
    (setq acdc (vla-get-activedocument(vlax-get-acad-object))
          bl (findfile (strcat (getstring "Block name?") ".dwg"))
    )
        ; Choose folder.
    (if (and (setq dir (getdir)) 
              ; dwg liste.
            (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                (vla-delete (vlax-invoke (vla-get-modelspace axdoc) 'insertblock '(0.0 0.0 0.0) bl 1 1 1 0))
                (vla-saveas axdoc (strcat dir f))
                (vlax-release-object axdoc)
                )
                (princ (strcat "\n" f ": Illegible or corrupt."))
              )
         )
        (princ "\nHave you lost your way?")
    )
(princ)
)

;�;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


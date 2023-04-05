; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_dtimgnoref.lsp 1.0

    Detach images not referenced from drawings contained in a folder (in all layouts).

    Place the files, odbx_dtimgnoref.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_dtimgnoref in Autocad and choose folder.

    Drawings are not open.

    PLEASE NOTE, there is no going back.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2023 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_dtimgnoref (/ axdoc lfil dir img_fil)
        ; Choose folder.
    (if (and (setq dir (getdir)) 
              ; dwg liste.
            (setq lfil (vl-directory-files dir "*.dwg" 1))) 
        ; Loop over files.
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Loop over layouts.
                (vlax-for layout (vlax-get-property axdoc 'layouts)
                  ; Loop over objects.
                  (vlax-for obj  (vlax-get-property layout 'block)
                    ; If the object is an image and the path is valide.
                    (and (= (vla-get-objectname obj) "AcDbRasterImage")
                         (not (findfile (fullpath dir (vla-get-ImageFile obj))))
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
                )
                (vla-saveas axdoc (strcat dir f))
                (vlax-release-object axdoc)
              )
              (princ (strcat "\n" f ": Illegible or corrupt."))
            )
        )
        (princ (strcat "\nHave you lost your way?"))
    )
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fullpath (dir path)
	(setq dir (vl-string-right-trim "\\" dir))
    (if (= (vl-string-position 46 path) 0)
	  (progn
        (while (= (vl-string-position 46 (substr path 2)) 0)
            (setq dir (substr dir 1 (vl-string-position 92 dir 0 t)) path (substr path 2))
        )
        (setq path (strcat dir "\\" (substr path 3)))
	  )
    )
    path
)

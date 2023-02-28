; ANSI-Windows 1252
;|
dtimg.lsp

|;
(vl-load-com)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:dtimg (/ axdoc lf dir)
    (if (setq dir (getdir) lf (vl-directory-files dir "*.dwg" 1))
        (foreach f lf
            (vlax-for obj (vla-get-modelspace (setq axdoc (getaxdbdoc (strcat dir f))))
                (if (= (vla-get-objectname obj) "AcDbRasterImage")
                    (vla-delete 
                        (vla-item 
                            (vla-item (vla-get-dictionaries axdoc ) "ACAD_IMAGE_DICT") 
                            (vla-get-name obj)
                        )
                    ) 
                )
            )
            (vla-saveas axdoc (strcat dir f))
            (vlax-release-object axdoc)
        )
    )
(princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getdir( / shell rep)
  (setq shell (vlax-create-object "Shell.Application")
         rep (vlax-invoke shell 'browseforfolder 0 "Sélectionnez le dossier" 512 "")
  )
  (vlax-release-object shell)
  (strcat (vlax-get-property (vlax-get-property rep 'self) 'path) "\\")
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getaxdbdoc (filename / axdbdoc release)
  (setq axdbdoc
     (vlax-create-object
       (if (< (setq release (atoi (getvar "ACADVER"))) 16)
         "ObjectDBX.AxDbDocument"
         (strcat "ObjectDBX.AxDbDocument." (itoa release))
       )
     )
  )
  (if (vl-catch-all-apply 'vla-open (list axdbdoc filename))
    (not (vlax-release-object axdbdoc))
    axdbdoc
  )
)
;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


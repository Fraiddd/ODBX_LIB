; ANSI-Windows 1252
;|
    dtimg.lsp

    Detach images from drawings contained in a folder.

    Use APPLOAD to load dtimg.lsp and fct.lsp.

    Enter dtimg in Autocad and choose folder.

    Drawings are not open.

    PLEASE NOTE, there is no going back.

    first broadcast : https://cadxp.com/topic/49580-d�tacher-une-image/#comment-298000

    No copyright: (!) 2021 by Fr�d�ric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:dtimg (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files
        (foreach f lfil 
            ; Loop over objects.
            (vlax-for obj (vla-get-modelspace
                          (setq axdoc (getaxdbdoc (strcat dir f))))
                ; If the object is an image.
                (if (= (vla-get-objectname obj) "AcDbRasterImage")
                    ; Delete it from the dictionary "ACAD_IMAGE_DICT"
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
(princ)
)

;�;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_getlengpolinlay.lsp 1.0

    Get the length of Polylines in a layer.

    Place the files, odbx_getlengpolinlay.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_getlengpolinlay in Autocad and choose folder.

    Drawings are not open.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2021 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:odbx_getlengpolinlay (/ axdoc lfil dir lay tot stot)
    (setq lay (getstring "What layer?")
          tot 0
    )
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
      (progn
        (foreach f lfil 
            (setq stot 0)
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                ; Sorting objects.
                (vlax-for obj (vla-get-modelspace axdoc)
                    (and (= (vla-get-ObjectName obj) "AcDbPolyline")
                         (= (vla-get-layer obj) lay)
                         (setq stot (+ stot (vla-get-length obj)))
                    )
                )
                (if (> stot 0)
                  (progn
                    (princ (strcat "\n  " (vla-get-name axdoc)": " (rtos stot)))
                    (setq tot (+ tot stot))
                    (vlax-release-object axdoc)
                  )
                  (princ (strcat "\n  " (vla-get-name axdoc)": No Polylines"))
                )
              )
            )
        )
        (princ (strcat "\n  Total length : " (rtos tot)))
        (textscr)
      )
    )
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


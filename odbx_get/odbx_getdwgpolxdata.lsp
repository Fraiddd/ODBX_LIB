; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_getdwgpolxdata.lsp 1.0

    returns the list of DWGs that contains a polyline with XDATA.

    Place the files, odbx_getdwgpolxdata.lsp and odbx_fct.lsp, in an Autocad approved folder.

    Use APPLOAD to load them.

    Enter odbx_getdwgpolxdata in Autocad and choose folder.

    Drawings are not open.

    Tested on Windows 10 and Autocad 2015.

    No copyright: (!) 2021 by Frédéric Coulon.
    No license: Do with it what you want.

|;
;Dependencies
(vl-load-com)
;(load "fct.lsp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
(defun c:odbx_getdwgpolxdata (/ axdoc lfil dir apli val)
    (setq apli (getstring "What API")
           val (getstring "What Value")
    )
        ; Choose folder.
    (if (setq dir (getdir) 
              ; dwg liste.
              lfil (vl-directory-files dir "*.dwg" 1)) 
        ; Loop over files.
      (progn
        (foreach f lfil 
            (if (setq axdoc (getaxdbdoc (strcat dir f)))
              (progn
                (vlax-for obj (vla-get-modelspace axdoc)
                    (vla-GetXData obj apli 'xtypeOut 'xdataOut)
                    (if (and xdataOut
                             (= (vla-get-objectname obj) "AcDbPolyline")
                             (setq lstData (mapcar 'vlax-variant-value (vlax-safearray->list xdataOut))) 
                             (wcmatch (cadr lstData) val)
                        )
                        (setq ldwg (cons (vla-get-name axdoc) ldwg))
                    )               
                )
                (vlax-release-object axdoc)
              )
            )
        )
        (if ldwg
          (progn
            (foreach d ldwg
                (princ (strcat "\n" d))
            )
            (textscr)
          )
          (princ "\nNo files found." )
        )
      )
    )
(princ)
)

;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


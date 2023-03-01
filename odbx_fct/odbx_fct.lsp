; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_fct.lsp



    Tested on Windows 10 and Autocad 2015.

    :No copyright: (!) 2021 by Frédéric Coulon.
    :No license: Do with it what you want.
|;
; Dependencies
(vl-load-com)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

(defun getdir( / shell rep)
  (setq shell (vlax-create-object "Shell.Application")
         rep (vlax-invoke shell 
                          'browseforfolder
                          0
                          "Choose folder"
                          512
                          ""
              )
  )
  (vlax-release-object shell)
  (strcat (vlax-get-property (vlax-get-property rep 'self) 'path) "\\")
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


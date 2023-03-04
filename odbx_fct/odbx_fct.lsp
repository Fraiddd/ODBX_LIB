; ANSI-Windows 1252
; Autolisp, Visual Lisp
;|
    odbx_fct.lsp



    Tested on Windows 10 and Autocad 2015.

    :No copyright: (!) 2021 by Fr?d?ric Coulon.
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
;é;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getaxdbdocdxf (filename / axdbdoc release)
  (setq axdbdoc
     (vlax-create-object
       (if (< (setq release (atoi (getvar "ACADVER"))) 16)
         "ObjectDBX.AxDbDocument"
         (strcat "ObjectDBX.AxDbDocument." (itoa release))
       )
     )
  )
  (vlax-invoke-method axdbdoc 'DxfIn filename)
)

;;;wcmember
;;;Idem que member mais accepte les caractères génériques
;;;dans le texte(str) et dans la liste de textes(liste)
;;;la liste peu etre des listes imbriquées (récursif)
;;;et contenir autre chose que des textes
;;;Retourne T ou nil
(defun wcmember ( str liste / ret)
 (foreach item liste
    (if (null ret)
        (if (= (type item) 'LIST)
            (setq ret (imp-wcmember str item))
            (if (= (type item) 'STR)
                (if (or (wcmatch str item)(wcmatch item str))
                    (setq ret T)
                )
            )
        )
    )
 )
 ret
)
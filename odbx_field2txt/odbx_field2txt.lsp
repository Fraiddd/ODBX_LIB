;;;field2txt Conversion des champs en textes
;;;Supprime les champs et les remplace par leurs valeurs
;;;acdc, (vla-get-activedocument (vlax-get-acad-object)) ou ObjectDBX
;;;tapper f2t pour traiter le dessin courant ou f2tindir pour traiter un dossier
;;;Converti les Textes, Mtextes, repères, repères multiples, cotations, Attributs et tableaux
;;;dans chaques présentations et les blocks
(defun field2txt ( acdc / delfield getconstantatt)
    (defun delfield (ob / objname objlay lays dic ind atts lconst ctc ctr)
        (setq objname (vla-get-objectname ob) 
              objlay (vla-get-layer ob) 
              lays (vla-get-layers acdc)
        )
        (and (= (vla-get-freeze (vla-item lays objlay)) :vlax-false)
             (= (vla-get-lock (vla-item lays objlay)) :vlax-false)
             ;(not (member objlay '("0" "EXCLU")));option d'exclusion de calques
            (progn
            (and (wcmatch objname "*Text,AcDbMLeader");Texte, Mtextes, repères et repères multiples
                 (vl-catch-all-apply 'vla-item (list (vla-getextensiondictionary ob) "ACAD_FIELD")) 
                 (setq ind (vla-get-textstring ob))
                 (progn
                    (vla-put-textstring ob " ")
                    (vla-put-textstring ob ind)
                 )
            )
            (and (wcmatch objname "*Dimension");Cotations
                 (vl-catch-all-apply 'vla-item (list (vla-getextensiondictionary ob) "ACAD_FIELD")) 
                 (setq ind (vla-get-textoverride ob))
                 (progn
                    (vla-put-textoverride ob " ")
                    (vla-put-textoverride ob ind)
                 )
            )
            (and (eq objname "AcDbBlockReference");Attributs
                 (setq atts (vlax-invoke ob 'GetAttributes) lconst (getconstantatt ob))
                 (foreach att atts
                    (and (vl-catch-all-apply 'vla-item (list (vla-getextensiondictionary att) "ACAD_FIELD"))
                         (not (member (vla-get-TagString att) lconst))
                         (setq ind (vla-get-textstring att))
                         (progn
                            (vla-put-textstring att " ")
                            (vla-put-textstring att ind)
                         )
                     )
                 )
            )
            (and (eq objname "AcDbTable");Tableaux
                 (vl-catch-all-apply 'vla-item (list (vla-getextensiondictionary ob) "ACAD_FIELD"))
				 
                 (setq ctr 0 ctc 0 )
                 (while (< ctr (vla-get-rows ob)) 
                    (while (< ctc (vla-get-columns ob))
                        (and (/= (vla-GetCellState ob ctr ctc) 1)
                             (/= (vla-GetCellState ob ctr ctc) 17)
                             (setq ind (vlax-invoke ob 'getcellvalue ctr ctc))
                             (progn
                                (vlax-invoke ob 'setcellvalue ctr ctc " ")
                                (vlax-invoke ob 'setcellvalue ctr ctc ind)
                             )
                        )
                        (setq ctc (1+ ctc))
                    )
                    (setq ctc 0 ctr (1+ ctr))
                 )
				 
            )
          )
        )
    );fin delfield
    
    ;;;getconstantatt
    ;;;bl, vla objet (block) 
    ;;;Retourne la liste des étiquettes des attributs constants
    (defun getconstantatt ( bl / lc)
        (setq lc '())
        (vlax-for bls  (vla-get-blocks acdc)
            (if (eq (vlax-get bls 'Name)(vlax-get bl 'Name))
                (vlax-for obj bls
                    (and (= (vla-get-ObjectName obj) "AcDbAttributeDefinition")
                         (= (vla-get-Constant obj) :vlax-true)
                         (setq lc (cons (vla-get-TagString obj) lc))
                    )
                )
            )
        )
        lc 
    )  
    ;Chaque présentations
    (vlax-for layout  (vlax-get-property acdc 'layouts)
        (vlax-for obj  (vlax-get-property layout 'block)
                (delfield obj)
        )
    )
    ;Définitions de blocks
	
    (vlax-for bl  (vla-get-blocks acdc)
        (and (= (vla-get-islayout bl) :vlax-false)
             (= (vla-get-IsXRef bl) :vlax-false)
             (= (vla-get-IsDynamicBlock bl) :vlax-false)
			 (not (wcmatch (vla-get-name bl) "`*T*"))
             (vlax-for obj  bl 
                    (delfield obj)
             )
        )
    )
);fin field2txt
;Commande pour dessin courant
(defun c:f2t (/ ac) (field2txt (setq ac (vla-get-activedocument (vlax-get-acad-object)))) (vla-Regen ac acAllViewports)(princ))
;Commande pour dossier (non récursif)
(defun c:f2tindir ( / dir lf axdbdoc) 
    (and (setq dir (getdir))
         (setq lf (vl-directory-files dir "*.dwg" 1))
         (foreach f lf
            (if (setq axdbdoc (gc:getaxdbdoc (strcat dir f)))
                (field2txt axdbdoc)
            )
            (vla-saveas axdbdoc (strcat dir f))
            (vlax-release-object axdbdoc)
         )
    )
    (princ)
)

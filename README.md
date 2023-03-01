# ODBX_LIB

[ObjectDBX](https://help.autodesk.com/view/OARX/2019/FRA/?guid=GUID-FF60A11B-1169-483C-9A65-85203B3A1440) allows you to create your own 'ObjectDBX Host Application' 
a standalone application that can load and manipulate drawings.

This is perfect for batch processing dwgs.

The function that retrieves the ObjectDBX :

```
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

```
Principle of use :

```
(defun c:<foo> (/ axdoc lfil dir)
    (if (setq dir (getdir)
              lfil (vl-directory-files dir "*.dwg" 1)) 
        (foreach f lfil 
          (setq axdoc (getaxdbdoc (strcat dir f)))
          (<dofoo> axdoc)
          (vla-saveas axdoc (strcat dir f))
          (vlax-release-object axdoc)
        )
    )
(princ)
)
```



## License

  No license

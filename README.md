# ODBX_LIB

ObjectDBX allows you to create your own 'ObjectDBX Host Application' 
a standalone app that can load and manipulate drawings.

this is perfect for batch processing dwgs.

The function that retrieves the ObjectDBX

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




## License

  No license

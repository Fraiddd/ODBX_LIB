(defun _OdbxReport ( filelist reportname overwrite foo / handle document result )

    ;;==================================================================
    ;;
    ;;  Written by Michael Puckett
    ;;
    ;;------------------------------------------------------------------
    ;;
    ;;  In short this function is a convenience wrapper. For a given
    ;;  filelist, reportname, overwrite toggle and arbitrary function
    ;;  'Foo' it will, if possible, cycle through all of the drawings in
    ;;  filelist and apply function 'Foo to said drawings.
    ;;
    ;;  Arguments:
    ;;
    ;;      filelist   : A list of path qualified files.
    ;;
    ;;      reportname : A path qualified file which will be opened for
    ;;                   output, writing over any original contents if
    ;;                   overwrite argument is non nil, otherwise
    ;;                   appending new data to existing.
    ;;
    ;;      overwrite  : As noted, indicates whther the report is
    ;;                   overwritten or appended.
    ;;
    ;;      foo        : Arbitrary function which must have this
    ;;                   signature:
    ;;
    ;;                   (defun foo ( docname document handle ) ... )
    ;;
    ;;                    Where:
    ;;
    ;;                        docname :  A string, the name of the
    ;;                                   document.
    ;;
    ;;                        document : An objectdbx document.
    ;;
    ;;                        handle   : A file handle opened for
    ;;                                   output.
    ;;
    ;;  For example, 'Foo' might be as simple as:
    ;;
    ;;      (lambda ( docname document handle )
    ;;          (princ
    ;;              (strcat
    ;;                  docname
    ;;                  " has "
    ;;                  (itoa
    ;;                      (vlax-get
    ;;                          (vlax-get
    ;;                              document
    ;;                             'RegisteredApplications
    ;;                          )
    ;;                         'Count
    ;;                      )
    ;;                  )
    ;;                  " appid(s).\n"
    ;;              )
    ;;              handle
    ;;          )
    ;;      )
    ;;
    ;;  What 'Foo' actually does with the objectdbx document or the
    ;;  handle this function cares not, its sole responsibility is to:
    ;;
    ;;      1.  Open the report file for output, either overwrite or
    ;;          append.
    ;;
    ;;      2.  Cycle through all files:
    ;;
    ;;          2.1 Open the file via objectdbx.
    ;;
    ;;          2.2 Pass document etc. to function 'Foo'.
    ;;
    ;;          2.3 Close the objectdbx file.
    ;;
    ;;      3. Close the report file.
    ;;
    ;;  reporting any errors thrown trying to open the report file,
    ;;  opening files via objectdbx, or unhandled errors thrown by
    ;;  function 'Foo'. Typically 'Foo' will interogate the objectdbx
    ;;  document and write data to the handle.
    ;;
    ;;  "But" you say, "it seems redundant, passing the document name
    ;;  when one could just use (vla-get-name document)".
    ;;
    ;;  Ahhhh, but if a temporary copy of the document is created by
    ;;  the (_OdbxOpen ...) function the name reported will be wrong. In
    ;;  other words, if 'Foo' needs to report the original document name
    ;;  it should use the docname argument rather than querying the
    ;;  document for its name, ergo the docname requirement. If the
    ;;  actual document name is desired you can use the afore mentioned
    ;;  vla-get-name function. If necessary you can use the supplied
    ;;  function _OdbxIsTempCopy function to determine if the document
    ;;  is not the original.
    ;;
    ;;  What's the point of all this again?
    ;;
    ;;  Typically function 'Foo' will interogate the document and write
    ;;  information to the data file represented by the handle. Could be
    ;;  block attribute data, could be some other rivoting data like
    ;;  AutoPlant component IDs, who knows. This function provides easy
    ;;  access to previous authored functions, like the _OdbxOpen and
    ;;  _OdbxClose functions to make easy the frequent exercise of using
    ;;  ObjectDBX to interogate multiple files. No point in penning the
    ;;  same scafolding again and again.
    ;;
    ;;==================================================================

    (cond
        (   (setq handle (open reportname (if overwrite "w" "a")))

            (foreach docname filelist

                (cond

                    (   (setq document (_OdbxOpen docname t))

                        (if
                            (vl-catch-all-error-p
                                (setq result
                                    (vl-catch-all-apply
                                       '(lambda ( )
                                            (foo
                                                docname
                                                document
                                                handle
                                            )
                                        )
                                    )
                                )
                            )

                            (princ
                                (strcat
                                    "(Foo docname document handle)"
                                    " threw this error: <"
                                    (vl-catch-all-error-message result)
                                    ">\n"
                                )
                            )

                        )

                        (_OdbxClose document)
                    )

                    (   (princ
                            (strcat
                                "Could not open <"
                                docname
                                "> with ObjectDBX.\n"
                            )
                        )
                    )
                )
            )

            (close handle)

        )

        (   (princ
                (strcat
                    "Could not open <"
                    reportname
                    "> for output.\n"
                )
            )
        )
    )
)
(defun c:Example ( )

    (_OdbxReport

        ;;  filelist

       '(
            "x:\\SomePath\\SomeName1.dwg"
            "x:\\SomePath\\SomeName2.dwg"
            "x:\\SomePath\\SomeName3.dwg"
        )

        ;;  reportname

        "c:\\MyReportName.txt"

        ;;  overwrite

        t

        ;;  foo

        (lambda ( docname document handle )
            (princ
                (strcat
                    docname
                    " has "
                    (itoa
                        (vlax-get
                            (vlax-get
                                document
                               'RegisteredApplications
                            )
                           'Count
                        )
                    )
                    " appid(s).\n"
                )
                handle
            )
        )
    )

    (princ)

)
(defun _OdbxOpen ( drawingname tempflag / foo exists odbxdoc tempfile result )

    ;;==================================================================
    ;;   
    ;;  Written by Michael Puckett
    ;;
    ;;------------------------------------------------------------------
    ;;
    ;;  Open the document via ObjectDBX if possible (trap any errors).
    ;;
    ;;  If the file cannot be opened directly AND the tempflag is non
    ;;  nil try to open a temporary copy (flagging it as a copy).
    ;;
    ;;==================================================================

    (cond

        (   (and

                (defun foo ( odbxdoc drawingname )
                    (null
                        (vl-catch-all-error-p
                            (vl-catch-all-apply
                               '(lambda ( )
                                    (vla-open
                                        odbxdoc
                                        drawingname
                                    )
                                )
                            )
                        )
                    )
                )

                (setq exists (_Exists drawingname))

                (setq odbxdoc (_OdbxGetInterface))

                (foo odbxdoc drawingname)

            )

            ;;  File opened no problem.

            (setq result odbxdoc)

        )

        (
            (and

                exists

                odbxdoc

                ;;  Assumption: File exists in a read-only directory,
                ;;  (can't make associated dwl file) try make and use
                ;;  a temporary copy.

                (setq tempfile (_MakeTempFileCopy drawingname))

                (foo odbxdoc tempfile)

            )

            ;;  Flag the file as being a temp by adding a main dict
            ;;  entry named "OdbxTempCopy".
            ;;
            ;;  See companion functions --
            ;;
            ;;      _OdbxIsTempCopy
            ;;
            ;;      _OdbxDeleteIfTempCopy

            (vl-catch-all-apply
               '(lambda ( )
                    (vla-add
                        (vla-get-dictionaries odbxdoc)
                        "OdbxTempCopy"
                    )
                )
            )

            (setq result odbxdoc)

        )

        (   odbxdoc

            (vlax-release-object odbxdoc)

        )

    )

    result

)
(defun _OdbxClose ( document / filename )

    ;;==================================================================
    ;;   
    ;;  Written by Michael Puckett
    ;;
    ;;------------------------------------------------------------------
    ;;
    ;;  Close the objectdbx document. If it was a temporary copy made by
    ;;  _OdbxOpen try to delete it.
    ;;
    ;;  See companion functions --
    ;;
    ;;      _OdbxOpen
    ;;
    ;;      _OdbxIsTempCopy
    ;;
    ;;==================================================================
   
    (if (_OdbxIsTempCopy document)
        (setq filename (vla-get-name document))
    )

    (vl-catch-all-apply
       '(lambda ( )
            (vlax-release-object document)
        )
    )

    (if filename
        (vl-catch-all-apply
           '(lambda ( )
                (vl-file-delete filename)
            )
        )
    )

    (princ)

)
(defun _OdbxGetInterface ( / version )

    ;;==================================================================
    ;;   
    ;;  Written by Michael Puckett
    ;;
    ;;------------------------------------------------------------------
    ;;
    ;;  If possible create an instance of the ObjectDBX interface.
    ;;
    ;;  If I recall correctly Luis Esquivel helped me refine this way
    ;;  back in the day on the Autodesk forums. Others too have
    ;;  contributed to the collective objectdbx knowledge, folks like
    ;;  Tony Tanzillo, who was the first to publically share any info
    ;;  about said topic and who we are all indebted to.
    ;;
    ;;==================================================================

    (if (_OdbxGetCLSID)
        (vla-getinterfaceobject
            (vlax-get-acad-object)
            (apply 'strcat
                (cons "ObjectDBX.AxDbDocument"
                    (if (/= 15 (setq version (atoi (getvar "acadver"))))
                        (list "." (itoa version))
                    )
                )
            )
        )
    )
)
(defun _OdbxGetCLSID ( / key version dll )

    ;;==================================================================
    ;;   
    ;;  Written by Michael Puckett
    ;;
    ;;------------------------------------------------------------------
    ;;
    ;;  Get the ObjectDBX CLSID so callers may attemp to create an
    ;;  objectdbx interface. If necessary register the dll (was required
    ;;  for early versions of AutoCAD, like 2000 IIRC.
    ;;
    ;;  If I recall correctly Luis Esquivel helped me refine this way
    ;;  back in the day on the Autodesk forums. Others too have
    ;;  contributed to the collective objectdbx knowledge, folks like
    ;;  Tony Tanzillo, who was the first to publically share any info
    ;;  about said topic and who we are all indebted to.
    ;;
    ;;==================================================================

    (cond
        (   (vl-registry-read
                (setq key
                    (strcat "HKEY_CLASSES_ROOT\\ObjectDBX.AxDbDocument"
                        (if (eq 15 (setq version (atoi (getvar "acadver"))))
                            "\\CLSID"
                            (strcat "." (itoa version) "\\CLSID")
                        )
                    )
                )
            )
        )
        (   (and
                (setq dll
                    (findfile
                        (strcat
                            "AxDb"
                            (itoa version)
                            ".dll"
                        )
                    )
                )
                (_RegSvr32 dll)
            )
            (vl-registry-read key)
        )
    )
)
(defun _OdbxIsTempCopy ( document / result )

    ;;==================================================================
    ;;   
    ;;  Written by Michael Puckett
    ;;
    ;;------------------------------------------------------------------
    ;;
    ;;  Determine if the document is a temporary copy that had been made
    ;;  via the _OdbxOpen function.
    ;;
    ;;  See companion functions --
    ;;
    ;;      _OdbxOpen
    ;;
    ;;      _OdbxClose
    ;;
    ;;==================================================================

    (vl-catch-all-apply
        '(lambda ( )
            (setq result
                (not
                    (null
                        (vla-item
                            (vla-get-dictionaries document)
                            "OdbxTempCopy"
                        )
                    )
                )
            )
        )
    )

    result

)
(defun _RegSvr32 ( dll / cmd path match )

    ;;==================================================================
    ;;   
    ;;  Written by Michael Puckett
    ;;
    ;;------------------------------------------------------------------
    ;;
    ;;  If possible register the specified dll.
    ;;
    ;;  If I recall correctly Luis Esquivel helped me refine this way
    ;;  back in the day on the Autodesk forums.
    ;;
    ;;==================================================================

    (vl-some
       '(lambda (x) (startapp x (strcat "\"" dll "\" /s")))
        (list
            (setq cmd "regsvr32.exe")
            (strcat
                (setq path (getenv "WinDir"))
                "\\System\\"
                cmd
            )
            (strcat path "\\System32\\" cmd)
        )
    )

    (setq match
        (strcat
            (strcase (vl-filename-base dll))
            "`.*"
        )
    )

    (vl-some
       '(lambda (x) (wcmatch (strcase x) match))
        (vl-registry-descendents "HKEY_CLASSES_ROOT")
    )

)
(defun _MakeTempFileCopy ( filename / result )

    ;;==================================================================
    ;;
    ;;  Written by Michael Puckett
    ;;
    ;;------------------------------------------------------------------
    ;;
    ;;  If possible make a copy of the specified file in the temp
    ;;  folder.
    ;;
    ;;==================================================================

    (if
        (and
            (findfile filename)
            (vl-file-copy
                filename
                (setq result
                    (vl-filename-mktemp
                        nil
                        nil
                        (vl-filename-base filename)
                    )
                )
                nil
            )
        )
        result
    )
)
(defun _Exists ( filename / handle )

    ;;==================================================================
    ;;
    ;;  Written by Michael Puckett
    ;;
    ;;------------------------------------------------------------------
    ;;
    ;;  Return t if the file exists. Note that this differs from
    ;;  findfile function which will search the AutoCAD support path.
    ;;  This function merely reports whether a file exists as expressed.
    ;;
    ;;==================================================================

    (and
        (setq handle (open filename "r"))
        (null (close handle))
    )
)
# ObjectDBX

![](./illu/odbx.png)


[ObjectDBX](https://help.autodesk.com/view/OARX/2019/FRA/?guid=GUID-FF60A11B-1169-483C-9A65-85203B3A1440) allows you to create your own 'ObjectDBX Host Application' a standalone application that can load and manipulate drawings.
ObjectDBX is a subset of ObjectARX and a C++ object‐oriented API for manipulating AutoCAD and its related objects, collections, properties, methods.
This is perfect for batch processing of dwgs, especially for looking up information. Editing drawings is trickier because it' limited.

    - No access to System Variables (getvar ...)

    - No Selection sets (ssget ...)

    - No ent fonctions (entmod ...)

    - No Application Methodes (vla-zoomextents ...)

  

### The function in Visual-Lisp that retrieves the ObjectDBX :

    - Argument: String, The complet path of the dwg.
    - Return: a VLA object, drawing object

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
### Principle of use :

    - Need getdir function in odbx_fct.lsp

```
(defun c:<foo> (/ axdoc lfil dir)
        ; Choose folder.
    (if (setq dir (getdir)
              lfil (vl-directory-files dir "*.dwg" 1)) 
        (foreach f lfil 
          (if (setq axdoc (getaxdbdoc (strcat dir f)))
            (progn
              ; This is where you do what you want.
              (<dofoo> axdoc)
              ; If you modify the document.
              (vla-saveas axdoc (strcat dir f))
              ; Releases a drawing object
              (vlax-release-object axdoc)
            )
          )
        )
    )
(princ)
)
```

### Dump ObjectDBX

With ``` (vlax-dump-object axdoc t) ``` , you know the applicable properties and methods ObjectDBX.


```
; IAxDbDocument: IAxDbDocument Interface
; Property values:
;   Application (RO) = Exception occurred
;   Blocks (RO) = #<VLA-OBJECT IAcadBlocks 0000016a1a216918>
;   Database (RO) = #<VLA-OBJECT IAcadDatabase 0000016a2b9483d8>
;   Dictionaries (RO) = #<VLA-OBJECT IAcadDictionaries 0000016a1a2167f8>
;   DimStyles (RO) = #<VLA-OBJECT IAcadDimStyles 0000016a1a215cb8>
;   ElevationModelSpace = 0.0
;   ElevationPaperSpace = 0.0
;   FileDependencies (RO) = #<VLA-OBJECT IAcadFileDependencies 0000016a29b20728>
;   Groups (RO) = #<VLA-OBJECT IAcadGroups 0000016a1a2169a8>
;   Layers (RO) = #<VLA-OBJECT IAcadLayers 0000016a1a216ac8>
;   Layouts (RO) = #<VLA-OBJECT IAcadLayouts 0000016a1a2172a8>
;   Limits = (0.0 0.0 420.0 297.0)
;   Linetypes (RO) = #<VLA-OBJECT IAcadLineTypes 0000016a1a216d98>
;   Materials (RO) = #<VLA-OBJECT IAcadMaterials 0000016a1a2173c8>
;   ModelSpace (RO) = #<VLA-OBJECT IAcadModelSpace 0000016a29c2d378>
;   Name = "C:\\Data\\TMP\\dwg\\test.dwg"
;   PaperSpace (RO) = #<VLA-OBJECT IAcadPaperSpace 0000016a29c2c658>
;   PlotConfigurations (RO) = #<VLA-OBJECT IAcadPlotConfigurations 0000016a1a2186e8>
;   Preferences (RO) = #<VLA-OBJECT IAcadDatabasePreferences 0000016a29b206a8>
;   RegisteredApplications (RO) = #<VLA-OBJECT IAcadRegisteredApplications 0000016a1a217698>
;   SectionManager (RO) = Exception occurred
;   SummaryInfo (RO) = #<VLA-OBJECT IAcadSummaryInfo 0000016a2b70fe08>
;   TextStyles (RO) = #<VLA-OBJECT IAcadTextStyles 0000016a1a2184a8>
;   UserCoordinateSystems (RO) = #<VLA-OBJECT IAcadUCSs 0000016a1a218268>
;   Viewports (RO) = #<VLA-OBJECT IAcadViewports 0000016a1a217728>
;   Views (RO) = #<VLA-OBJECT IAcadViews 0000016a1a217b18>
; Methods supported:
;   CopyObjects (3)
;   DxfIn (2)
;   DxfOut (3)
;   HandleToObject (1)
;   ObjectIdToObject (1)
;   Open (2)
;   Save ()
;   SaveAs (2)

```
You can see that an exception has occurred at Application and SectionManager.

### Examples of use
  
    - odbx_dtimg 

    - odbx_purge





### Root

  The Visual LISP Devepors Bible - 2011 Edition Chapter 14 By David M.Stein

  Special thanks for Patrick35, Gile and Lee Mac.

   - http://www.theswamp.org/

   - https://cadxp.com/

  
# ObjectDBX

![](./illu/odbx.png)


[ObjectDBX](https://help.autodesk.com/view/OARX/2019/FRA/?guid=GUID-FF60A11B-1169-483C-9A65-85203B3A1440) allows you to create your own 'ObjectDBX Host Application' a standalone application that can load and manipulate drawings.
ObjectDBX is a subset of ObjectARX and a C++ object‐oriented API for manipulating AutoCAD and its related objects, collections, properties, methods.
This is perfect for batch processing of dwgs, especially for looking up information. Editing drawings is trickier because it's limited, using [accoreconsole.exe](https://github.com/Fraiddd/ACCORE) is complementary.

    - No access to System Variables (getvar ...)

    - No Selection sets (ssget ...)

    - No ent fonctions (entmod ...)

    - No Application Methodes (vla-zoomextents ...)

  

### The function in Autolisp/Visual-Lisp that retrieves the ObjectDBX :

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

Need getdir function in odbx_fct.lsp

```
(defun c:<foo> (/ axdoc lfil dir)
        ; Choose folder.
    (if (and (setq dir (getdir))
             (setq  lfil (vl-directory-files dir "*.dwg" 1))) 
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

There are far fewer Methods supported than with an open document.

You can see that an exception has occurred at Application and SectionManager.

### Examples of use

I remind you that there is no possible return, and that it is advisable to save your work beforehand.

- Geters

  [odbx_getmodel](odbx_get/odbx_getmodel.lsp) , Copy all objects in Model space, and paste in current dwg.

  [odbx_getpolinlay](./odbx_get/odbx_getpolinlay.lsp), Copy all Polylines in a layer, and paste in current dwg.

  [odbx_getnbblock](./odbx_get/odbx_getnbblock.lsp), Count the number of blocks.

  [odbx_getdwgpolxdata](./odbx_get/odbx_getdwgpolxdata.lsp), Returns the list of DWGs that contains a polyline with XDATA.

  [odbx_getlengpolinlay](./odbx_get/odbx_getlengpolinlay.lsp), Get the length of Polylines in a layer.

  [odbx_getnamelayout](./odbx_get/odbx_getnamelayout.lsp), Get the name of layouts.

  [odbx_getlistlayer](./odbx_get/odbx_getlistlayer.lsp), Get the name of layers.

  [odbx_odbx_getcustominfo](./odbx_get/odbx_getcustominfo.lsp), Get custom infos.

- Senders

  [odbx_sendlayers](./odbx_send/odbx_sendlayers.lsp), Sends the layers of a current drawing to a drawing folder.

  [odbx_sendsel](./odbx_send/odbx_sendlayers.lsp), Sends the selection to a drawing folder.

  [odbx_sendlinetype](./odbx_send/odbx_sendlinetype.lsp), Sends the line types to a drawing folder.

  [odbx_sendTextStyle](./odbx_send/odbx_sendTextStyle.lsp), Sends the text styles to a drawing folder.

  [odbx_sendviews](./odbx_send/odbx_sendviews.lsp), Sends the views to a drawing folder.

  [odbx_senducs](./odbx_send/odbx_sendviews.lsp), Sends the UCS to a drawing folder.


- Seters

  [odbx_setlayerfreeze](./odbx_set/odbx_setlayerfreeze.lsp), Freeze all layer (not the current layer).

  [odbx_setlayerlock](./odbx_set/odbx_setlayerlock.lsp), All layers are locked.

  [odbx_setlayeroff](./odbx_set/odbx_setlayeroff.lsp), All layers off.

  [odbx_setlayeron](./odbx_set/odbx_setlayeron.lsp), All layers on.

  [odbx_setlayerthaw](./odbx_set/odbx_setlayerthaw.lsp), All layers are thawed.

  [odbx_setlayerunlock](./odbx_set/odbx_setlayerunlock.lsp), All layers are unlocked.

- Substitutes

  [odbx_substtext](odbx_subst/odbx_substtext.lsp) , Replace a text in a TEXT in the model space.

  [odbx_substmtext](odbx_subst/odbx_substmtext.lsp) , Replace a text in a MTEXT in the model space.

  [odbx_substmlead](odbx_subst/odbx_substmlead.lsp) , Replace a text in a MLEADER in the model space.

  [odbx_substatt](odbx_subst/odbx_substatt.lsp) , Replace a text in a ATTRIBUT in the model space.

- Deletes

  [odbx_delobjinlay](odbx_del/odbx_delobjinlay.lsp) , Delete all objects in a layer and purge layers.

  [odbx_delgroup](odbx_del/odbx_delgroup.lsp) , Delete all groups (not objects in groups).

  [odbx_delfilterlayer](odbx_del/odbx_delfilterlayer.lsp) , Delete filter and state layers.

- Detachs

  [odbx_dtcloud](odbx_detach/odbx_dtcloud.lsp) , Detach point Clouds  in the model space.

  [odbx_dtdgn](odbx_detach/odbx_dtdgn.lsp) , Detach .dgn  in the model space.

  [odbx_dtdwf](odbx_detach/odbx_dtdwf.lsp) , Detach .dwf  in the model space.

  [odbx_dtimg](odbx_detach/odbx_dtimg.lsp) , Detach images  in the model space.

  [odbx_dtimgnoref](odbx_detach/odbx_dtimgnoref.lsp) , Detach images not referenced from drawings contained in a folder (in all layouts).

  [odbx_dtole](odbx_detach/odbx_dtole.lsp) , Detach OLE object  in the model space.

  [odbx_dtpdf](odbx_detach/odbx_dtpdf.lsp) , Detach .pdf  in the model space.

  To detach xrefs you must use [accoreconsole.exe](https://github.com/Fraiddd/ACCORE).

- Purges

  [odbx_purgebloc](odbx_purge/odbx_purgebloc.lsp) , Purge blocks.

  [odbx_purgeDimStyle](odbx_purge/odbx_purgeDimStyle.lsp) , Purge Dimension Styles.

  [odbx_purgelayer](odbx_purge/odbx_purgelayer.lsp) , Purge layers.

  [odbx_purgelinetype](odbx_purge/odbx_purgelinetype.lsp) , Purge line types.

  [odbx_purgeMLeaderStyle](odbx_purge/odbx_purgeMLeaderStyle.lsp) , Purge MLeader Styles.

  [odbx_purgeTableStyle](odbx_purge/odbx_purgeTableStyle.lsp) , Purge Table Styles.

  [odbx_purgeTextStyle](odbx_purge/odbx_purgeTextStyle.lsp) , Purge Text Style.

  To purge properly you must use [accoreconsole.exe](https://github.com/Fraiddd/ACCORE).

### Root

  [The Visual LISP Devepors Bible - 2011 Edition Chapter 14 By David M.Stein.](./odbx_root/the-visual-lisp-developers-bible-2011-edition.pdf)

  An experience of [Michael_Puckett](odbx_root/odbx_Michael_Puckett.lsp)

  Special thanks for Patrick_35, Gile and Lee Mac.

   - http://www.lee-mac.com/odbxbase.html

   - http://www.theswamp.org/

   - https://cadxp.com/

  
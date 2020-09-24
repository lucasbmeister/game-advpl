#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class Scene

    Data aObjects
    Data oParent
    Data lActive
    Data cId
    Data nLeft
    Data nTop
    Data nHeight
    Data nWidth
    Data bLoadObjects

    Method New() Constructor
    Method GetSceneID()
    Method AddObject()
    Method GetSceneWindow()
    Method Update()
    Method Start()
    Method EndScene()
    Method SetInitCodeBlock()
    Method GetDimensions()
    Method SetActive()
    Method IsActive() 
    Method ClearScene()
    Method GetObjectsWithColliders()

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, cId, nTop, nLeft, nHeight, nWidth) Class Scene

    Static oInstance as object

    Default nLeft := 180
    Default nTop := 180
    Default nHeight := 550
    Default nWidth := 700

    oInstance := Self
    ::oParent := oWindow

    ::nLeft := nLeft
    ::nTop := nTop
    ::nHeight := nHeight
    ::nWidth := nWidth
    ::cId := cId

    ::aObjects := {}

    ::SetActive(.F.)

Return
/*
{Protheus.doc} function
descriptiondd
@author  author
@since   date
@version version
*/
Method GetSceneID() Class Scene
Return ::cId
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update(oGameManager) Class Scene
    
    Local nX as numeric

    For nX := 1 To Len(::aObjects)
        If ::IsActive()
            ::aObjects[nX]:Update(oGameManager)
        Else
            Exit
        EndIf
    Next nX

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method AddObject(oObject) Class Scene
    Aadd(::aObjects, oObject)
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Start() CLass Scene
    ::ClearScene()
    ::SetActive(.T.)
    Eval(::bLoadObjects, Self)
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method EndScene() Class Scene
    ::SetActive(.F.)
    ::ClearScene()
Return 
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetSceneWindow() Class Scene
Return ::oParent
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method SetInitCodeBlock(bBlock) Class Scene
    ::bLoadObjects := bBlock
Return
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method GetDimensions() Class Scene
Return { ::nTop, ::nLeft, ::nHeight, ::nWidth}
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method SetActive(lActive) Class Scene
    ::lActive := lActive
Return

/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method IsActive() Class Scene
Return ::lActive

/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method ClearScene() Class Scene
    AEval(::aObjects,{|x| x:HideGameObject() })
    ASize(::aObjects , 0)
Return
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method GetObjectsWithColliders() Class Scene
    Local aObjColl as array
    aObjColl := {}

    AEval(::aObjects,{|x| IIF(x:HasCollider(), AAdd(aObjColl, x), nil)})

Return aObjColl

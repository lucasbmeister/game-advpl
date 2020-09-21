#include "totvs.ch"

#DEFINE X_POS 1
#DEFINE Y_POS 2
#DEFINE HEIGHT 3
#DEFINE WIDTH 4
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
    Data nPosX
    Data nPosY
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
Method New(oWindow, cId, nPosX, nPosY, nHeight, nWidth) Class Scene

    Static oInstance as object

    Default nPosX := 180
    Default nPosY := 180
    Default nHeight := 550
    Default nWidth := 700

    oInstance := Self
    ::oParent := oWindow

    ::nPosX := nPosX
    ::nPosY := nPosY
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
Return {::nPosX, ::nPosY, ::nHeight, ::nWidth}
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
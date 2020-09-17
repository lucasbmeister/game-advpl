#include "totvs.ch"

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
    Data nTop
    Data nLeft
    Data nBottom
    Data nRight
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

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, cId, nTop, nLeft, nBottom, nRight) Class Scene

    Static oInstance as object

    Default nTop := 180
    Default nLeft := 180
    Default nBottom := 550
    Default nRight := 700

    oInstance := Self
    ::oParent := oWindow

    ::nTop := nTop
    ::nLeft := nLeft
    ::nBottom := nBottom
    ::nRight := nRight
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
Return {::nTop, ::nLeft, ::nBottom, ::nRight}
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
Method ClearScene() CLass Scene
    AEval(::aObjects,{|x| x:HideGameObject() })
    ASize(::aObjects , 0)
Return
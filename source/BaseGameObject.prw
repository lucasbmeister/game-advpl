#include "totvs.ch"

Class BaseGameObject

    Data cAssetsPath
    Data oWindow
    Data aFramesForward
    Data aFramesBackward
    Data cTag

    Method New() Constructor
    Method SetWindow()
    Method SetTag()
    Method GetTag()
    Method GetAssetsPath()
    Method LoadFrames()

EndClass

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow) Class BaseGameObject
    Local cTempPath as char

    cTempPath := GetTempPath()
    ::cAssetsPath := cTempPath + "gameadvpl\assets\

    if !Empty(oWindow)
        ::SetWindow(oWindow)
    EndIf
    
Return Self

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetWindow(oWindow) Class BaseGameObject
    ::oWindow := oWindow
Return 

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetAssetsPath(cAsset) Class BaseGameObject
Return ::cAssetsPath + cAsset

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method LoadFrames(cEntity) Class BaseGameObject
    Local cPath as char
    Local nX as numeric

    cPath := ::GetAssetsPath(cEntity + "\")

    ::aFramesForward := Directory(cPath + "forward\*.png", "A",,.F.)
    ::aFramesBackward := Directory(cPath + "backward\*.png", "A",,.F.)

    cPath :=  StrTran(cPath, "\", "/")

    For nX := 1 To Len(::aFramesForward)
        ::aFramesForward[nX] := cPath + "forward/" + ::aFramesForward[nX][1]
        ::aFramesBackward[nX] := cPath + "backward/" + ::aFramesBackward[nX][1]
    Next nX

Return 
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetTag(cTag) Class BaseGameObject
    ::cTag := cTag
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetTag() Class BaseGameObject
Return ::cTag

#include "totvs.ch"

Class BaseGameObject From LongNameClass

    Data cAssetsPath
    Data oWindow
    Data cTag
    Data oGameObject
    Data cInternalId
    Data lDestroy

    Data oAnimations

    //fisica
    Data lHasCollider

    Data nTopMargin
    Data nLeftMargin
    Data nBottomMargin
    Data nRightMargin

    Data nHalfHeight
    Data nHalfWidth

    Data nDY
    Data nDX

    Method New() Constructor
    Method SetWindow()
    Method SetTag()
    Method GetTag()
    Method GetAssetsPath()
    Method LoadFrames()
    Method SetSize()
    Method GetInternalId()
    Method GetHeight()
    Method GetWidth()

    //fisica
    Method SetColliderMargin()
    Method HasCollider()
    Method GetMidX()
    Method GetMidY()
    Method GetTop()
    Method GetLeft()
    Method GetRight()
    Method GetBottom()
    Method Destroy()
    Method ShouldDestroy()

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

    ::cInternalId := UUIDRandom()
    ::lHasCollider := .F.
    ::lDestroy := .F.
    ::nDY := 0
    ::nDX := 0

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
    Local nY as numeric
    Local aDirectory as array
    Local aAnimations as array
    Local aFramesForward as array
    Local aFramesBackward as array
    Local cTempPath as char

    ::oAnimations := JsonObject():New()

    cPath := ::GetAssetsPath(cEntity + "\animation\")

    aDirectory := Directory(cPath + "*.*", "D",,.F.)
    cTempPath := StrTran(cPath, "\", "/")
    aAnimations := {}

    If !Empty(aDirectory)

        AEval(aDirectory, { |x| IIF(x[5] == 'D', Aadd(aAnimations, x[1]), nil)}, 3)

        For nX := 1 To Len(aAnimations)

            aFramesForward := Directory(cPath + aAnimations[nX] + "\forward\*.png", "A",,.F.)
            aFramesBackward := Directory(cPath + aAnimations[nX] + "\backward\*.png", "A",,.F.)

            For nY := 1 To Len(aFramesForward)
                aFramesForward[nY] := cTempPath + aAnimations[nX] + "/forward/" + aFramesForward[nY][1]
                aFramesBackward[nY] := cTempPath + aAnimations[nX] + "/backward/" + aFramesBackward[nY][1]
            Next nY

            ::oAnimations[aAnimations[nX]] := JsonObject():New()
            ::oAnimations[aAnimations[nX]]['forward'] := aFramesForward
            ::oAnimations[aAnimations[nX]]['backward'] := aFramesBackward

        Next nX

    EndIf

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

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetColliderMargin(nTopMargin, nLeftMargin, nBottomMargin, nRightMargin) Class BaseGameObject

    If nTopMargin != Nil .and. nLeftMargin == Nil .and. nBottomMargin == Nil .and. nRightMargin == Nil

        ::nTopMargin := ::nLeftMargin := ::nBottomMargin := ::nRightMargin := nTopMargin

    ElseIf nTopMargin != Nil .and. nLeftMargin != Nil .and. nBottomMargin == Nil .and. nRightMargin == Nil

        ::nTopMargin := ::nBottomMargin := nTopMargin
        ::nLeftMargin := ::nRightMargin := nLeftMargin
        
    Else
        ::nTopMargin := nTopMargin
        ::nLeftMargin := nLeftMargin
        ::nBottomMargin := nBottomMargin
        ::nRightMargin := nRightMargin
    EndIf

    ::nHalfHeight := (::oGameObject:nHeight + ::nTopMargin + ::nBottomMargin) * 0.5
    ::nHalfWidth := (::oGameObject:nWidth + ::nLeftMargin + ::nRightMargin) * 0.5

    ::lHasCollider := .T.

Return

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HasCollider() Class BaseGameObject
Return ::lHasCollider

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetMidX() Class BaseGameObject
Return ::nHalfWidth + ::oGameObject:nLeft
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetMidY() Class BaseGameObject
Return ::nHalfHeight + ::oGameObject:nTop
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetTop() Class BaseGameObject
Return ::oGameObject:nTop + ::nTopMargin
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetLeft() Class BaseGameObject
Return ::oGameObject:nLeft + ::nLeftMargin
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetRight() Class BaseGameObject
Return ::oGameObject:nLeft + ::oGameObject:nWidth + ::nRightMargin
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetBottom() Class BaseGameObject
Return ::oGameObject:nTop + ::oGameObject:nHeight + ::nBottomMargin
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetInternalId() Class BaseGameObject
Return ::cInternalId
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Destroy() Class BaseGameObject
    ::lDestroy := .T.
Return 
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method ShouldDestroy() Class BaseGameObject
Return ::lDestroy

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetHeight() Class BaseGameObject
Return ::oGameObject:nHeight
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetWidth() Class BaseGameObject
Return ::oGameObject:nWidth


#include "totvs.ch"
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class Square From BaseGameObject

    Data lInvisible

    Method New() Constructor
    Method Update()
    Method HideGameObject() 
    Method SetInvisible()

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth) Class Square
    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self
    cStyle := "TPanel { background-color: black }"

    ::oGameObject := TPanel():New(nTop, nLeft, , oInstance:oWindow,,,,,, nWidth, nHeight)
    ::oGameObject:SetCss(cStyle)

Return Self

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update() Class Square
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HideGameObject() Class Square

   ::oGameObject:Hide()
    FreeObj(::oGameObject)

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetInvisible(lInvisible) Class Square

    Local cStyle as char

    ::lInvisible := lInvisible

    If lInvisible
        cStyle := "TPanel { background-color: black }"
    Else
        cStyle := "TPanel { opacity : 0 }"
    EndIf

    ::oGameObject:SetCss(cStyle)
Return
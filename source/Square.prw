#include "totvs.ch"
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class Square From BaseGameObject

    Method New() Constructor
    Method Update()
    Method HideGameObject() 

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, nPosX, nPosY, nHeight, nWidth) Class Square
    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self
    cStyle := "QFrame{ background-color: black }"

    ::SetSize(nWidth, nHeight)
    ::oGameObject := TPanelCss():New(nPosX, nPosY, , oInstance:oWindow,,,,,, nWidth, nHeight)
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
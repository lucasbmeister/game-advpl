#include "totvs.ch"
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class Sky From BaseGameObject

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
Method New(oWindow, nTop, nLeft, nHieght, nWidth) Class Sky
    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self
    cStyle := "TPanel { border-image: url("+StrTran(::GetAssetsPath("background.png"),"\","/")+") 0 0 0 0 stretch stretch }"

    ::oGameObject := TPanel():New(0, 0, , oInstance:oWindow,,,,,, 650, 350)
    ::oGameObject:SetCss(cStyle)
Return Self

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update() Class Sky
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HideGameObject() Class Sky

   ::oGameObject:Hide()
    FreeObj(::oGameObject)

Return

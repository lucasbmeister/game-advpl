#include "totvs.ch"
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class Ground From BaseGameObject

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
Method New(oWindow, nTop, nLeft, nHeight, nWidth ) Class Ground
    
    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self

    cStyle := "QFrame{ border-image: url("+StrTran(::GetAssetsPath("ground.png"),"\","/")+") 0 0 0 0 repeat repeat; border-style:solid; border-width:3px; border-color:#FF0000; }"

    ::oGameObject := TPanelCss():New(255, 0, , oInstance:oWindow,,,,,, 650, 50)
    ::oGameObject:SetCss(cStyle)

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update() Class Ground
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HideGameObject() Class Ground

   ::oGameObject:Hide()
    FreeObj(::oGameObject)

Return
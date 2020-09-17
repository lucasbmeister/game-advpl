#include "totvs.ch"
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class Ground From BaseGameObject

    Data oPanel

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
Method New(oWindow, nTop, nLeft, nBottom, nRight ) Class Ground
    
    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self

    cStyle := "QFrame{ border-image: url("+StrTran(::GetAssetsPath("ground.png"),"\","/")+") 0 0 0 0 repeat repeat }"

    ::oPanel := TPanelCss():New(255, 0, , oInstance:oWindow,,,,,, 650, 50)
    ::oPanel:SetCss(cStyle)

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

   ::oPanel:Hide()
    FreeObj(::oPanel)

Return
#include "totvs.ch"
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class Sky From BaseGameObject

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
Method New(oWindow, nTop, nLeft, nBottom, nRight ) Class Sky
    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self
    cStyle := "QFrame{ border-image: url("+StrTran(::GetAssetsPath("background.png"),"\","/")+") 0 0 0 0 stretch stretch }"

    ::oPanel := TPanelCss():New(0, 0, , oInstance:oWindow,,,,,, 650, 350)
    ::oPanel:SetCss(cStyle)
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

   ::oPanel:Hide()
    FreeObj(::oPanel)

Return

#include "totvs.ch"
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Class Sky From BaseGameObject

    Data oPanel

    Method New() Constructor
    Method Update()

EndClass
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method New(oWindow, nTop, nLeft, nBottom, nRight ) Class Sky
    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self

    cStyle := "QFrame{ image: url("+StrTran(::GetAssetsPath("background.png"),"\","/")+"); border-style: none }"

    ::oPanel := TPanelCss():New(0, 0, , oInstance:oWindow,,,,,, 600, 1024)
    ::oPanel:SetCss(cStyle)
Return Self

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method Update() Class Sky
Return

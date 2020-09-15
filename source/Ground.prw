#include "totvs.ch"
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Class Ground From BaseGameObject

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
Method New(oWindow, nTop, nLeft, nBottom, nRight ) Class Ground
    
    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self

    cStyle := "QFrame{ image: url("+StrTran(::GetAssetsPath("ground.png"),"\","/")+"); border-style: none }"

    ::oPanel := TPanelCss():New(300, nLeft, , oInstance:oWindow,,,,,, 100, 1024)
    ::oPanel:SetCss(cStyle)

Return
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method Update() Class Ground
Return
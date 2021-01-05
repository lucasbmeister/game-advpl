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
Method New(oWindow, nTop, nLeft, nHeight, nWidth, lFloating) Class Ground
    
    Local cStyle as char 
    Local cAsset as char

    Default lFloating := .F.

    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self
    cAsset := IIF(!lFloating, ::GetAssetsPath("environment\ground.png"), ::GetAssetsPath("environment\floating_ground.png"))

    cStyle := "TPanel { border-image: url("+StrTran(cAsset,"\","/")+") 0 stretch}"
    //cStyle := "TPanel { border: 1 solid black }"

    ::oGameObject := TPanel():New(nTop, nLeft, , oInstance:oWindow,,,,,, nWidth, nHeight)
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
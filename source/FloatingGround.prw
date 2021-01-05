#include "totvs.ch"
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class FloatingGround From BaseGameObject

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
Method New(oWindow, nTop, nLeft, nHeight, nWidth, nType) Class FloatingGround
    
    Local cStyle as char 
    Local cAsset as char

    Default lFloating := .F.

    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self
    cAsset := ::GetAssetsPath("environment\floating_ground_"+cValToChar(nType)+".png")

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
Method Update() Class FloatingGround
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HideGameObject() Class FloatingGround

   ::oGameObject:Hide()
    FreeObj(::oGameObject)

Return
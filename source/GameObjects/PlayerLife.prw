#include "totvs.ch"
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class PlayerLife From BaseGameObject

    Data oLifeText

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
Method New(oWindow, nTop, nLeft, nHeight, nWidth) Class PlayerLife
    
    Local cStyle as char 
    Local cAsset as char
    Local oFont as object

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 30
    Default nWidth := 60

    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self
    cAsset := ::GetAssetsPath("ui\heart.png")

    cStyle := "TPanel { border-image: url("+StrTran(cAsset,"\","/")+") 0 stretch}"
    //cStyle := "TPanel { border: 1 solid black }"

    ::oGameObject := TPanel():New(nTop, nLeft, , oInstance:oWindow,,,,,, nWidth - 37, nHeight - 10)

    oFont := TFont():New('Impact',,-32,.T.)

    ::oLifeText := TSay():New(nTop,nLeft + 30,{|| StrZero(100,3)},oInstance:oWindow,,oFont,,,,.T.,,,nWidth,nHeight)
    ::oGameObject:SetCss(cStyle)

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update(oGameManager) Class PlayerLife
    
    Local nLife as char

    nLife := oGameManager:GetLife()

    ::oLifeText:SetText(StrZero(nLife,3))

    ::oLifeText:MoveToTop()
    ::oGameObject:MoveToTop()
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HideGameObject() Class PlayerLife

   ::oGameObject:Hide()
    FreeObj(::oGameObject)

Return
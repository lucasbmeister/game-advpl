#include "totvs.ch"
/*
{Protheus.doc} Class Ground
Classe para objeto piso
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class Ground From BaseGameObject

    Method New() Constructor
    Method Update()
    Method HideGameObject()

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth)
Instância classe Ground
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth) Class Ground
    
    Local cStyle as char 
    Local cAsset as char

    Default lFloating := .F.

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 42
    Default nWidth := 110

    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self
    cAsset := ::GetAssetsPath("environment\ground.png")

    cStyle := "TPanel { border-image: url("+StrTran(cAsset,"\","/")+") 0 stretch}"
    //cStyle := "TPanel { border: 1 solid black }"

    ::oGameObject := TPanel():New(nTop, nLeft, , oInstance:oWindow,,,,,, nWidth, nHeight)
    ::oGameObject:SetCss(cStyle)

Return

/*
{Protheus.doc} Method Update()
Método update (sem uso por enquanto)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update() Class Ground
Return

/*
{Protheus.doc} Method HideGameObject()
Destrói objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class Ground

   ::oGameObject:Hide()
    FreeObj(::oGameObject)

Return
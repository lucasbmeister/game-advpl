#include "totvs.ch"

/*
{Protheus.doc} Class Sky 
Classe para objeto de background
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class Background From BaseGameObject

    Method New() Constructor
    Method Update()
    Method HideGameObject() 

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHieght, nWidth)
Instância classe Sky
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHieght, nWidth) Class Background
    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self
    cStyle := "TPanel { border-image: url("+StrTran(::GetAssetsPath("environment\background_green.png"),"\","/")+") 0 0 0 0 stretch stretch }"

    ::oGameObject := TPanel():New(0, 0, , oInstance:oWindow,,,,,, 650, 350)
    ::oGameObject:SetCss(cStyle)
Return Self

/*
{Protheus.doc} Method Update()
Método update (sem uso por enquanto)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update() Class Background
Return

/*
{Protheus.doc} Method HideGameObject()
Destrói objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class Background

   ::oGameObject:Hide()
   ::HideEditorCollider()
    FreeObj(::oGameObject)

Return

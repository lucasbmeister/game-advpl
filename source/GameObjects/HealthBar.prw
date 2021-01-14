#include "totvs.ch"

/*
{Protheus.doc} Class HealthBar
Classe com lógica para apresentação do status da vida do player em cima do inimigo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class HealthBar From BaseGameObject

    Data oHealthBar

    Method New() Constructor
    Method Update()
    Method HideGameObject()
    Method SetTopPosition()
    Method SetLeftPosition()
    Method UpdateLifeBar()

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth)
Instância a classe PLayerLife
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft) Class HealthBar

    Local cStyle as char

    Default nTop := 100
    Default nLeft := 150

    Static oInstance as object

    _Super:New(oWindow)

    oInstance := Self

    ::oGameObject := TPanel():New(nTop, nLeft, '' , oInstance:oWindow,,,,CLR_WHITE,CLR_GRAY, 50, 5)
    ::oGameObject:SetCss(cStyle)

    ::oHealthBar := TPanel():New(00, 00, '' , ::oGameObject,,,,CLR_RED,CLR_RED, 50, 20)
Return

/*
{Protheus.doc} Method HideGameObject()
Destrói objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class HealthBar

    ::oGameObject:Hide()
    ::oHealthBar:Hide()
    ::HideEditorCollider()
    FreeObj(::oGameObject)
    FreeObj(::oHealthBar)

Return

/*
{Protheus.doc}Method SetTopPosition(nTop) Class HealthBar
Define posição top do objeto de vida
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetTopPosition(nTop) Class HealthBar
    ::oGameObject:nTop := nTop
Return

/*
{Protheus.doc}Method SetLeftPosition(nLeft) Class HealthBar
Define posição left do objeto de vida
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetLeftPosition(nLeft) Class HealthBar
    ::oGameObject:nLeft := nLeft
Return

/*
{Protheus.doc}Method SetLeftPosition(nLeft) Class HealthBar
Define posição left do objeto de vida
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method UpdateLifeBar(nLifeSubtract, nTotal) Class HealthBar

    Local nUpdate as numeric

    nUpdate := (100 * -nLifeSubtract) / nTotal

    ::oHealthBar:nWidth -= nUpdate

Return

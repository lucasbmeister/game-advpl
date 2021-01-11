#include "totvs.ch"

/*
{Protheus.doc} Class InteractionObejct 
Classe para menu de interação
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class InteractionObejct From BaseGameObject

    Data oGame

    Method New() Constructor
    Method Update()
    Method HideGameObject() 
    Method SetupMenu()
    Method GoToMenu()

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth)
Instância classe Square
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, oGame) Class InteractionObejct

    Local cStyle as char 
    Static oInstance as object

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 050
    Default nWidth := 050

    _Super:New(oWindow)

    ::oGame := oGame

    oInstance := Self
    cStyle := "TPanel { background-color: black }"
    nTop := 0
    nLeft := 0

    ::oGameObject := TPanel():New(nTop, nLeft,'Pausado', oInstance:oWindow,,,,,, oInstance:oWindow:nWidth / 2, oInstance:oWindow:nHeight / 2)
    ::oGameObject:SetCss(cStyle)

    ::SetupMenu()

Return Self

/*
{Protheus.doc} Method Update()
Método update
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update(oGameManager) Class InteractionObejct

    Local oKeys as object

    oKeys := oGameManager:GetPressedKeys()

    If oKeys['enter']
        ::GoToMenu()
    EndIf

Return

/*
{Protheus.doc} Method HideGameObject()
Destrói objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class InteractionObejct

   ::oGameObject:Hide()
    FreeObj(::oGameObject)
    ::HideEditorCollider()

Return

/*
{Protheus.doc} Method SetupMenu() Class PausePanel
Monta botões do menu de pausa
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetupMenu() Class InteractionObejct

    Local nTop as numeric
    Local nLeft as numeric
    Local oFont48 as object
    
    oFont48 := TFont():New('Impact',, -48,.T.)

    nTop := ((::oGameObject:nHeight / 2) / 2) - 20
    nLeft := ((::oGameObject:nWidth / 2) / 2) - 160

    TSay():New(nTop, nLeft,{||'Pressione "Enter" para continuar'}, ::oGameObject,,oFont48,,,,.T.,CLR_WHITE,CLR_BLACK,400,200,,,,,,.T.)
   
Return

/*
{Protheus.doc} Method GoToMenu() Class InteractionObejct
Volta para o menu princiapl
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GoToMenu() Class InteractionObejct

    ::oGame:LoadScene('menu')
    //::HideGameObject()

Return
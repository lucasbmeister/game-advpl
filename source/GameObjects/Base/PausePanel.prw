#include "totvs.ch"

/*
{Protheus.doc} Class PausePanel 
Classe para menu de pausa
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class PausePanel From BaseGameObject

    Data oGame

    Method New() Constructor
    Method Update()
    Method HideGameObject() 
    Method SetupMenu()
    Method GoToMenu()
    Method Continue() 

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth)
Inst�ncia classe Square
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, oGame) Class PausePanel

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
    nTop := ((oInstance:oWindow:nHeight / 2) / 2) - (nHeight / 2)
    nLeft := ((oInstance:oWindow:nWidth / 2) / 2) - (nWidth / 2)

    ::oGameObject := TPanel():New(nTop, nLeft,'Pausado', oInstance:oWindow,,,,,, 50, 30)
    ::oGameObject:SetCss(cStyle)

    ::SetupMenu()

Return Self

/*
{Protheus.doc} Method Update()
M�todo update
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update(oGameManager) Class PausePanel
Return

/*
{Protheus.doc} Method HideGameObject()
Destr�i objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class PausePanel

   ::oGameObject:Hide()
    FreeObj(::oGameObject)
    ::HideEditorCollider()

Return

/*
{Protheus.doc} Method SetupMenu() Class PausePanel
Monta bot�es do menu de pausa
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetupMenu() Class PausePanel

    TButton():New( 05, 05, "Continuar",::oGameObject,{|o|oInstance:Continue()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 16, 05, "Voltar ao Menu",::oGameObject,{|o|oInstance:GoToMenu()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

Return

/*
{Protheus.doc} Method GoToMenu() Class PausePanel
Volta para o menu princiapl
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GoToMenu() Class PausePanel

    ::oGame:SetPaused(.F.)
    ::oGame:LoadScene('menu')
    ::HideGameObject()

Return

/*
{Protheus.doc} Method Continue() Class PausePanel
Resume o jogo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Continue() Class PausePanel
    ::oGame:SetPaused(.F.)
    ::HideGameObject()
Return

#include "totvs.ch"

/*
{Protheus.doc} Class PlayerScore
Classe com lógica para apresentação do status da pontuação do player em tela
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class PlayerScore From BaseGameObject

    Data oScoreText

    Method New() Constructor
    Method Update()
    Method HideGameObject()

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth)
Instância a classe PlayerScore
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth) Class PlayerScore
    
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
    cAsset := ::GetAssetsPath("ui\coin.png")

    cStyle := "TPanel { border-image: url("+StrTran(cAsset,"\","/")+") 0 stretch}"
    //cStyle := "TPanel { border: 1 solid black }"

    ::oGameObject := TPanel():New(nTop, nLeft + 40, , oInstance:oWindow,,,,,, nWidth - 45, nHeight - 12)

    oFont := TFont():New('Impact',,-32,.T.)

    ::oScoreText := TSay():New(nTop,nLeft,{|| StrZero(0,4)},oInstance:oWindow,,oFont,,,,.T.,,,nWidth,nHeight)
    ::oGameObject:SetCss(cStyle)

Return

/*
{Protheus.doc} Method Update(oGameManager)
Atualizado em cada frame, buscando dados de pontuação armazenados no GameManager
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update(oGameManager) Class PlayerScore
    
    Local nScore as char

    nScore := oGameManager:GetScore()

    ::oScoreText:SetText(StrZero(nScore,4))

    ::oScoreText:MoveToTop()
    ::oGameObject:MoveToTop()
Return

/*
{Protheus.doc} Method HideGameObject()
Destrói objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class PlayerScore

   ::oGameObject:Hide()
    FreeObj(::oGameObject)

Return
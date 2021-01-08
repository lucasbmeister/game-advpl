#include "totvs.ch"

/*
{Protheus.doc} Class FloatingGround
Classe para objetos de piso flutuantes
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class FloatingGround From BaseGameObject

    Method New() Constructor
    Method Update()
    Method HideGameObject()

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth, nType)
Instância classe FloatinGround
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth, nType) Class FloatingGround
    
    Local cStyle as char 
    Local cAsset as char

    Default nType := 1

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 42

    If nType == 1
        Default nWidth := 110
    ElseIf nType == 2
        Default nHeight := 42
    ElseIf nType == 3
        Default nHeight := 42
    EndIf


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
{Protheus.doc} Method Update()
Método update (sem uso por enquanto)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update() Class FloatingGround
Return

/*
{Protheus.doc} Method HideGameObject()
Destrói objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class FloatingGround

   ::oGameObject:Hide()
    FreeObj(::oGameObject)

Return
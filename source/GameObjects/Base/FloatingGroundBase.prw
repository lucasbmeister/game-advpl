#include "totvs.ch"

/*
{Protheus.doc} Class FloatingGround
Classe para objetos de piso flutuantes
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class FloatingGroundBase From BaseGameObject

    Method New() Constructor
    Method Update()
    Method HideGameObject()

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth, nType) Class FloatingGroundBase
Instância classe FloatinGround
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth, nType) Class FloatingGroundBase
    
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

    ::cTag := 'floating_ground'

    cStyle := "TPanel { border-image: url("+StrTran(cAsset,"\","/")+") 0 stretch}"
    //cStyle := "TPanel { border: 1 solid black }"

    ::oGameObject := TPanel():New(nTop, nLeft, , oInstance:oWindow,,,,,, nWidth, nHeight)
    ::oGameObject:SetCss(cStyle)

Return

/*
{Protheus.doc} Method Update() Class FloatingGroundBase
Método update (sem uso por enquanto)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update() Class FloatingGroundBase
Return

/*
{Protheus.doc} Method HideGameObject() Class FloatingGroundBase
Destrói objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class FloatingGroundBase

   ::oGameObject:Hide()
   ::HideEditorCollider()
    FreeObj(::oGameObject)

Return
#include "totvs.ch"

/*
{Protheus.doc} Class Square 
Classe que representa um quadrado simples
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class Square From BaseGameObject

    Data lInvisible

    Method New() Constructor
    Method Update()
    Method HideGameObject() 
    Method SetInvisible()

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth)
Instância classe Square
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth) Class Square

    Local cStyle as char 
    Static oInstance as object

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 050
    Default nWidth := 050

    _Super:New(oWindow)

    oInstance := Self
    cStyle := "TPanel { background-color: black }"

    ::oGameObject := TPanel():New(nTop, nLeft, , oInstance:oWindow,,,,,, nWidth, nHeight)
    ::oGameObject:SetCss(cStyle)

Return Self

/*
{Protheus.doc} Method Update()
Método update (sem uso por enquanto)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update() Class Square
Return

/*
{Protheus.doc} Method HideGameObject()
Destrói objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class Square

   ::oGameObject:Hide()
    FreeObj(::oGameObject)
    ::HideEditorCollider()

Return

/*
{Protheus.doc} Method SetInvisible(lInvisible)
Set quadrado com invisivel (WIP)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetInvisible(lInvisible) Class Square

    Local cStyle as char

    ::lInvisible := lInvisible

    If lInvisible
        cStyle := "TPanel { background-color: black }"
    Else
        cStyle := "TPanel { opacity : 0 }"
    EndIf

    ::oGameObject:SetCss(cStyle)
Return
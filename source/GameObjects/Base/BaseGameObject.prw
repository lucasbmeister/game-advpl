#include "totvs.ch"

/*
{Protheus.doc} Class BaseGameObject
Classe base para todos os objetos de jogo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class BaseGameObject From LongNameClass

    Data cAssetsPath
    Data oWindow
    Data cTag
    Data oGameObject
    Data cInternalId
    Data lDestroy

    Data oAnimations

    //fisica
    Data lHasCollider

    Data nTopMargin
    Data nLeftMargin
    Data nBottomMargin
    Data nRightMargin

    Data nHalfHeight
    Data nHalfWidth

    Data nDY
    Data nDX

    Data nMass

    Method New() Constructor
    Method SetWindow()
    Method SetTag()
    Method GetTag()
    Method GetAssetsPath()
    Method LoadFrames()
    Method SetSize()
    Method GetInternalId()
    Method GetHeight()
    Method GetWidth()

    //fisica
    Method SetColliderMargin()
    Method HasCollider()
    Method GetMidX()
    Method GetMidY()
    Method GetTop()
    Method GetLeft()
    Method GetRight()
    Method GetBottom()
    Method GetMass()
    Method Destroy()
    Method SetLeftClickAction()
    Method SetRightClickAction()
    Method ShouldDestroy()

EndClass

/*
{Protheus.doc} Method New(oWindow)
Classe n�o � inst�nciada diretamente. Deve ser herdada por outros objetos
e chamados o m�todo _Super:New()
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow) Class BaseGameObject
    Local cTempPath as char

    cTempPath := GetTempPath()
    ::cAssetsPath := cTempPath + "gameadvpl\assets\

    if !Empty(oWindow)
        ::SetWindow(oWindow)
    EndIf

    ::cInternalId := UUIDRandom()
    ::lHasCollider := .F.
    ::lDestroy := .F.
    ::nDY := 0
    ::nDX := 0

Return Self

/*
{Protheus.doc} Method SetWindow(oWindow)
Define a janela utilizada pelo objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetWindow(oWindow) Class BaseGameObject
    ::oWindow := oWindow
Return 

/*
{Protheus.doc} Method GetAssetsPath(cAsset)
Retorna o caminho da pasta com assets do objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetAssetsPath(cAsset) Class BaseGameObject
Return ::cAssetsPath + cAsset

/*
{Protheus.doc} Method LoadFrames(cEntity)
Carrega todos os caminhos de frames em um array para utiliza��o em anima��es
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method LoadFrames(cEntity) Class BaseGameObject

    Local cPath as char
    Local nX as numeric
    Local nY as numeric
    Local aDirectory as array
    Local aAnimations as array
    Local aFramesForward as array
    Local aFramesBackward as array
    Local cTempPath as char

    ::oAnimations := JsonObject():New()

    cPath := ::GetAssetsPath(cEntity + "\animation\")

    aDirectory := Directory(cPath + "*.*", "D",,.F.)
    cTempPath := StrTran(cPath, "\", "/")
    aAnimations := {}

    If !Empty(aDirectory)

        AEval(aDirectory, { |x| IIF(x[5] == 'D', Aadd(aAnimations, x[1]), nil)}, 3)

        For nX := 1 To Len(aAnimations)
            // tem que existir pelo menos um estado
            aFramesForward := Directory(cPath + aAnimations[nX] + "\forward\*.png", "A",,.F.)
            aFramesBackward := Directory(cPath + aAnimations[nX] + "\backward\*.png", "A",,.F.)
            // se for anima��o deve existir pelo menos a dire��o forward
            For nY := 1 To Len(aFramesForward)
                aFramesForward[nY] := cTempPath + aAnimations[nX] + "/forward/" + aFramesForward[nY][1]
                If !Empty(aFramesBackward)
                    aFramesBackward[nY] := cTempPath + aAnimations[nX] + "/backward/" + aFramesBackward[nY][1]
                EndIf
            Next nY

            ::oAnimations[aAnimations[nX]] := JsonObject():New()
            ::oAnimations[aAnimations[nX]]['forward'] := aFramesForward
            
            If !Empty(aFramesBackward)
                ::oAnimations[aAnimations[nX]]['backward'] := aFramesBackward
            EndIf

        Next nX

    EndIf

Return 

/*
{Protheus.doc} Method SetTag(cTag)
Define um tag para o objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetTag(cTag) Class BaseGameObject
    ::cTag := cTag
Return

/*
{Protheus.doc} Method GetTag()
Retorna qual a tag definida
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetTag() Class BaseGameObject
Return ::cTag

/*
{Protheus.doc} Method SetColliderMargin(nTopMargin, nLeftMargin, nBottomMargin, nRightMargin)
Define qual a margem entre a borda do objeto e a �rea de colis�o. Isso e necess�rio
porque a sprite n�o corresponde exatamente ao tamanho do objeto de tela
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetColliderMargin(nTopMargin, nLeftMargin, nBottomMargin, nRightMargin) Class BaseGameObject

    If nTopMargin != Nil .and. nLeftMargin == Nil .and. nBottomMargin == Nil .and. nRightMargin == Nil

        ::nTopMargin := ::nLeftMargin := ::nBottomMargin := ::nRightMargin := nTopMargin

    ElseIf nTopMargin != Nil .and. nLeftMargin != Nil .and. nBottomMargin == Nil .and. nRightMargin == Nil

        ::nTopMargin := ::nBottomMargin := nTopMargin
        ::nLeftMargin := ::nRightMargin := nLeftMargin
        
    Else
        ::nTopMargin := nTopMargin
        ::nLeftMargin := nLeftMargin
        ::nBottomMargin := nBottomMargin
        ::nRightMargin := nRightMargin
    EndIf

    ::nHalfHeight := (::oGameObject:nHeight + ::nTopMargin + ::nBottomMargin) * 0.5
    ::nHalfWidth := (::oGameObject:nWidth + ::nLeftMargin + ::nRightMargin) * 0.5

    ::lHasCollider := .T.

Return

/*
{Protheus.doc} Method HasCollider()
Verifica se objeto possui colis�o ativada
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HasCollider() Class BaseGameObject
Return ::lHasCollider

/*
{Protheus.doc} Method GetMidX()
Retorna meio do objeto no eixo X
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetMidX() Class BaseGameObject
Return ::nHalfWidth + ::oGameObject:nLeft

/*
{Protheus.doc} Method GetMidY()
Retorna meio do objeto no eixo Y
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetMidY() Class BaseGameObject
Return ::nHalfHeight + ::oGameObject:nTop

/*
{Protheus.doc} Method GetTop(lMargin)
Retorna coordenada do nTop do objeto com margem, caso possua.
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetTop(lMargin) Class BaseGameObject
Return ::oGameObject:nTop + IIF(lMargin, ::nTopMargin, 0)

/*
{Protheus.doc} Method GetLeft(lMargin)
Retorna coordenada nLeft do objeto com margem, caso possua.
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetLeft(lMargin) Class BaseGameObject
Return ::oGameObject:nLeft + IIF(lMargin, ::nLeftMargin, 0)

/*
{Protheus.doc} Method GetRight(lMargin) 
Retorna coordenada nRight do objeto com margem, caso possua.
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetRight(lMargin) Class BaseGameObject
Return ::oGameObject:nLeft + ::oGameObject:nWidth + IIF(lMargin, ::nRightMargin, 0)

/*
{Protheus.doc} Method GetBottom(lMargin)
Retorna coordenada nBottom do objeto com margem, caso possua.
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetBottom(lMargin) Class BaseGameObject
Return ::oGameObject:nTop + ::oGameObject:nHeight + IIF(lMargin, ::nBottomMargin, 0)

/*
{Protheus.doc} Method GetInternalId()
Retorna Id �nico do objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetInternalId() Class BaseGameObject
Return ::cInternalId

/*
{Protheus.doc} Method Destroy()
Marca objeto para destrui��o
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Destroy() Class BaseGameObject
    ::lDestroy := .T.
Return 

/*
{Protheus.doc} Method ShouldDestroy() 
Verifica se objeto deve ser destru�do
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method ShouldDestroy() Class BaseGameObject
Return ::lDestroy

/*
{Protheus.doc} Method GetHeight()
Retorna propriedade nHeight do objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetHeight() Class BaseGameObject
Return ::oGameObject:nHeight

/*
{Protheus.doc} Method GetWidth()
Retorna propriedade nWidth do objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetWidth() Class BaseGameObject
Return ::oGameObject:nWidth

/*
{Protheus.doc} Method GetMass()
Retorna massa do objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetMass() Class BaseGameObject
Return ::nMass

/*
{Protheus.doc} Method SetLeftClickAction(bBlock)
Define bloco de a��o a ser executado quando clicado com o bot�o esquerdo
do mouse sobre o objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetLeftClickAction(bBlock) Class BaseGameObject
    ::oGameObject:bLClicked := bBlock
Return

/*
{Protheus.doc} Method SetRightClickAction(bBlock) 
Define bloco de a��o a ser executado quando clicado com o bot�o direito
do mouse sobre o objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetRightClickAction(bBlock) Class BaseGameObject
    ::oGameObject:bRClicked := bBlock
Return


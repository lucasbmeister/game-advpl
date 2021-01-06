#include "totvs.ch"
#include "gameadvpl.ch"

#DEFINE ANIMATION_DELAY 80 //ms
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Class Coin From BaseGameObject 

    Data nCurrentFrame
    Data nLastFrameTime

    Method New() Constructor
    Method Update()
    Method Animate()
    Method GetNextFrame()
    Method CheckTrigger()
    Method HideGameObject()

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth, cName ) Class Coin

    Local cStyle as char
    Static oInstance as object

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 050
    Default nWidth := 050

    _Super:New(oWindow)

    ::nCurrentFrame := 1
    ::nLastFrameTime := 0
    ::LoadFrames("collectables\coin_1")

    cStyle := "TPanel { border-image: url("+::oAnimations['idle']['forward'][::nCurrentFrame]+") 0 stretch; }"

    oInstance := Self

    ::oGameObject := TPanel():New(nTop, nLeft, cName, oInstance:oWindow,,,,,, nWidth, nHeight)
    ::oGameObject:SetCss(cStyle)

Return Self
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update(oGameManager) Class Coin

    Local aColliders as array
    Local lTriggered as logical
    Local nPosPlayer as numeric

    nPosPlayer := 0
    lTriggered := .F.

    aColliders := oGameManager:GetColliders()

    If !Empty(aColliders)
        nPosPlayer := AScan(aColliders, {|x| x:GetTag() == 'player'})
        If nPosPlayer > 0 
            lTriggered := ::CheckTrigger(aColliders[nPosPlayer])
        EndIf
    EndIf

    If lTriggered
        oGameManager:UpdateScore(1)
        ::HideGameObject()
    Else
        ::Animate()
    EndIf
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Animate() Class Coin

    Local cStyle as char
    Local nTime as numeric

    nTime := TimeCounter()

    If nTime - ::nLastFrameTime >= ANIMATION_DELAY

        cStyle := "TPanel { border-image: url("+::GetNextFrame('idle')+") 0 0 0 0 stretch}"
        
        ::oGameObject:SetCss(cStyle)

        ::nLastFrameTime := nTime
    EndIf

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetNextFrame(cState) Class Coin

    Local cDirection as char

    cDirection := 'forward'

    If ::nCurrentFrame >= Len(::oAnimations[cState][cDirection])
        ::nCurrentFrame := 1
    Else
        ::nCurrentFrame++
    EndIf

Return ::oAnimations[cState][cDirection][::nCurrentFrame]

Method CheckTrigger(oObject) Class Coin

    Local nCoinTop as numeric
    Local nCoinLeft as numeric
    Local nCoinBottom as numeric
    Local nCoinRight as numeric

    Local nObjTop as numeric
    Local nObjLeft as numeric
    Local nObjBottom as numeric
    Local nObjRight as numeric
    Local cTag as char

    Local lTriggered as logical

    lTriggered := .F.

    nCoinTop := ::GetTop(.F.)
    nCoinLeft := ::GetLeft(.F.)
    nCoinBottom := ::GetBottom(.F.)
    nCoinRight := ::GetRight(.F.)

    nObjTop := oObject:GetTop(.T.)
    nObjLeft := oObject:GetLeft(.T.)
    nObjBottom := oObject:GetBottom(.T.)
    nObjRight := oObject:GetRight(.T.)

    cTag := oObject:GetTag()

    //check If player is either touching or within the object-bounds
    If nCoinRight >= nObjLeft .and. nCoinLeft <= nObjRight .and. nCoinBottom >= nObjTop .and. nCoinTop <= nObjBottom .and. cTag == 'player'
        lTriggered := .T.
    EndIf

Return lTriggered
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HideGameObject() Class Coin

    ::oGameObject:Hide()
    ::Destroy()
    FreeObj(::oGameObject)

Return
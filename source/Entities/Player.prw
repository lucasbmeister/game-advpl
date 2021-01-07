#include "totvs.ch"
#include "gameadvpl.ch"

#DEFINE SPEED 4
#DEFINE MAX_JUMP 60
#DEFINE JUMP_SPEED 8
#DEFINE ANIMATION_DELAY 80 //ms
#DEFINE GRAVITY 1

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/

Class Player From BaseGameObject

    Data cDirection
    Data cLastDirection
    Data lIsJumping
    Data lIsGrounded
    Data cCurrentState
    Data nCurrentFrame
    Data nLastFrameTime
    Data cLastState

    Method New() Constructor
    Method Update()
    Method IsJumping()
    Method IsGrounded()
    Method Animate()
    Method SetState()
    Method GetState()
    Method GetNextFrame()
    Method HideGameObject()
    Method IsOutOfBounds()
    Method CheckKey()
    Method SolveCollision()
    Method SetDirection()
    Method IsAttacking()
    Method IsLastFrame()
    Method IsBlocking()

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth, cName ) Class Player

    Local cStyle as char
    Static oInstance as object

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 50
    Default nWidth := 80

    _Super:New(oWindow)

    ::lIsJumping := .F.
    ::lIsGrounded := .F.
    ::cLastState := ::cCurrentState := "idle"
    ::cDirection := ::cLastDirection := "forward"

    ::nCurrentFrame := 1
    ::nLastFrameTime := 0
    ::LoadFrames("player")

    cStyle := "TPanel { border-image: url("+::oAnimations[::cCurrentState][::cDirection][::nCurrentFrame]+") 0 stretch; }"

    oInstance := Self

    //::oGameObject := TPanelCss():New(nTop, nLeft, , oInstance:oWindow,,,,,, nWidth, nHeight)
    ::oGameObject := TPanel():New(nTop,nLeft, cName,oInstance:oWindow,,,,,,nWidth,nHeight)
    ::oGameObject:SetCss(cStyle)

Return Self
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update(oGameManager) Class Player

    Local oKeys as char
    Local aColliders as array
    Local nX as numeric
    Local nXPos as numeric
    Local nYPos as numeric
    Local nXOri as numeric
    Local nYOri as numeric
    Local aNewXY as array

    oKeys := oGameManager:GetPressedKeys()

    nXPos := nXOri := ::oGameObject:nLeft
    nYPos := nYOri := ::oGameObject:nTop

    If oKeys['i'] .and. !::IsBlocking()
        ::SetState("block")
    ElseIf !oKeys['i'] .and. ::IsBlocking() .and. !::IsAttacking()
        ::SetState("idle")
    EndIF

    If !::IsAttacking() .and. !::IsBlocking()

        If oKeys['w'] .and. !::IsJumping() .and. ::IsGrounded()
            ::SetState("jumping")
            ::lIsJumping := .T.
            ::nDy := -JUMP_SPEED * 2
        EndIf

        If oKeys['a']
            ::SetDirection("backward")
            ::SetState("running")
            nXPos -= SPEED

        EndIf

        If oKeys['d']
            ::SetDirection("forward")
            ::SetState("running")
            nXPos += SPEED
        EndIf

        If oKeys['j']
            ::SetState("attacking_1")
        EndIf

        If oKeys['k']
            ::SetState("attacking_2")
        EndIf

        If oKeys['l']
            ::SetState("attacking_3")
        EndIf

    EndIf

    nXPos += ::nDX

    // If nXPos + ::nLeftMargin <= 0
    //     nXPos := -::nLeftMargin
    // EndIf

    // If nXPos + ::GetWidth() + ::nRightMargin >= ::oWindow:nWidth
    //     nXPos := ::oWindow:nWidth - ::GetWidth() - ::nRightMargin
    // EndIf

    ::nDY += GRAVITY

    nYPos += ::nDY

    aColliders := oGameManager:GetColliders()

    aNewXY := {nXPos, nYPos}

    If !Empty(aColliders)
        For nX := 1 To Len(aColliders)
            If aColliders[nX]:GetTag() != 'player' .and. !Empty(aColliders[nX])
                aNewXY := ::SolveCollision(aColliders[nX], aNewXY[1], aNewXY[2])
            EndIf
        Next
    EndIf

    ::oGameObject:nLeft := aNewXY[1]
    ::oGameObject:nTop := aNewXY[2]

    If ::IsOutOfBounds()
        oGameManager:GameOver()
        Return
    EndIF

    If (::oGameObject:nLeft - oGameManager:GetStartLimit() >= oGameManager:GetMidScreen() .or.;
            oGameManager:GetEndLimit() - ::oGameObject:nLeft <= oGameManager:GetMidScreen()) .and. nXOri != ::oGameObject:nLeft
        oGameManager:SetCameraUpdate(.T., ::cDirection, SPEED) 
    EndIF

    If nXOri == ::oGameObject:nLeft .and. nYOri == ::oGameObject:nTop .and. !::IsAttacking() .and. !::IsBlocking()
        ::SetState("idle")
    EndIf

    ::Animate()
    ::cLastDirection := ::cDirection
    ::cLastState := ::cCurrentState

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method IsJumping() Class Player
Return ::lIsJumping

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method CheckKey(cKey, oKeys, aKeys, nPos) Class Player
Return aKeys[nPos] == cKey .and. oKeys[cKey]

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method IsGrounded() Class Player
Return ::lIsGrounded

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Animate() Class Player

    Local cState as char
    Local cStyle as char
    Local nTime as numeric

    nTime := TimeCounter()

    If nTime - ::nLastFrameTime >= ANIMATION_DELAY

        cState := ::GetState()


        If cState != "jumping"

            If ::IsLastFrame(cState) .and. ::IsAttacking()
                ::SetState('idle')
            EndIf

            cStyle := "TPanel { border-image: url("+::GetNextFrame(::GetState())+") 0 0 0 0 stretch}"
            //cStyle := "TPanel { border: 1 solid black }"
            //cStyle := "QFrame{ image: url("+::GetNextFrame(cState)+")}"
            //cStyle := "QFrame{ background-image: url("+::GetNextFrame(cState)+"); background-repeat: no-repeat, no-repeat; background-size: 100% 100%; background-position: center; height: 100%; width: 100%;}"
            ::oGameObject:SetCss(cStyle)

        EndIf
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
Method SetState(cState) Class Player
    ::cCurrentState := cState
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetState() Class Player
Return ::cCurrentState
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetNextFrame(cState) Class Player

    Local lChangedDirection as logical

    lChangedDirection := ::cLastDirection != ::cDirection

    If ::IsLastFrame(cState) .or. lChangedDirection .or. cState != ::cLastState
        ::nCurrentFrame := 1
    Else
        ::nCurrentFrame++
    EndIf

Return ::oAnimations[cState][::cDirection][::nCurrentFrame]

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HideGameObject() Class Player

    ::oGameObject:Hide()
    FreeObj(::oGameObject)

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method IsOutOfBounds() Class Player
Return ::oGameObject:nTop > ::oWindow:nHeight

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SolveCollision(oObject, nXPos, nYPos) Class Player

    Local nPlayerTop as numeric
    Local nPlayerLeft as numeric
    Local nPlayerBottom as numeric
    Local nPlayerRight as numeric

    Local nObjTop as numeric
    Local nObjLeft as numeric
    Local nObjBottom as numeric
    Local nObjRight as numeric
    Local cTag as char

    Local lOnTop as logical

    Local aSides as array
    Local nSide as numeric

    Local nHeight as numeric
    Local nWidth as numeric

    nHeight := ::GetHeight()
    nWidth := ::GetWidth()


    nPlayerTop := nYPos + ::nTopMargin
    nPlayerLeft := nXPos  + ::nLeftMargin
    nPlayerBottom := nYPos + nHeight + ::nBottomMargin
    nPlayerRight := nXPos + nWidth + ::nRightMargin


    nObjTop := oObject:GetTop(.T.)
    nObjLeft := oObject:GetLeft(.T.)
    nObjBottom := oObject:GetBottom(.T.)
    nObjRight := oObject:GetRight(.T.)

    cTag := oObject:GetTag()
    lOnTop := .F.

    //check If player is either touching or within the object-bounds
    If nPlayerRight >= nObjLeft .and. nPlayerLeft <= nObjRight .and. nPlayerBottom >= nObjTop .and. nPlayerTop <= nObjBottom

        //player is already colliding with top or bottom side of object
        If (lOnTop := ::oGameObject:nTop + nHeight /*+ ::nTopMargin*/ == nObjTop) .or. ::oGameObject:nTop /*+ ::nBottomMargin*/ == nObjBottom
            nYPos := ::oGameObject:nTop /*+ ::nTopMargin*/

            //player is already colliding with left or right side of object
        ElseIf ::oGameObject:nLeft + nWidth/* + ::nLeftMargin*/ == nObjLeft .or. ::oGameObject:nLeft /*+ ::nRightMargin*/ == nObjRight  .and. cTag != 'floating_ground'
            nXPos := ::oGameObject:nLeft /* + ::nLeftMargin   */

        ElseIf nPlayerRight > nObjLeft .and. nPlayerLeft < nObjRight .and. nPlayerBottom > nObjTop .and. nPlayerTop < nObjBottom
            //check on which side the player collides with the object
            aSides := { Abs(nPlayerBottom - nObjTop), Abs(nPlayerRight - nObjLeft), Abs(nPlayerTop - nObjBottom), Abs(nPlayerLeft - nObjRight)}

            nSide := MinArr(aSides) //returns the side with the smallest distance between player and object

            If nSide == aSides[TOP] //first check top, than left
                nYPos := nObjTop - nHeight /*+ ::nTopMargin*/
            ElseIf nSide == aSides[LEFT] .and. cTag != 'floating_ground'
                nXPos := nObjLeft - nWidth + ::nLeftMargin
            ElseIf nSide == aSides[BOTTOM] .and. cTag != 'floating_ground'//first check bottom, than right
                nYPos := nObjBottom
            ElseIf nSide == aSides[RIGHT] .and. cTag != 'floating_ground'
                nXPos := nObjRight + ::nRightMargin
            EndIf
            ::lIsJumping := .F.

            If !lOnTop
                ::lIsGrounded := .F.
            EndIF

            ::nDY := 0
        EndIf
    EndIf

    If lOnTop
        ::nDY := 0
        ::lIsJumping := .F.
        If cTag $ 'ground;floating_ground'
            ::lIsGrounded := .T.
        EndIF
    EndIf

Return {nXPos, nYPos}

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function MinArr(aValues)

    Local nX as numeric
    Local nMin as numeric

    If !Empty(aValues)
        nMin := aValues[1]
        For nX := 1 To Len(aValues)
            If aValues[nX] < nMin
                nMin := aValues[nX]
            EndIf
        Next
    EndIf

Return nMin

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetDirection(cDirection) Class Player
    ::cDirection := cDirection
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method IsAttacking() Class Player
Return 'attacking' $ ::GetState()
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method IsBlocking() Class Player
Return ::GetState() == 'block'
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method IsLastFrame(cState) Class Player
Return ::nCurrentFrame >= Len(::oAnimations[cState][::cDirection]) .and. ::cLastState == cState
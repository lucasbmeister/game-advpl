#include "totvs.ch"
#include "gameadvpl.ch"

#DEFINE SPEED 2
#DEFINE ANIMATION_DELAY 80 //ms
#DEFINE ATTACK_COOLDOWN 3000 //ms
#DEFINE GRAVITY 1

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/

Class Enemy From BaseGameObject

    Data cDirection
    Data cLastDirection
    Data lIsGrounded
    Data cCurrentState
    Data nCurrentFrame
    Data nLastFrameTime
    Data nTime
    Data nLastAttackTime
    Data cLastState

    Method New() Constructor
    Method Update()
    Method IsGrounded()
    Method Animate()
    Method SetState()
    Method GetState()
    Method GetNextFrame()
    Method HideGameObject()
    Method IsOutOfBounds()
    Method SolveCollision()
    Method SetDirection()
    Method IsAttacking()
    Method IsLastFrame()

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth, cName ) Class Enemy

    Local cStyle as char
    Static oInstance as object

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 050
    Default nWidth := 050

    _Super:New(oWindow)

    ::lIsGrounded := .F.
    ::cLastState := ::cCurrentState := "idle"
    ::cDirection := ::cLastDirection := "backward"

    ::nCurrentFrame := 1
    ::nLastFrameTime := 0
    ::nLastAttackTime := 0
    ::LoadFrames("player")

    cStyle := "TPanel { border-image: url("+::oAnimations[::cCurrentState][::cDirection][::nCurrentFrame]+") 0 stretch; }"

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
Method Update(oGameManager) Class Enemy

    Local aColliders as array
    Local nX as numeric
    Local nXPos as numeric
    Local nYPos as numeric
    Local nXOri as numeric
    Local nYOri as numeric
    Local aNewXY as array

    nXPos := nXOri := ::oGameObject:nLeft
    nYPos := nYOri := ::oGameObject:nTop

    ::nTime := TimeCounter()

    If ::IsGrounded() .and. !::IsAttacking()
        If ::cLastDirection == 'backward'
            ::SetState("running")
            nXPos -= SPEED
        EndIf

        If ::cLastDirection == 'forward'
            ::SetState("running")
            nXPos += SPEED
        EndIf
    EndIf

    nXPos += ::nDX

    // If nXPos + ::nLeftMargin <= 0
    //     nXPos := -::nLeftMargin
    //     ::SetDirection('forward')
    // EndIf

    // If nXPos + ::GetWidth() + ::nRightMargin >= ::oWindow:nWidth
    //     nXPos := ::oWindow:nWidth - ::GetWidth() - ::nRightMargin
    //     ::SetDirection('backward')
    // EndIf

    ::nDY += GRAVITY

    nYPos += ::nDY

    aColliders := oGameManager:GetColliders()

    aNewXY := {nXPos, nYPos}

    If !Empty(aColliders)
        For nX := 1 To Len(aColliders)
            If aColliders[nX]:GetInternalId() != ::GetInternalId()
                aNewXY := ::SolveCollision(aColliders[nX], aNewXY[1], aNewXY[2])

                If aNewXY[3] .and. !::IsGrounded()
                    ::lIsGrounded := .T.
                EndIf
            EndIf
        Next
    EndIf

    ::oGameObject:nLeft := aNewXY[1]
    ::oGameObject:nTop := aNewXY[2]

    If ::IsOutOfBounds()
        ::HideGameObject()
        Return
    EndIF

    If nXOri == ::oGameObject:nLeft .and. nYOri == ::oGameObject:nTop .and. !::IsAttacking()
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
Method IsGrounded() Class Enemy
Return ::lIsGrounded

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Animate() Class Enemy

    Local cState as char
    Local cStyle as char

    If ::nTime - ::nLastFrameTime >= ANIMATION_DELAY

        cState := ::GetState()

        If ::IsLastFrame(cState) .and. ::IsAttacking()
            ::SetState('idle')
            ::nLastAttackTime := ::nTime
        EndIf

        cStyle := "TPanel { border-image: url("+::GetNextFrame(::GetState())+") 0 0 0 0 stretch}"
        //cStyle := "TPanel { border: 1 solid black }"
        //cStyle := "QFrame{ background-image: url("+::GetNextFrame(cState)+"); background-repeat: no-repeat, no-repeat; background-size: cover; background-position: center; height: 100%; width: 100%;}"
        ::oGameObject:SetCss(cStyle)

        ::nLastFrameTime := ::nTime
    EndIf

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetState(cState) Class Enemy
    ::cCurrentState := cState
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetState() Class Enemy
Return ::cCurrentState
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetNextFrame(cState) Class Enemy

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
Method HideGameObject() Class Enemy

    ::oGameObject:Hide()
    ::Destroy()
    FreeObj(::oGameObject)

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method IsOutOfBounds() Class Enemy
Return ::oGameObject:nTop > ::oWindow:nHeight

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SolveCollision(oObject, nXPos, nYPos) Class Enemy

    Local nEnemyTop as numeric
    Local nEnemyLeft as numeric
    Local nEnemyBottom as numeric
    Local nEnemyRight as numeric

    Local nObjTop as numeric
    Local nObjLeft as numeric
    Local nObjBottom as numeric
    Local nObjRight as numeric
    Local cTag as char

    Local lOnTop as logical

    Local aSides as array
    Local nSide as numeric

    Local nWidth as numeric
    Local nHeight as numeric

    Local lIsGrounded as logical

    nWidth := ::GetWidth()
    nHeight := ::GetHeight()

    nEnemyTop := nYPos + ::nTopMargin
    nEnemyLeft := nXPos  + ::nLeftMargin
    nEnemyBottom := nYPos + nHeight + ::nBottomMargin
    nEnemyRight := nXPos + nWidth + ::nRightMargin

    nObjTop := oObject:GetTop(.T.)
    nObjLeft := oObject:GetLeft(.T.)
    nObjBottom := oObject:GetBottom(.T.)
    nObjRight := oObject:GetRight(.T.)

    cTag := oObject:GetTag()
    lOnTop := .F.
    lIsGrounded := .F.

    //check If player is either touching or within the object-bounds
    If nEnemyRight >= nObjLeft .and. nEnemyLeft <= nObjRight .and. nEnemyBottom >= nObjTop .and. nEnemyTop <= nObjBottom

        //player is already colliding with top or bottom side of object
        If (lOnTop := ::oGameObject:nTop + nHeight /*+ ::nTopMargin*/ == nObjTop) .or. ::oGameObject:nTop - nHeight /*+ ::nBottomMargin*/ == nObjBottom
            nYPos := ::oGameObject:nTop /*+ ::nTopMargin*/

            //player is already colliding with left or right side of object
        ElseIf ::oGameObject:nLeft + nWidth /*+ ::nLeftMargin*/ == nObjLeft .or. ::oGameObject:nLeft - nWidth /*+ ::nRightMargin*/ == nObjRight .and. cTag != 'floating_ground'
            nXPos := ::oGameObject:nLeft /* + ::nLeftMargin  */

        ElseIf nEnemyRight > nObjLeft .and. nEnemyLeft < nObjRight .and. nEnemyBottom > nObjTop .and. nEnemyTop < nObjBottom
            //check on which side the player collides with the object
            aSides := { Abs(nEnemyBottom - nObjTop), Abs(nEnemyRight - nObjLeft), Abs(nEnemyTop - nObjBottom), Abs(nEnemyLeft - nObjRight)}

            nSide := MinArr(aSides) //returns the side with the smallest distance between player and object

            If nSide == aSides[TOP] //first check top, than left
                nYPos := nObjTop - nHeight /*+ ::nTopMargin*/
            ElseIf nSide == aSides[LEFT] .and. cTag != 'floating_ground'
                nXPos := nObjLeft - nWidth + ::nLeftMargin
            ElseIf nSide == aSides[BOTTOM]  .and. cTag != 'floating_ground' //first check bottom, than right
                nYPos := nObjBottom + nHeight/* + ::nBottomMargin*/
            ElseIf nSide == aSides[RIGHT]  .and. cTag != 'floating_ground'
                nXPos := nObjRight + ::nRightMargin
            EndIf

            ::nDY := 0
        EndIf

        If !lOnTop
            If cTag == 'player' .and. !::IsAttacking() .and. ::nTime - ::nLastAttackTime  >= ATTACK_COOLDOWN
                ::SetState('attacking_' + cValToChar(Randomize(1, 3)))
            EndIf
            lIsGrounded := .F.
        Else
            If cTag $ 'ground;floating_ground'
                lIsGrounded := .T.
            EndIf
        EndIf

        If cTag == 'endwall'
            ::SetDirection('backward')
        ElseIf cTag == 'startwall'
            ::SetDirection('forward')
        EndIf
    EndIf

    If lOnTop

        If ((nXPos <= nObjLeft .and. ::cDirection == 'backward') .or. (nXPos >= nObjRight .and. ::cDirection == 'forward'))  .and. !::IsAttacking() .and. !::IsGrounded()
            ::SetDirection(IIF(::cDirection == 'forward', 'backward', 'forward'))
        EndIF

        ::nDY := 0
    EndIf

Return {nXPos, nYPos, lIsGrounded}

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
Method SetDirection(cDirection) Class Enemy
    ::cDirection := cDirection
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method IsAttacking() Class Enemy
Return 'attacking' $ ::GetState()
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method IsLastFrame(cState) Class Enemy
Return ::nCurrentFrame >= Len(::oAnimations[cState][::cDirection]) .and. ::cLastState == cState
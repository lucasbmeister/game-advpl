#include "totvs.ch"
#include "gameadvpl.ch"

#DEFINE SPEED 3
#DEFINE ANIMATION_DELAY 80 //ms
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

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, cName, nTop, nLeft, nHeight, nWidth ) Class Enemy

    Local cStyle as char
    Static oInstance as object

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 050
    Default nWidth := 050

    _Super:New(oWindow)

    ::lIsGrounded := .F.
    ::cCurrentState := "idle"
    ::cDirection := ::cLastDirection := "backward"

    ::nCurrentFrame := 1
    ::nLastFrameTime := 0
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

    If ::IsGrounded()
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

    If nXPos + ::nLeftMargin <= 0
        nXPos := -::nLeftMargin
        ::SetDirection('forward')
    EndIf

    If nXPos + ::GetWidth() + ::nRightMargin >= ::oWindow:nWidth
        nXPos := ::oWindow:nWidth - ::GetWidth() - ::nRightMargin
        ::SetDirection('backward')
    EndIf

    ::nDY += GRAVITY

    nYPos += ::nDY

    aColliders := oGameManager:GetColliders()

    aNewXY := {nXPos, nYPos}

    If !Empty(aColliders)
        For nX := 1 To Len(aColliders)
            If aColliders[nX]:GetInternalId() != ::GetInternalId()
                aNewXY := ::SolveCollision(aColliders[nX], aNewXY[1], aNewXY[2])
            EndIf
        Next
    EndIf

    ::oGameObject:nLeft := aNewXY[1]
    ::oGameObject:nTop := aNewXY[2]

    If ::IsOutOfBounds()
        ::HideGameObject()
        Return
    EndIF

    If nXOri == ::oGameObject:nLeft .and. nYOri == ::oGameObject:nTop .and. ::GetState() != 'attacking'
        ::SetState("idle")
    EndIf

    ::Animate()
    ::cLastDirection := ::cDirection

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
    Local nTime as numeric

    nTime := TimeCounter()

    If nTime - ::nLastFrameTime >= ANIMATION_DELAY

        cState := ::GetState()

        If cState == 'attacking'
            cState += '_1'
        EndIf

        cStyle := "TPanel { border-image: url("+::GetNextFrame(cState)+") 0 0 0 0 stretch; background-color: black}"
        //cStyle := "QFrame{ image: url("+::GetNextFrame(cState)+")}"
        //cStyle := "QFrame{ background-image: url("+::GetNextFrame(cState)+"); background-repeat: no-repeat, no-repeat; background-size: cover; background-position: center; height: 100%; width: 100%;}"
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

    If ::nCurrentFrame >= Len(::oAnimations[cState][::cDirection]) .or. lChangedDirection
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

    nWidth := ::GetWidth()
    nHeight := ::GetHeight()

    nEnemyTop := nYPos - nHeight + ::nTopMargin
    nEnemyLeft := nXPos - nWidth  + ::nLeftMargin
    nEnemyBottom := nYPos + nHeight + ::nBottomMargin
    nEnemyRight := nXPos + nWidth + ::nRightMargin

    nObjTop := oObject:GetTop()
    nObjLeft := oObject:GetLeft()
    nObjBottom := oObject:GetBottom()
    nObjRight := oObject:GetRight()

    cTag := oObject:GetTag() 
    lOnTop := .F.

        //check If player is either touching or within the object-bounds
    If nEnemyRight >= nObjLeft .and. nEnemyLeft <= nObjRight .and. nEnemyBottom >= nObjTop .and. nEnemyTop <= nObjBottom
        
        //player is already colliding with top or bottom side of object
        If (lOnTop := ::oGameObject:nTop + nHeight + ::nTopMargin == nObjTop) .or. ::oGameObject:nTop - nHeight + ::nBottomMargin == nObjBottom
            nYPos := ::oGameObject:nTop + ::nTopMargin

        //player is already colliding with left or right side of object
        ElseIf ::oGameObject:nLeft + nWidth + ::nLeftMargin == nObjLeft .or. ::oGameObject:nLeft - nWidth + ::nRightMargin == nObjRight
            nXPos := ::oGameObject:nLeft  + ::nLeftMargin  

        ElseIf nEnemyRight > nObjLeft .and. nEnemyLeft < nObjRight .and. nEnemyBottom > nObjTop .and. nEnemyTop < nObjBottom 
            //check on which side the player collides with the object
            aSides := { Abs(nEnemyBottom - nObjTop), Abs(nEnemyRight - nObjLeft), Abs(nEnemyTop - nObjBottom), Abs(nEnemyLeft - nObjRight)}

            nSide := MinArr(aSides) //returns the side with the smallest distance between player and object
            
            If nSide == aSides[TOP] //first check top, than left
                nYPos := nObjTop - nHeight + ::nTopMargin
            ElseIf nSide == aSides[LEFT]
                nXPos := nObjLeft - nWidth + ::nLeftMargin
            ElseIf nSide == aSides[BOTTOM] //first check bottom, than right
                nYPos := nObjBottom + nHeight + ::nBottomMargin
            ElseIf nSide == aSides[RIGHT]
                nXPos := nObjRight + nWidth + ::nRightMargin
            EndIf

            ::nDY := 0
        EndIf

        If !lOnTop
            If cTag == 'player'
                ::SetState('attacking')
            EndIf
            ::lIsGrounded := .F.
        EndIF
    EndIf    

    If lOnTop

        If (nXPos <= nObjLeft .and. ::cDirection == 'backward') .or. (nXPos >= nObjRight .and. ::cDirection == 'forward')  .and. ::GetState() != 'attacking' 
            ::SetDirection(IIF(::cDirection == 'forward', 'backward', 'forward'))
        EndIF

        ::nDY := 0

        If cTag == 'ground'
            ::lIsGrounded := .T.
        EndIf 
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
Method SetDirection(cDirection) Class Enemy
    ::cDirection := cDirection
Return
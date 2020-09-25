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

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, cName, nTop, nLeft, nHeight, nWidth ) Class Player

    Local cStyle as char
    Static oInstance as object

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 050
    Default nWidth := 050

    _Super:New(oWindow)

    ::lIsJumping := .F.
    ::lIsGrounded := .F.
    ::cCurrentState := "idle"
    ::cDirection := ::cLastDirection := "forward"

    ::nCurrentFrame := 1
    ::nLastFrameTime := 0
    ::LoadFrames("player")

    // cStyle := "QFrame{ border-style:solid; border-width:3px; border-color:#FF0000; background-color:#00FF00 }"
    cStyle := "QFrame{ border-image: url("+::oAnimations[::cCurrentState][::cDirection][::nCurrentFrame]+") 0 stretch; }"

    oInstance := Self

    ::oGameObject := TPanelCss():New(nTop, nLeft, , oInstance:oWindow,,,,,, nWidth, nHeight)
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
    Local aKeys as array
    Local nX as numeric
    Local nXPos as numeric
    Local nYPos as numeric
    Local nXOri as numeric
    Local nYOri as numeric
    Local aNewXY as array

    oKeys := oGameManager:GetPressedKeys()
    aKeys := oKeys:GetNames()

    nXPos := nXOri := ::oGameObject:nLeft
    nYPos := nYOri := ::oGameObject:nTop

    For nX := 1 To Len(aKeys)

        If ::CheckKey('w', oKeys, aKeys, nX) .and. !::IsJumping()
            ::SetState("jumping")
            ::lIsJumping := .T.
            ::nDy := -JUMP_SPEED * 2
        EndIf

        If ::CheckKey('a', oKeys, aKeys, nX)
            ::SetDirection("backward")
            ::SetState("running")
            nXPos -= SPEED

        EndIf

        If ::CheckKey('d', oKeys, aKeys, nX)
            ::SetDirection("forward")
            ::SetState("running")
            nXPos += SPEED
        EndIf

        If ::CheckKey('x', oKeys, aKeys, nX)
            If oGameManager:GetActiveScene():GetSceneID() == "level_1"
                oGameManager:LoadScene("level_2")
            Else
                oGameManager:LoadScene("level_1")
            EndIf
            Return
        EndIf

    Next nX

    nXPos += ::nDX

    If nXPos + ::nLeftMargin <= 0
        nXPos := -::nLeftMargin
    EndIf

    If nXPos >= ::oWindow:nWidth
        nXPos := ::oWindow:nWidth - ::oGameObject:nWidth
    EndIf

    ::nDY += GRAVITY

    nYPos += ::nDY

    aColliders := oGameManager:GetColliders()

    aNewXY := {nXPos, nYPos}

    If !Empty(aColliders)
        For nX := 1 To Len(aColliders)
            If aColliders[nX]:GetTag() != 'player'
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

    If nXOri == ::oGameObject:nLeft .and. nYOri == ::oGameObject:nTop
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

            cStyle := "QFrame{ border-image: url("+::GetNextFrame(cState)+") 0 stretch; }"
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
    
    nPlayerTop := nYPos - ::oGameObject:nHeight
    nPlayerLeft := nXPos - ::oGameObject:nWidth
    nPlayerBottom := nYPos + ::oGameObject:nHeight
    nPlayerRight := nXPos + ::oGameObject:nWidth
    

    nObjTop := oObject:GetTop()
    nObjLeft := oObject:GetLeft()
    nObjBottom := oObject:GetBottom()
    nObjRight := oObject:GetRight()

    cTag := oObject:GetTag() 
    lOnTop := .F.

        //check If player is either touching or within the object-bounds
    If nPlayerRight >= nObjLeft .and. nPlayerLeft <= nObjRight .and. nPlayerBottom >= nObjTop .and. nPlayerTop <= nObjBottom
        
        //player is already colliding with top or bottom side of object
        If (lOnTop := ::oGameObject:nTop + ::oGameObject:nHeight == nObjTop) .or. ::oGameObject:nTop - ::oGameObject:nHeight == nObjBottom
            nYPos := ::oGameObject:nTop
        //player is already colliding with left or right side of object
        ElseIf ::oGameObject:nLeft + ::oGameObject:nWidth == nObjLeft .or. ::oGameObject:nLeft - ::oGameObject:nWidth == nObjRight
            nXPos := ::oGameObject:nLeft     
        ElseIf nPlayerRight > nObjLeft .and. nPlayerLeft < nObjRight .and. nPlayerBottom > nObjTop .and. nPlayerTop < nObjBottom 
            //check on which side the player collides with the object
            aSides := { Abs(nPlayerBottom - nObjTop), Abs(nPlayerRight - nObjLeft), Abs(nPlayerTop - nObjBottom), Abs(nPlayerLeft - nObjRight)}

            nSide := MinArr(aSides) //returns the side with the smallest distance between player and object
            
            If nSide == aSides[TOP] //first check top, than left
                nYPos := nObjTop - ::oGameObject:nHeight
            ElseIf nSide == aSides[LEFT] 
                nXPos := nObjLeft - ::oGameObject:nWidth
            ElseIf nSide == aSides[BOTTOM] //first check bottom, than right
                nYPos := nObjBottom + ::oGameObject:nHeight
            ElseIf nSide == aSides[RIGHT]
                nXPos := nObjRight + ::oGameObject:nWidth
            EndIf
            ::lIsJumping := .F.
            ::nDY := 0
        EndIf
    EndIf    

    If lOnTop
        ::nDY := 0
        ::lIsJumping := .F.
        If cTag == 'ground'
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
#include "totvs.ch"
#include "gameadvpl.ch"

#DEFINE SPEED 4
#DEFINE MAX_JUMP 60
#DEFINE JUMP_SPEED 8
#DEFINE ANIMATION_DELAY 100 //ms
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

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, cName) Class Player

    Local cStyle as char
    Static oInstance as object

    _Super:New(oWindow)

    ::lIsJumping := .F.
    ::lIsGrounded := .F.
    ::cCurrentState := "idle"

    ::nCurrentFrame := 1
    ::nLastFrameTime := 0
    ::LoadFrames("player")

    // cStyle := "QFrame{ border-style:solid; border-width:3px; border-color:#FF0000; background-color:#00FF00 }"
    cStyle := "QFrame{ image: url("+::aFramesForward[::nCurrentFrame]+"); border-style: none }"

    ::cDirection := ::cLastDirection := "R"

    oInstance := Self

    ::oGameObject := TPanelCss():New(100, 150, , oInstance:oWindow,,,,,, 050, 050)
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
    Local lIdle as logical
    Local nXPos as numeric
    Local nYPos as numeric
    Local aNewXY as array

    oKeys := oGameManager:GetPressedKeys()
    aKeys := oKeys:GetNames()

    lIdle := .T.

    nXPos := ::oGameObject:nLeft
    nYPos := ::oGameObject:nTop

    For nX := 1 To Len(aKeys)

        If ::CheckKey('w', oKeys, aKeys, nX) .and. !::IsJumping()
            ::lIsJumping := .T.
            ::nDy := -JUMP_SPEED * 2
            ::SetState("jumping")
            lIdle := .F.
        EndIf

        If ::CheckKey('a', oKeys, aKeys, nX)
            ::cDirection := "L"
            nXPos -= SPEED
            ::SetState("walking")
            lIdle := .F.
        EndIf

        If ::CheckKey('d', oKeys, aKeys, nX)
            ::cDirection := "R"
            nXPos += SPEED
            ::SetState("walking")
            lIdle := .F.
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

    If lIdle
        ::SetState("idle")
    EndIf

    nXPos += ::nDX

    If nXPos <= ::oGameObject:nWidth
        nXPos := ::oGameObject:nWidth
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
            aNewXY := ::SolveCollision(aColliders[nX], aNewXY[1], aNewXY[2])
        Next
    EndIf

    ::oGameObject:nLeft := aNewXY[1]
    ::oGameObject:nTop := aNewXY[2]

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


        If cState == "walking"

            cStyle := "QFrame{ image: url("+::GetNextFrame()+"); border-style: none; }"
            ::oGameObject:SetCss(cStyle)

        ElseIf (cState == "jumping" .or. cState == "idle") .and. ::nCurrentFrame != 1

            ::nCurrentFrame := 1

            cStyle := "QFrame{ image: url("+IIF(::cDirection == "L", ::aFramesBackward[::nCurrentFrame], ::aFramesForward[::nCurrentFrame])+");"
            cStyle += "border-style: none;}"
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
Method GetNextFrame() Class Player

    Local lChangedDirection as logical

    lChangedDirection := ::cLastDirection != ::cDirection

    If ::nCurrentFrame == Len(::aFramesForward) .or. lChangedDirection
        ::nCurrentFrame := 1
    Else
        ::nCurrentFrame++
    EndIf

Return IIF(::cDirection == "L", ::aFramesBackward[::nCurrentFrame], ::aFramesForward[::nCurrentFrame])

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

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
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
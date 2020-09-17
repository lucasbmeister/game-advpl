#include "totvs.ch"

#DEFINE SPEED 4
#DEFINE MAX_JUMP 60
#DEFINE JUMP_SPEED 4
#DEFINE ANIMATION_DELAY 100 //ms

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/

Class Player From BaseGameObject

    Data oPlayerObject
    Data cDirection
    Data cLastDirection
    Data lIsJumping
    Data lIsGrounded
    Data lIsFalling
    Data cCurrentState
    Data nCurrentHeight
    Data nCurrentFrame
    Data nLastFrameTime

    Method New() Constructor
    Method Update()
    Method Jump()
    Method Move()
    Method IsJumping()
    Method ApplyGravity()
    Method IsGrounded()
    Method IsFalling()
    Method Animate()
    Method SetState()
    Method GetCurrentState()
    Method GetNextFrame()
    Method HideGameObject()

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
    ::lIsGrounded := .T.
    ::lIsFalling := .F.
    ::nCurrentHeight := 0
    ::cCurrentState := "idle"

    ::nCurrentFrame := 1
    ::nLastFrameTime := 0

    ::LoadFrames("player")

   // cStyle := "QFrame{ border-style:solid; border-width:3px; border-color:#FF0000; background-color:#00FF00 }"
    cStyle := "QFrame{ image: url("+::aFramesForward[::nCurrentFrame]+"); border-style: none }"
    
    ::cDirection := "R"
    ::cLastDirection := "R"

    oInstance := Self

    ::oPlayerObject := TPanelCss():New(227, 150, , oInstance:oWindow,,,,,, 050, 050)
    ::oPlayerObject:SetCss(cStyle)

Return Self
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update(oGameManager) Class Player

    Local cKey as char

    cKey := oGameManager:GetLastKey()

    If ::IsGrounded()
        If cKey == 'W'
            ::Jump()
            ::SetState("jumping")
        ElseIf cKey == 'A'
            ::cDirection := "L"
            ::oPlayerObject:nLeft -= SPEED
            ::SetState("walking")
        ElseIf cKey == 'D'
            ::cDirection := "R"
            ::oPlayerObject:nLeft += SPEED
            ::SetState("walking")
        ElseIf cKey == "X"
            oGameManager:LoadScene("level_2")
            Return
        Else
            ::SetState("idle")
        EndIf

    ElseIf !::IsGrounded() .and. ::IsJumping()
        ::Jump()
    Else
        ::ApplyGravity()
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
Method Jump() Class Player

    ::lIsJumping := .T.
    ::lIsGrounded := .F.

    If ::cDirection == "R"
        ::oPlayerObject:nLeft += SPEED
    Else
        ::oPlayerObject:nLeft -= SPEED
    EndIf

    If ::nCurrentHeight < MAX_JUMP .and. !::IsFalling()
        ::oPlayerObject:nTop -= JUMP_SPEED
        ::nCurrentHeight += JUMP_SPEED
    Else
        ::lIsFalling := .T.
        ::oPlayerObject:nTop += JUMP_SPEED
        ::nCurrentHeight -= JUMP_SPEED
    EndIf

    If ::nCurrentHeight == 0
        ::lIsGrounded := .T.
        ::lIsFalling := .F.
    EndIf

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
Method ApplyGravity() Class Player

Return

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
Method IsFalling() Class Player
Return ::lIsFalling

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
        
        cState := ::GetCurrentState()
    

        If cState == "walking"

            cStyle := "QFrame{ image: url("+::GetNextFrame()+"); border-style: none; }"
            ::oPlayerObject:SetCss(cStyle)

        ElseIf (cState == "jumping" .or. cState == "idle") .and. ::nCurrentFrame != 1

            ::nCurrentFrame := 1

            cStyle := "QFrame{ image: url("+IIF(::cDirection == "L", ::aFramesBackward[::nCurrentFrame], ::aFramesForward[::nCurrentFrame])+");"
            cStyle += "border-style: none;}"
            ::oPlayerObject:SetCss(cStyle)

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
Method GetCurrentState() Class Player
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

   ::oPlayerObject:Hide()
    FreeObj(::oPlayerObject)

Return
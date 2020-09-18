#include "totvs.ch"

#DEFINE SPEED 4
#DEFINE MAX_JUMP 60
#DEFINE JUMP_SPEED 4
#DEFINE ANIMATION_DELAY 100 //ms

#DEFINE X_POS 1
#DEFINE Y_POS 2
#DEFINE HEIGHT 3
#DEFINE WIDTH 4
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
    Data lIsFalling
    Data cCurrentState
    Data nCurrentHeight
    Data nCurrentFrame
    Data nLastFrameTime
    Data aLastPosition

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
    Method GetState()
    Method GetNextFrame()
    Method HideGameObject()
    Method SavePosition()
    Method MoveBack()

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
    ::aLastPosition := Array(4)

    oInstance := Self
    ::SetSize(050, 050)
    ::oGameObject := TPanelCss():New(227, 150, , oInstance:oWindow,,,,,, 050, 050)
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

    Local cKey as char
    Local aCollision as array

    cKey := oGameManager:GetLastKey()
    ::SavePosition()

    If ::IsGrounded()
        If cKey == 'W'
            ::Jump()
            ::SetState("jumping")
        ElseIf cKey == 'A'
            ::cDirection := "L"
            ::oGameObject:nLeft -= SPEED
            ::SetState("walking")
        ElseIf cKey == 'D' 
            ::cDirection := "R"
            ::oGameObject:nLeft += SPEED
            ::SetState("walking")
        ElseIf cKey == "X"
            If oGameManager:GetActiveScene():GetSceneID() == "level_1"
                oGameManager:LoadScene("level_2")
            Else
                oGameManager:LoadScene("level_1")
            EndIf
            Return
        Else
            ::SetState("idle")
        EndIf

    ElseIf !::IsGrounded() .and. ::IsJumping()
        ::Jump()
    Else
        ::ApplyGravity()
    EndIf

    aCollision := oGameManager:CheckCollision(::GetPosition())

    If aCollision[1]
        ::MoveBack()
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
        ::oGameObject:nLeft += SPEED
    Else
        ::oGameObject:nLeft -= SPEED
    EndIf

    If ::nCurrentHeight < MAX_JUMP .and. !::IsFalling()
        ::oGameObject:nTop -= JUMP_SPEED
        ::nCurrentHeight += JUMP_SPEED
    Else
        ::lIsFalling := .T.
        ::oGameObject:nTop += JUMP_SPEED
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
Method MoveBack() Class Player
    ::oGameObject:nTop := ::aLastPosition[X_POS]
    ::oGameObject:nLeft := ::aLastPosition[Y_POS]
    ::oGameObject:nHeight := ::aLastPosition[HEIGHT]
    ::oGameObject:nWidth := ::aLastPosition[WIDTH]
Return

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SavePosition() Class Player
    Local aPosition as array

    aPosition := ::GetPosition()
    ::aLastPosition[X_POS] := aPosition[X_POS]
    ::aLastPosition[Y_POS] := aPosition[Y_POS]
    ::aLastPosition[HEIGHT] := ::oGameObject:nHeight
    ::aLastPosition[WIDTH] := ::oGameObject:nWidth

Return


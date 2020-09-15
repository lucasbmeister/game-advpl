#include "totvs.ch"

#DEFINE SPEED 4
#DEFINE MAX_JUMP 60
#DEFINE JUMP_SPEED 4
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Class Player From BaseGameObject

    Data oPlayerObject
    Data cDirection
    Data lIsJumping
    Data lIsGrounded
    Data lIsFalling
    Data nCurrentHeight

    Method New() Constructor
    Method Update()
    Method Jump()
    Method Move()
    Method IsJumping()
    Method ApplyGravity()
    Method IsGrounded()
    Method IsFalling()

EndClass
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method New(oWindow, cName) Class Player

    Local cStyle as char 
    Static oInstance as object

    _Super:New(oWindow)

    ::lIsJumping := .F.
    ::lIsGrounded := .T.
    ::lIsFalling := .F.
    ::nCurrentHeight := 0

   // cStyle := "QFrame{ border-style:solid; border-width:3px; border-color:#FF0000; background-color:#00FF00 }"
    cStyle := "QFrame{ image: url("+StrTran(::GetAssetsPath("player.gif"),"\","/")+"); border-style: none }"
    
    ::cDirection := "R"

    oInstance := Self

    //::oPlayerObject := TPanel():New(01, 10, cName, oInstance:oWindow,, .T.,, CLR_YELLOW, CLR_BLUE, 050, 050)
    ::oPlayerObject := TPanelCss():New(200, 150, , oInstance:oWindow,,,,,, 050, 050)
    ::oPlayerObject:SetCss(cStyle)
Return Self
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method Update(oGameManager) Class Player

    Local cKey as char

    cKey := oGameManager:GetLastKey()

    If ::IsGrounded()
        If cKey == 'W'
            ::Jump()
        ElseIf cKey == 'A'
            ::cDirection := "L"
            ::oPlayerObject:nLeft -= SPEED
        ElseIf cKey == 'S'
            //::oPlayerObject:nTop += SPEED
        ElseIf cKey == 'D'
            ::cDirection := "R"
            ::oPlayerObject:nLeft += SPEED
        EndIf
    ElseIf !::IsGrounded() .and. ::IsJumping()
        ::Jump()
    Else
        ::ApplyGravity()
    EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
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
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method IsJumping() Class Player
Return ::lIsJumping

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method ApplyGravity() Class Player

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method IsGrounded() Class Player
Return ::lIsGrounded
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method IsFalling() Class Player
Return ::lIsFalling
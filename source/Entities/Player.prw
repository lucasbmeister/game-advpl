#include "totvs.ch"
#include "gameadvpl.ch"

#DEFINE SPEED 4
#DEFINE MAX_JUMP 60
#DEFINE JUMP_SPEED 8
#DEFINE ANIMATION_DELAY 80 //ms
#DEFINE GRAVITY 1
#DEFINE FOOTSTEP_DELAY 500

/*
{Protheus.doc} Class Player
Classe que contém a lógica do personagem controlado pelo usuário
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
    Data nLastFootstep
    Data nLastFootstepTime
    Data oEnemyCollided

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
    Method PlaySound()
    Method IsMidFrame()
    Method Attack()
    Method IsDead()
    Method UpdateLife() 

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth, cName )
Instância classe PLayer
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
    ::cTag := 'player'

    ::nCurrentFrame := 1
    ::nLastFootstep := 0
    ::nLastFrameTime := 0
    ::nLastFootstepTime := 0
    ::LoadFrames("player")

    cStyle := "TPanel { border-image: url("+::oAnimations[::cCurrentState][::cDirection][::nCurrentFrame]+") 0 stretch; }"

    oInstance := Self

    //::oGameObject := TPanelCss():New(nTop, nLeft, , oInstance:oWindow,,,,,, nWidth, nHeight)
    ::oGameObject := TPanel():New(nTop,nLeft, cName,oInstance:oWindow,,,,,,nWidth,nHeight)
    ::oGameObject:SetCss(cStyle)

Return Self

/*
{Protheus.doc} Method Update(oGameManager)
Executa a lógica de atualização por frame
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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

    If oGameManager:GetLife() <= 0
        ::SetState('death')
    EndIf

    If ::IsDead()
        ::cLastState := ::cCurrentState
        If !::IsLastFrame('death')
            ::Animate()
            Return
        Else
            oGameManager:GameOver()
            Return
        EndIf
    EndIf

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

    ::Animate(oGameManager)
    ::cLastDirection := ::cDirection
    ::cLastState := ::cCurrentState
    ::oEnemyCollided := nil

Return

/*
{Protheus.doc} Method IsJumping()
Verifica se o jogador está pulando
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsJumping() Class Player
Return ::lIsJumping

/*
{Protheus.doc} Method CheckKey(cKey, oKeys, aKeys, nPos)
(depreciada) Verifica se tecla está pressionada
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method CheckKey(cKey, oKeys, aKeys, nPos) Class Player
Return aKeys[nPos] == cKey .and. oKeys[cKey]

/*
{Protheus.doc} Method IsGrounded()
Verifica se jogador está sobre piso
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsGrounded() Class Player
Return ::lIsGrounded

/*
{Protheus.doc} Method Animate()
Realiza a animação do personagem ed acordo com o frame corrente
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Animate(oGameManager) Class Player

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
            
            If 'attacking' $ cState .and. ::IsMidFrame() .and. !Empty(::oEnemyCollided)
                ::Attack(::oEnemyCollided)
                ::oEnemyCollided := nil
            EndIf

        EndIf
        ::nLastFrameTime := nTime
    EndIf

    ::PlaySound(cState, nTime, oGameManager)

Return

/*
{Protheus.doc} Method SetState(cState)
Define qual o estado atual do personagem
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetState(cState) Class Player
    ::cCurrentState := cState
Return

/*
{Protheus.doc} Method GetState()
Retorna o estado atual do personagem
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetState() Class Player
Return ::cCurrentState

/*
{Protheus.doc} Method GetNextFrame(cState)
Busca o caminho do próximo sprite de acordo com o frame atual
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
{Protheus.doc} Method HideGameObject()
Destrói o objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class Player

    ::oGameObject:Hide()
    ::HideEditorCollider()
    FreeObj(::oGameObject)

Return

/*
{Protheus.doc} Method IsOutOfBounds()
Verifica se o personagem está abaixo do limite da área de jogo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsOutOfBounds() Class Player
Return ::oGameObject:nTop > ::oWindow:nHeight

/*
{Protheus.doc} Method SolveCollision(oObject, nXPos, nYPos)
Realiza a detecção de colisão e retorna posição de acordo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
        ElseIf ::oGameObject:nLeft + nWidth + ::nRightMargin == nObjLeft .or. ::oGameObject:nLeft /*+ ::nRightMargin*/ == nObjRight
            nXPos := ::oGameObject:nLeft /* + ::nLeftMargin   */

            If 'enemy' $ cTag 
                ::oEnemyCollided := oObject
            EndIf

        ElseIf nPlayerRight > nObjLeft .and. nPlayerLeft < nObjRight .and. nPlayerBottom > nObjTop .and. nPlayerTop < nObjBottom
            //check on which side the player collides with the object
            aSides := { Abs(nPlayerBottom - nObjTop), Abs(nPlayerRight - nObjLeft), Abs(nPlayerTop - nObjBottom), Abs(nPlayerLeft - nObjRight)}

            nSide := MinArr(aSides) //returns the side with the smallest distance between player and object

            If nSide == aSides[TOP] //first check top, than left
                nYPos := nObjTop - nHeight /*+ ::nTopMargin*/
            ElseIf nSide == aSides[LEFT] 
                nXPos := nObjLeft - nWidth + ::nLeftMargin

                If 'enemy' $ cTag 
                    ::oEnemyCollided := oObject
                EndIf

            ElseIf nSide == aSides[BOTTOM] //first check bottom, than right
                nYPos := nObjBottom
            ElseIf nSide == aSides[RIGHT] 
                nXPos := nObjRight + ::nRightMargin

                If 'enemy' $ cTag 
                    ::oEnemyCollided := oObject
                EndIf
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
{Protheus.doc} Static Function MinArr(aValues)
Retorna menor valor de um array
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
{Protheus.doc} Method SetDirection(cDirection)
Define qual a direção atual do personagem
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetDirection(cDirection) Class Player
    ::cDirection := cDirection
Return

/*
{Protheus.doc} Method IsAttacking()
Verifica se o personagem está atacando
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsAttacking() Class Player
Return 'attacking' $ ::GetState()

/*
{Protheus.doc} Method IsBlocking()
Verifica se jogador está bloqueando
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsBlocking() Class Player
Return ::GetState() == 'block'

/*
{Protheus.doc} Method IsLastFrame(cState)
Verifica se o frame da animação é o último da sequência
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsLastFrame(cState) Class Player
Return ::nCurrentFrame >= Len(::oAnimations[cState][::cDirection]) .and. ::cLastState == cState

/*
{Protheus.doc} Method PlaySound(cState, nTime, oGameManager) Class Player
Executa som de acordo com o estado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method PlaySound(cState, nTime, oGameManager) Class Player

    If cState == 'running' .and. nTime - ::nLastFootstepTime >= FOOTSTEP_DELAY .and. !::IsJumping()
        If ::nLastFootstep == 2
            ::nLastFootstep := 1
        Else
            ::nLastFootstep := 2
        EndIf
        oGameManager:PlaySound('footstep_' + cValToChar(::nLastFootstep))
        ::nLastFootstepTime := nTime
    EndIf

Return

/*
{Protheus.doc} Method IsMidFrame() Class Player
Retorna se está no meio da animação
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsMidFrame() Class Player

    Local cState as char
    Local nTotalFrames as numeric

    cState := ::GetState()
    nTotalFrames := Len(::oAnimations[cState][::cDirection])

Return Int(nTotalFrames / 2) == ::nCurrentFrame

/*
{Protheus.doc} Method Attack(oObjectAttacked) Class Player
Realiza o ataque no inimigo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Attack(oObjectAttacked) Class Player

    Local nAttack as numeric
    Local cState as char

    cState := ::GetState()

    Do Case
        Case cState == 'attacking_1'
            nAttack := -10
        Case cState == 'attacking_2'
            nAttack := -20
        Case cState == 'attacking_3'
            nAttack := -30           
    EndCase
    oObjectAttacked:UpdateLife(nAttack)
Return

/*
{Protheus.doc} Method IsDead() Class Player
Retorna se player está morto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsDead() Class Player
Return ::GetState() == 'death'

/*
{Protheus.doc} Method SetupHealthBar() Class Player
Monta barra de saúde do inimigo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method UpdateLife(nValue, oGame) Class Player

    Local nLife as numeric

    nValue := nValue - IIF(::GetState() == 'block', 5, 0)

    nLife := oGame:UpdateLife(nValue)

    If nLife <= 0
        ::SetState('death')
        ::lHasCollider := .F.
    EndIf

Return
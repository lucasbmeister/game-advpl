#include "totvs.ch"
#include "gameadvpl.ch"

#DEFINE SPEED 2
#DEFINE ANIMATION_DELAY 80 //ms
#DEFINE ATTACK_COOLDOWN 3000 //ms
#DEFINE GRAVITY 1

/*
{Protheus.doc} Class Enemy
Classe que contém a lógica de inimigos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
    Data nLife
    Data nLifeTotal
    Data oHealthBar
    Data oPlayerCollided
    Data lAttackFirstFrame
    Data lSpawn

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
    Method SetupHealthBar()
    Method UpdateLife()
    Method IsDead()
    Method IsMidFrame()
    Method Attack()
    Method UpdateHealthBarPosition() 

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth, cName )
Instância a classe de inimigos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth, cName ) Class Enemy

    Local cStyle as char
    Static oInstance as object

    Default nTop := 100
    Default nLeft := 150
    Default nHeight := 50
    Default nWidth := 80

    _Super:New(oWindow)

    ::lIsGrounded := .F.
    ::cLastState := ::cCurrentState := "idle"
    ::cDirection := ::cLastDirection := "backward"

    ::nCurrentFrame := 1
    ::nLastFrameTime := 0
    ::nLastAttackTime := 0
    ::cTag := 'enemy'
    ::nLife := 50
    ::nLifeTotal := 50
    ::lAttackFirstFrame := .F.
    ::lSpawn := .T.
    ::LoadFrames("player")

    cStyle := "TPanel { border-image: url("+::oAnimations[::cCurrentState][::cDirection][::nCurrentFrame]+") 0 stretch; }"

    oInstance := Self

    ::oGameObject := TPanel():New(nTop, nLeft, cName, oInstance:oWindow,,,,,, nWidth, nHeight)
    ::oGameObject:SetCss(cStyle)

    ::SetupHealthBar()

Return Self

/*
{Protheus.doc} Method Update(oGameManager)
Executa a lógica de atualização por frame
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update(oGameManager) Class Enemy

    Local aColliders as array
    Local nX as numeric
    Local nXPos as numeric
    Local nYPos as numeric
    Local nXOri as numeric
    Local nYOri as numeric
    Local aNewXY as array

    ::nTime := TimeCounter()

    If ::IsDead()
        ::cLastState := ::cCurrentState
        If !::IsLastFrame('death')
            ::Animate()
            Return
        Else
            ::HideGameObject()
            Return
        EndIf
    EndIf

    nXPos := nXOri := ::oGameObject:nLeft
    nYPos := nYOri := ::oGameObject:nTop

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
                    ::lSpawn := .F.
                EndIf
            EndIf
        Next
    EndIf

    If ::nDY > 0 .and. !::lSpawn
        If ::cDirection == 'forward'
            ::SetDirection('backward')
            aNewXY[1] -= SPEED
        Else
            ::SetDirection('forward')
            aNewXY[1] += SPEED
        EndIf
        aNewXY[2] -= ::nDY
    EndIf

    ::oGameObject:nLeft := aNewXY[1]
    ::oGameObject:nTop := aNewXY[2]

    ::UpdateHealthBarPosition() 

    If ::IsOutOfBounds()
        ::HideGameObject()
        Return
    EndIF

    If nXOri == ::oGameObject:nLeft .and. nYOri == ::oGameObject:nTop .and. !::IsAttacking()
        ::SetState("idle")
    EndIf

    ::Animate(oGameManager)
    ::cLastDirection := ::cDirection
    ::cLastState := ::cCurrentState

Return

/*
{Protheus.doc} Method IsGrounded()
Retorna se o personagem está sobre algum piso
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsGrounded() Class Enemy
Return ::lIsGrounded

/*
{Protheus.doc} Method Animate()
Realiza a animação do personagem ed acordo com o frame corrente
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Animate(oGame) Class Enemy

    Local cState as char
    Local cStyle as char

    If ::nTime - ::nLastFrameTime >= ANIMATION_DELAY .or. ::lAttackFirstFrame

        cState := ::GetState()

        If ::IsAttacking() .and. ::lAttackFirstFrame
            ::lAttackFirstFrame := .F.
        EndIF

        If ::IsLastFrame(cState) .and. ::IsAttacking()
            ::SetState('idle')
            ::nLastAttackTime := ::nTime
        EndIf

        cStyle := "TPanel { border-image: url("+::GetNextFrame(::GetState())+") 0 0 0 0 stretch}"
        //cStyle := "TPanel { border: 1 solid black }"
        //cStyle := "QFrame{ background-image: url("+::GetNextFrame(cState)+"); background-repeat: no-repeat, no-repeat; background-size: cover; background-position: center; height: 100%; width: 100%;}"
        ::oGameObject:SetCss(cStyle)

        If 'attacking' $ cState .and. ::IsMidFrame() .and. !Empty(::oPlayerCollided)
            ::Attack(::oPlayerCollided, oGame)
            ::oPlayerCollided := nil
        EndIf

        ::nLastFrameTime := ::nTime
    EndIf

Return

/*
{Protheus.doc} Method SetState(cState)
Define qual o estado atual do personagem
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetState(cState) Class Enemy
    ::cCurrentState := cState
Return

/*
{Protheus.doc} Method GetState()
Retorna o estado atual do personagem
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetState() Class Enemy
Return ::cCurrentState

/*
{Protheus.doc} Method GetNextFrame(cState)
Busca o caminho do próximo sprite de acordo com o frame atual
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
{Protheus.doc} Method HideGameObject()
Destrói o objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideGameObject() Class Enemy

    ::oGameObject:Hide()
    ::oHealthBar:HideGameObject()
    FreeObj(::oHealthBar)
    ::HideEditorCollider()
    ::Destroy()
    // FreeObj(::oGameObject)

Return

/*
{Protheus.doc} Method IsOutOfBounds()
Verifica se o personagem está abaixo do limite da área de jogo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsOutOfBounds() Class Enemy
Return ::oGameObject:nTop > ::oWindow:nHeight

/*
{Protheus.doc} Method SolveCollision(oObject, nXPos, nYPos)
Realiza a detecção de colisão e altera o estado do personagem de acordo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
    If nEnemyRight >= nObjLeft .and. nEnemyLeft <= nObjRight .and. nEnemyBottom >= nObjTop .and. nEnemyTop <= nObjBottom .and. cTag != 'enemy'

        //player is already colliding with top or bottom side of object
        If (lOnTop := ::oGameObject:nTop + nHeight /*+ ::nTopMargin*/ == nObjTop) .or. ::oGameObject:nTop - nHeight /*+ ::nBottomMargin*/ == nObjBottom
            nYPos := ::oGameObject:nTop /*+ ::nTopMargin*/

            //player is already colliding with left or right side of object
        ElseIf ::oGameObject:nLeft + nWidth + ::nLeftMargin == nObjLeft .or. ::oGameObject:nLeft - nWidth /*+ ::nRightMargin*/ == nObjRight
            nXPos := ::oGameObject:nLeft /* + ::nLeftMargin  */

            If 'player' $ cTag 
                ::oPlayerCollided := oObject
            Else
                ::SetDirection(IIF(::cDirection == 'forward', 'backward', 'forward'))
            EndIf

        ElseIf nEnemyRight > nObjLeft .and. nEnemyLeft < nObjRight .and. nEnemyBottom > nObjTop .and. nEnemyTop < nObjBottom
            //check on which side the player collides with the object
            aSides := { Abs(nEnemyBottom - nObjTop), Abs(nEnemyRight - nObjLeft), Abs(nEnemyTop - nObjBottom), Abs(nEnemyLeft - nObjRight)}

            nSide := MinArr(aSides) //returns the side with the smallest distance between player and object

            If nSide == aSides[TOP] //first check top, than left
                nYPos := nObjTop - nHeight /*+ ::nTopMargin*/
            ElseIf nSide == aSides[LEFT]
                nXPos := nObjLeft - nWidth + ::nLeftMargin

                If 'player' $ cTag 
                    ::oPlayerCollided := oObject
                Else
                    ::SetDirection('backward')
                EndIf

            ElseIf nSide == aSides[BOTTOM] //first check bottom, than right
                nYPos := nObjBottom + nHeight/* + ::nBottomMargin*/
            ElseIf nSide == aSides[RIGHT] 
                nXPos := nObjRight + ::nRightMargin

                If 'player' $ cTag 
                    ::oPlayerCollided := oObject
                Else
                    ::SetDirection('forward')
                EndIf
            EndIf

            ::nDY := 0
        EndIf

        If !lOnTop
            If cTag == 'player' .and. !::IsAttacking() .and. ::nTime - ::nLastAttackTime  >= ATTACK_COOLDOWN
                ::SetState('attacking_' + cValToChar(Randomize(1, 3)))
                ::lAttackFirstFrame := .T.
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

        // If ((nXPos <= nObjLeft .and. ::cDirection == 'backward') .or. (nXPos >= nObjRight .and. ::cDirection == 'forward'))  .and. !::IsAttacking() 
        //     ::SetDirection(IIF(::cDirection == 'forward', 'backward', 'forward'))
        // EndIF

        ::nDY := 0
    EndIf

Return {nXPos, nYPos, lIsGrounded}

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
Method SetDirection(cDirection) Class Enemy
    ::cDirection := cDirection
Return

/*
{Protheus.doc} Method IsAttacking()
Verifica se o personagem está atacando
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsAttacking() Class Enemy
Return 'attacking' $ ::GetState()

/*
{Protheus.doc} Method IsLastFrame(cState)
Verifica se o frame da animação é o último da sequência
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsLastFrame(cState) Class Enemy
Return ::nCurrentFrame >= Len(::oAnimations[cState][::cDirection]) .and. ::cLastState == cState

/*
{Protheus.doc} Method SetupHealthBar() Class Enemy
Monta barra de saúde do inimigo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetupHealthBar() Class Enemy
    ::oHealthBar := HealthBar():New(::oWindow, (::oGameObject:nTop / 2), (::oGameObject:nLeft / 2) + 15)
Return

/*
{Protheus.doc} Method UpdateHealthBarPosition() Class Enemy
Mantém health bar acima do inimigo enquanto ele se move
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method UpdateHealthBarPosition() Class Enemy

    ::oHealthBar:SetTopPosition(::oGameObject:nTop)
    ::oHealthBar:SetLeftPosition(::oGameObject:nLeft + 30)

Return

/*
{Protheus.doc} Method SetupHealthBar() Class Enemy
Monta barra de saúde do inimigo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method UpdateLife(nValue) Class Enemy
    ::nLife += nValue

    If ::nLife <= 0
        ::SetState('death')
        ::lHasCollider := .F.
    EndIf

    ::oHealthBar:UpdateLifeBar(nValue, ::nLifeTotal)

Return

/*
{Protheus.doc} Method IsDead() Class Enemy
Retorna se inimigo está morto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsDead() Class Enemy
Return ::GetState() == 'death'

/*
{Protheus.doc} Method IsMidFrame() Class Enemy
Retorna se está no meio da animação
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsMidFrame() Class Enemy

    Local cState as char
    Local nTotalFrames as numeric

    cState := ::GetState()
    nTotalFrames := Len(::oAnimations[cState][::cDirection])

Return Int(nTotalFrames / 2) == ::nCurrentFrame

/*
{Protheus.doc} Method Attack(oObjectAttacked) Class Enemy
Ataca o player
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Attack(oObjectAttacked, oGameManager) Class Enemy

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
    oObjectAttacked:UpdateLife(nAttack, oGameManager)
Return
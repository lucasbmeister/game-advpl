#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} User Function LoadLvl2(oLevel, oGame)
Monta cena do nível 2
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
User Function LoadLvl2(oLevel, oGame)

    Local oWindow as object
    Local oPlayer as object

    oWindow := oLevel:GetSceneWindow()

    oPlayer := Player():New(oWindow, "Lucas", 50, 50, 50, 80)
    oPlayer:SetTag('player')
    oPlayer:SetColliderMargin(10, 60, -5, -60)

    oLevel:AddObject(oPlayer)

Return

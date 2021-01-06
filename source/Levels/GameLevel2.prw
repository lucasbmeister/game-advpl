#include "totvs.ch"
#include "gameadvpl.ch"
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
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

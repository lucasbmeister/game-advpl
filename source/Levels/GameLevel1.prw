#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} User Function LoadLvl1(oLevel, oGame)
Monta cena do nível 1
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
User Function LoadLvl1(oLevel, oGame)

    Local aDimensions as array
    Local oWindow as object
    Local oSky as object
    Local oGround1 as object
    Local oGround2 as object
    Local oGround3 as object
    Local oGround4 as object
    Local oGround5 as object
    Local oGround6 as object
    Local oGround7 as object
    Local oGround8 as object
    Local oFGround1 as object
    Local oFGround2 as object
    Local oFGround3 as object
    Local oPlayer as object
    Local oEnemy as object
    Local oClouds as object
    Local oStartWall as object
    Local oEndWall as object
    Local oCoin1 as object
    Local oPlayerLife as object
    Local oPlayerScore as object

    aDimensions := oLevel:GetDimensions()
    oWindow := oLevel:GetSceneWindow()

    oSky := Sky():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oSky:SetTag('background')

    oGround1 := Ground():New(oWindow, 260, 0, 42, 110)
    oGround1:SetTag('ground')
    oGround1:SetColliderMargin(25, 0, 0, 0)

    oGround2 := Ground():New(oWindow, 260, 110, 42, 110)
    oGround2:SetTag('ground')
    oGround2:SetColliderMargin(25, 0, 0, 0)

    oGround3 := Ground():New(oWindow, 260, 220, 42, 110)
    oGround3:SetTag('ground')
    oGround3:SetColliderMargin(25, 0, 0, 0)

    oGround4 := Ground():New(oWindow, 260, 330, 42, 110)
    oGround4:SetTag('ground')
    oGround4:SetColliderMargin(25, 0, 0, 0)

    oGround5 := Ground():New(oWindow, 260, 440, 42, 110)
    oGround5:SetTag('ground')
    oGround5:SetColliderMargin(25, 0, 0, 0)

    oGround6 := Ground():New(oWindow, 260, 550, 42, 110)
    oGround6:SetTag('ground')
    oGround6:SetColliderMargin(25, 0, 0, 0)

    oGround7 := Ground():New(oWindow, 229, 440, 42, 110)
    oGround7:SetTag('ground')
    oGround7:SetColliderMargin(25, 0, 0, 0)

    oGround8 := Ground():New(oWindow, 229, 550, 42, 110)
    oGround8:SetTag('ground')
    oGround8:SetColliderMargin(25, 0, 0, 0)

    oFGround1 := FloatingGround():New(oWindow, 198, 330, 42, 110, 1)
    oFGround1:SetTag('floating_ground')
    oFGround1:SetColliderMargin(35, 0, 0, 0)

    oFGround2 := FloatingGround():New(oWindow, 136, 220, 42, 80, 2)
    oFGround2:SetTag('floating_ground')
    oFGround2:SetColliderMargin(50, 0, 0, 0)

    oFGround3 := FloatingGround():New(oWindow, 136, 110, 42, 30, 3)
    oFGround3:SetTag('floating_ground')
    oFGround3:SetColliderMargin(35, 0, 0, 0)

    oEnemy := Enemy():New(oWindow, 50, 60, 50, 80, "Excel")
    oEnemy:SetTag('enemy')
    oEnemy:SetColliderMargin(25, 50, 0, -50)

    oPlayer := Player():New(oWindow, 50, 200, 50, 80, "Protheus")
    oPlayer:SetTag('player')
    oPlayer:SetColliderMargin(25, 50, 0, -50)

    oClouds := Clouds():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])

    oCoin1 := Coin():New(oWindow,250, 60, 10, 10)

    oStartWall := Square():New(oWindow, 1, -15, aDimensions[HEIGHT], 10)
    oStartWall:SetTag('startwall')
    oStartWall:SetInvisible(.T.)
    oStartWall:SetColliderMargin(0, 0, 0, 0)

    oEndWall := Square():New(oWindow, 1, (aDimensions[WIDTH] / 2) - 15, aDimensions[HEIGHT], 10)
    oEndWall:SetTag('endwall')
    oEndWall:SetInvisible(.T.)
    oEndWall:SetColliderMargin(0, 0, 0, 0)

    oPlayerLife := PlayerLife():New(oWindow, 5, 5, 30, 60)
    oPlayerLife:SetTag('background')
    oPlayerScore := PlayerScore():New(oWindow, 5, (aDimensions[WIDTH] / 2) - 85, 30, 60)
    oPlayerScore:SetTag('background')

    oGame:SetCameraLimits(oStartWall, oEndWall)

    oGame:UpdateLife(100)
    oGame:UpdateScore(0)
    // adiciona objetos a uma cena, mesmo sem adicionar ele será apresentado, entretanto não será gerenciado
    oLevel:AddObject(oSky)
    oLevel:AddObject(oPlayer)
    oLevel:AddObject(oEnemy)
    oLevel:AddObject(oCoin1)
    oLevel:AddObject(oClouds)
    oLevel:AddObject(oGround1)
    oLevel:AddObject(oGround2)
    oLevel:AddObject(oGround3)
    oLevel:AddObject(oGround4)
    oLevel:AddObject(oGround5)
    oLevel:AddObject(oGround6)
    oLevel:AddObject(oGround7)
    oLevel:AddObject(oGround8)
    oLevel:AddObject(oFGround1)
    oLevel:AddObject(oFGround2)
    oLevel:AddObject(oFGround3)
    oLevel:AddObject(oStartWall)
    oLevel:AddObject(oEndWall)
    oLevel:AddObject(oPlayerLife)
    oLevel:AddObject(oPlayerScore)

Return
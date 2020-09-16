#include "totvs.ch"
#include "protheus.ch"

#DEFINE TOP 1
#DEFINE LEFT 2
#DEFINE BOTTOM 3
#DEFINE RIGHT 4
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Main Function Game2D()

    Local oPlayer as object
    Local oGame as object
    Local oWindow as object
    Local aDimensions as array

    oGame := GameManager():New("Game Teste", 0, 0, 600, 1280)

    oWindow := oGame:GetMainWindow()
    aDimensions := oGame:GetDimensions()

    oSky := Sky():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[BOTTOM], aDimensions[RIGHT])
    oGround := Ground():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[BOTTOM], aDimensions[RIGHT])
    
    oPlayer := Player():New(oWindow, "Lucas")

    // oPanelLeft := SidePanel():New(oWindow, aDimensions[TOP], aDimensions[LEFT], 150, aDimensions[BOTTOM])
    // oPanelRight := SidePanel():New(oWindow, aDimensions[TOP], 500, 150, aDimensions[BOTTOM])

    oClouds := Clouds():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[BOTTOM], aDimensions[RIGHT])

    oGame:AddObject(oSky)
    oGame:AddObject(oPlayer)
    oGame:AddObject(oClouds)
    oGame:AddObject(oGround)
    // oGame:AddObject(oPanelLeft)
    // oGame:AddObject(oPanelRight)

    oGame:Start()

Return  


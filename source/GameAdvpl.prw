#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Main Function GameAdvpl()

    Local oGame as object
    Local oMenu as object
    Local oLevels as object
    Local oLevel1 as object
    Local oLevel2 as object
    Local oWindow as object
    Local aDimensions as array

    // inst�ncia gerenciador do jogo
    oGame := GameManager():New("Game Advpl", 50, 50, 650, 1330)

    // obt�m janela princial onde as cenas ser�o adicionadas
    oWindow := oGame:GetMainWindow()

    // retorna dimens�es de tela do jogo
    aDimensions := oGame:GetDimensions()

    // inst�ncia uma cena (dever� ser atribuida para janela do jogo)
    oMenu := Scene():New(oWindow, "menu", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oMenu:SetInitCodeBlock({|oLevel| U_LoadMenu(oLevel, oGame)})

    oLevels := Scene():New(oWindow, "levels", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oLevels:SetInitCodeBlock({|oLevel| U_LoadLevels(oLevel, oGame)})

    // inst�ncia uma cena (dever� ser atribuida para janela do jogo)
    oLevel1 := Scene():New(oWindow, "level_1", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oLevel1:SetInitCodeBlock({|oLevel| U_LoadLvl1(oLevel, oGame)})
    oLevel1:SetDescription('N�vel 1')

    oLevel2 := Scene():New(oWindow, "level_2", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oLevel2:SetInitCodeBlock({|oLevel| U_LoadLvl2(oLevel, oGame)})
    oLevel2:SetDescription('N�vel 2')

    oEditor := Scene():New(oWindow, "editor", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oEditor:SetInitCodeBlock({|oLevel| U_GameEditor(oLevel, oGame)})
    oEditor:SetDescription('Editor')

    // adiciona cena ao jogo
    oGame:AddScene(oMenu)
    oGame:AddScene(oLevels)
    oGame:AddScene(oEditor)
    oGame:AddScene(oLevel1)
    oGame:AddScene(oLevel2)

    //inicia o jogo passando como par�metro a ID da cena inicial
    oGame:Start(oMenu:GetSceneID())
    //oGame:Start("editor")

Return

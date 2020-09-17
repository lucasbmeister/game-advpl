#include "totvs.ch"
#include "protheus.ch"

#DEFINE TOP 1
#DEFINE LEFT 2
#DEFINE BOTTOM 3
#DEFINE RIGHT 4
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Main Function Game2D()

    Local oGame as object
    Local oScene1 as object
    Local oScene2 as object
    Local oWindow as object
    Local aDimensions as array

    // instância gerenciador do jogo
    oGame := GameManager():New("Game Teste", 50, 50, 650, 1330)

    // obtém janela princial onde as cenas serão adicionadas
    oWindow := oGame:GetMainWindow()

    // retorna dimensões de tela do jogo
    aDimensions := oGame:GetDimensions()

    // instância uma cena (deverá ser atribuida para janela do jogo)
    oScene1 := Scene():New(oWindow, "level_1", aDimensions[TOP], aDimensions[LEFT], aDimensions[BOTTOM], aDimensions[RIGHT])
    oScene1:SetInitCodeBlock({|oScn| LoadScn1(oScn)})
    
    oScene2 := Scene():New(oWindow, "level_2", aDimensions[TOP], aDimensions[LEFT], aDimensions[BOTTOM], aDimensions[RIGHT])
    oScene2:SetInitCodeBlock({|oScn| LoadScn2(oScn)})

    // adiciona cena ao jogo
    oGame:AddScene(oScene1)
    oGame:AddScene(oScene2)

    //inicia o jogo passando como parãmetro a ID da cena inicial
    oGame:Start(oScene1:GetSceneID())

Return  

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function LoadScn1(oScene1)
    
    Local aDimensions as array
    Local oWindow as object
    Local oSky as object
    Local oGround as object
    Local oPlayer as object
    Local oClouds as object

    aDimensions := oScene1:GetDimensions()
    oWindow := oScene1:GetSceneWindow()

    oSky := Sky():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[BOTTOM], aDimensions[RIGHT])
    oGround := Ground():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[BOTTOM], aDimensions[RIGHT])
    
    oPlayer := Player():New(oWindow, "Lucas")

    oClouds := Clouds():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[BOTTOM], aDimensions[RIGHT])

    // adiciona objetos a uma cena
    oScene1:AddObject(oSky)
    oScene1:AddObject(oPlayer)
    oScene1:AddObject(oClouds)
    oScene1:AddObject(oGround)

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function LoadScn2(oScene2)

    Local oWindow as object
    Local oPlayer2 as object

    oWindow := oScene2:GetSceneWindow()
    oPlayer2 := Player():New(oWindow, "Lucas")
    oScene2:AddObject(oPlayer2)

Return
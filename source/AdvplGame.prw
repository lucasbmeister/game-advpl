#include "totvs.ch"
#include "protheus.ch"

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
    oScene1 := Scene():New(oWindow, "level_1", aDimensions[X_POS], aDimensions[Y_POS], aDimensions[HEIGHT], aDimensions[WIDTH])
    oScene1:SetInitCodeBlock({|oScn| LoadScn1(oScn)})
    
    oScene2 := Scene():New(oWindow, "level_2", aDimensions[X_POS], aDimensions[Y_POS], aDimensions[HEIGHT], aDimensions[WIDTH])
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

    oSky := Sky():New(oWindow, aDimensions[X_POS], aDimensions[Y_POS], aDimensions[HEIGHT], aDimensions[WIDTH])

    oGround := Ground():New(oWindow, aDimensions[X_POS], aDimensions[Y_POS], aDimensions[HEIGHT], aDimensions[WIDTH])
    oGround:SetTag('ground')
    
    oPlayer := Player():New(oWindow, "Lucas")
    oPlayer:SetTag('player')

    oClouds := Clouds():New(oWindow, aDimensions[X_POS], aDimensions[Y_POS], aDimensions[HEIGHT], aDimensions[WIDTH])

    oSquare := Square():New(oWindow, 227, 200, 50, 50)
    oSquare:SetColliderSize(50, 50)

    // adiciona objetos a uma cena, mesmo sem adicionar ele será adicionado, entretanto não será gerenciado
    oScene1:AddObject(oSky)
    oScene1:AddObject(oPlayer)
    oScene1:AddObject(oClouds)
    oScene1:AddObject(oGround)
    oScene1:AddObject(oSquare)

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
    oPlayer2:SetTag('player')

    oScene2:AddObject(oPlayer2)

Return
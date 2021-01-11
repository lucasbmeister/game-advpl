#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} Main Function GameAdvpl()
Inicia o jogo. Função principal
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Main Function GameAdvpl()

    Local oGame as object
    Local oMenu as object
    Local oLevels as object
    Local oLevel1 as object
    Local oInteraction as object
    Local oWindow as object
    Local aDimensions as array

    // instância gerenciador do jogo
    oGame := GameManager():New("Game Advpl", 50, 50, 650, 1330)

    // obtém janela princial onde as cenas serão adicionadas
    oWindow := oGame:GetMainWindow()

    // retorna dimensões de tela do jogo
    aDimensions := oGame:GetDimensions()

    // instância uma cena (deverá ser atribuida para janela do jogo)
    oMenu := Scene():New(oWindow, "menu", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oMenu:SetInitCodeBlock({|oLevel| U_LoadMenu(oLevel, oGame)})

    oLevels := Scene():New(oWindow, "levels", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oLevels:SetInitCodeBlock({|oLevel| U_LoadLevels(oLevel, oGame)})

    // instância uma cena (deverá ser atribuida para janela do jogo)
    oLevel1 := Scene():New(oWindow, "level_1", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oLevel1:SetInitCodeBlock({|oLevel| U_LoadLvl1(oLevel, oGame)})
    oLevel1:SetDescription('Nível 1')

    oEditor := Scene():New(oWindow, "editor", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oEditor:SetInitCodeBlock({|oLevel| U_EditorLevel(oLevel, oGame)})
    oEditor:SetDescription('Editor')

    oInteraction := Scene():New(oWindow, "interaction", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
    oInteraction:SetInitCodeBlock({|oLevel| U_LoadInteracion(oLevel, oGame)})

    // adiciona cena ao jogo
    oGame:AddScene(oInteraction)
    oGame:AddScene(oMenu)
    oGame:AddScene(oLevels)
    oGame:AddScene(oEditor)
    oGame:AddScene(oLevel1)

    U_LoadEditorScenes(oWindow, oGame, aDimensions)

    //inicia o jogo passando como parãmetro a ID da cena inicial
    oGame:Start(oInteraction:GetSceneID())
    //oGame:Start("editor")

Return

/*
{Protheus.doc} Static Function LoadEditorScenes(nLine, nCol)
Carrega cenas do editor no GameManager
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
User Function LoadEditorScenes(oWindow, oGame, aDimensions)

    Local nX as numeric
    Local aFiles as array
    Local oScene as object
    Local oJson as object

    aFiles := GetSceneFiles()

    For nX := 1 To Len(aFiles)
        oJson := U_SceneFromJson(aFiles[nX])
        
        If AScan(oGame:aScenes, {|x| x:GetSceneID() == oJson['sceneId']}) == 0
            oScene := Scene():New(oWindow, oJson['sceneId'], aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
            oScene:SetEditorScene(.T.)
            oScene:SetSceneJson(aFiles[nX])
            oScene:SetGameManager(oGame)
            oScene:SetDescription(oJson['sceneDescription'])

            oGame:AddScene(oScene)
        EndIf
    Next

Return

/*
{Protheus.doc} Static Function SceneFromJson()
Carrega objeto json da cena com base no caminho do parâmetro
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
User Function SceneFromJson(cFilePath)

    Local oScene as object
    Local nHandle as numeric
    Local cJson as char

    nHandle := FT_FUse(cFilePath)

    cJson := ''

    FT_FGoTop()

    While !FT_FEoF()
        cJson += FT_FReadLn()
        FT_FSkip()
    EndDo

    oScene := JsonObject():New()

    oScene:FromJson(cJson)

    FClose(nHandle)

Return oScene

/*
{Protheus.doc} Static Function GetSceneFiles()
Retorna lista de cenas do editor existentes
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Static Function GetSceneFiles()

    Local aFiles as array
    Local aSizes as array
    Local cPath as char
    Local nX as numeric

    cPath := GetTempPath() + 'gameadvpl\levels\'
    
    aFiles := {}
    aSizes := {}

    ADir(cPath + "*.json", @aFiles, @aSizes)

    If Empty(aFiles)
        aFiles := {}
    EndIf

    For nX := 1 To Len(aFiles)
        aFiles[nX] := cPath + aFiles[nX]
    Next

Return aFiles

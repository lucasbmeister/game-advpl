#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} User Function LoadMenu(oMenu, oGame)
Monta menu principal
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
User Function LoadMenu(oMenu, oGame)

    Local aDimensions as array
    Local oWindow as object
    Local oPlay as object
    Local oGameTitle as object
    Local oQuit as object
    Local oFont48 as object

    oFont48 := TFont():New('Impact',, -48,.T.)

    aDimensions := oMenu:GetDimensions()
    oWindow := oMenu:GetSceneWindow()

    oSky := Background():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])

    oGameTitle := TPanel():New(-20, 80, , oWindow,,,,,, 500, 150)
    oGameTitle:SetCSS(GetTitleCSS())

    oPlay := TButton():New(120,270,"Iniciar", oWindow,{|| oGame:LoadScene('level_1') },120,40,,oFont48,,.T.)
    oPlay:SetCss(U_GetButtonCSS())

    oLevels := TButton():New(180,270,"Níveis", oWindow,{|| oGame:LoadScene('levels') },120,40,,oFont48,,.T.)
    oLevels:SetCss(U_GetButtonCSS())

    oQuit := TButton():New(240,270,"Sair", oWindow,{|| Final("Saiu do Jogo") },120,40,,oFont48,,.T.)
    oQuit:SetCss(U_GetButtonCSS())

    oMenu:AddObject(oSky)
    oMenu:AddObject(oGameTitle)
    oMenu:AddObject(oPlay)
    oMenu:AddObject(oLevels)
    oMenu:AddObject(oQuit)

Return

/*
{Protheus.doc} User Function LoadLevels(oLevels, oGame)
Carrega cena de lista de níveis
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
User Function LoadLevels(oLevels, oGame)

    Local oSky as object
    Local aDimensions as array
    Local oWindow as object
    Local nX as numeric
    Local oButton as object
    Local oBack as object
    Local oEditor as object
    Local aScenes as array
    Local nLine as numeric
    Local nCol as numeric
    Local oFont32 as object
    Local oFont48 as object

    oFont32 := TFont():New('Impact',, -32,.T.)
    oFont48 := TFont():New('Impact',, -48,.T.)

    aDimensions := oLevels:GetDimensions()
    oWindow := oLevels:GetSceneWindow()

    U_LoadEditorScenes(oWindow, oGame, aDimensions)

    aScenes := {}

    nLine := 30
    nCol := 65

    oSky := Background():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])

    oLevels:AddObject(oSky)

    AEval(oGame:aScenes, {|x| IIF(!(x:GetSceneID() $ 'menu;levels;interaction;editor'), AAdd(aScenes,x), nil)})

    For nX := 1 To Len(aScenes)
        oButton := TButton():New(nLine, nCol, AllTrim(aScenes[nX]:GetDescription()), oWindow, {|| oGame:LoadScene(GetScnId(::oCtlFocus, aScenes)) },120,50,,oFont32,,.T.)
        oButton:SetCss(U_GetButtonCSS(, .F.) )
        oButton:cName := aScenes[nX]:GetSceneID()

        oLevels:AddObject(oButton)

        nCol += 130

        If nX >= 5
            nLine += 60
            nCol := 65
        EndIf
    Next nX

    oBack := TButton():New(240, 30, 'Voltar' , oWindow, {|| oGame:LoadScene('menu') },120,50,,oFont48,,.T.)
    oBack:SetCss(U_GetButtonCSS())

    oEditor := TButton():New(240, 490, 'Editor' , oWindow, {|| oGame:LoadScene('editor') },120,50,,oFont48,,.T.)
    oEditor:SetCss(U_GetButtonCSS())

    oLevels:AddObject(oBack)
    oLevels:AddObject(oEditor)

Return

/*
{Protheus.doc} User Function GetButtonCSS(cAsset, lTransparent)
Retorna CSS para botões de níveis. Assets são carregados de acordo com o parâmetro cAsset
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
User Function GetButtonCSS(cAsset, lTransparent, lStretch)

    Local cCss as char    
    Local cBorderNormal as char
    Local cBorderHover as char
    Local cAssetCSS as char
    Local cPath as char

    Default lTransparent := .T.
    Default lStretch := .T.

    cBorderHover := ''

    cAssetCSS := ''

    If !Empty(cAsset)
        cPath := StrTran(GetTempPath(),"\","/") + 'gameadvpl/assets/' + cAsset
        If lStretch
            cAssetCSS := 'border-image: url('+cPath+') 0 0 0 0 stretch;'
        Else
            cAssetCSS := 'background-image: url('+cPath+');'
        EndIf
    EndIf

    If lTransparent
        cBorderNormal := 'background-color: rgba(255, 255, 255, 0.6);'
        cBorderHover := 'background-color: rgba(255, 255, 255, 0.9);'
    Else
        BeginContent var cBorderNormal  
            background-color: white;
            border: 2px dashed black;
        EndContent
    EndIf

    BeginContent var cCss

        TButton {
            background-size: contain;
            background-repeat: no-repeat no-repeat;
            background-position: center; 
            %Exp:cBorderNormal%
            border-radius: 3px;
            %Exp:cAssetCSS%
        }

        TButton:hover {
            %Exp:cBorderHover%
        }

        TButton:pressed {
            border: 2px dashed black
        }

    EndContent

Return cCss

/*
{Protheus.doc} Static Function GetTitleCSS()
Retorna CSS do título
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Static Function GetTitleCSS()

    Local cCss as char
    Local cPath as char

    cPath := StrTran(GetTempPath(),"\","/") + 'gameadvpl/assets/ui/title.png'

    BeginContent var cCss
        TPanel { 
            border-image: url(%Exp:cPath%) 0 0 0 0 stretch; 
        }
    EndContent

Return cCss

/*
{Protheus.doc} Static Function GetScnId(oButton, aScenes)
Retorna ID da cena de acordo com o botão clicado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Static Function GetScnId(oButton, aScenes)

    Local nPos as numeric

    nPos := AScan(aScenes, {|x| x:GetSceneID() == oButton:cName})

Return aScenes[nPos]:GetSceneID()
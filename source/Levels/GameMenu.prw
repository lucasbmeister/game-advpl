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


    aDimensions := oMenu:GetDimensions()
    oWindow := oMenu:GetSceneWindow()

    oSky := Sky():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])

    oGameTitle := TPanel():New(-20, 80, , oWindow,,,,,, 500, 150)
    oGameTitle:SetCSS(GetTitleCSS())

    oPlay := TButton():New(120,270,"", oWindow,{|| oGame:LoadScene('level_1') },120,40,,,,.T.)
    oPlay:SetCss(GetButtonCSS('start'))

    oLevels := TButton():New(180,270,"", oWindow,{|| oGame:LoadScene('levels') },120,40,,,,.T.)
    oLevels:SetCss(GetButtonCSS('levels'))

    oQuit := TButton():New(240,270,"", oWindow,{|| Final("Saiu do Jogo") },120,40,,,,.T.)
    oQuit:SetCss(GetButtonCSS('exit'))

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
    Local oFont as object

    oFont := TFont():New('Courier new',, -1,.T.)

    aDimensions := oLevels:GetDimensions()
    oWindow := oLevels:GetSceneWindow()

    U_LoadEditorScenes(oWindow, oGame, aDimensions)

    aScenes := {}

    nLine := 30
    nCol := 30

    oSky := Sky():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])

    oLevels:AddObject(oSky)

    AEval(oGame:aScenes, {|x| IIF(!(x:GetSceneID() $ 'menu;levels'), AAdd(aScenes,x), nil)})

    For nX := 1 To Len(aScenes)
        If aScenes[nX]:GetSceneID() != 'editor'
            oButton := TButton():New(nLine, nCol, '', oWindow, {|| oGame:LoadScene(GetScnId(::oCtlFocus, aScenes)) },120,50,,oFont,,.T.)
            oButton:SetCss(GetButtonCSS(aScenes[nX]:GetSceneID(), .F.) )
            oButton:cName := aScenes[nX]:GetSceneID()

            oLevels:AddObject(oButton)

            nCol += 130

            If nX >= 5
                nLine += 50
                nCol := 30
            EndIf
        EndIf
    Next nX

    oBack := TButton():New(240, 30, '' , oWindow, {|| oGame:LoadScene('menu') },120,50,,,,.T.)
    oBack:SetCss(GetButtonCSS('back'))

    oEditor := TButton():New(240, 490, '' , oWindow, {|| oGame:LoadScene('editor') },120,50,,,,.T.)
    oEditor:SetCss(GetButtonCSS('editor'))

    oLevels:AddObject(oBack)
    oLevels:AddObject(oEditor)

Return

/*
{Protheus.doc} Static Function GetButtonCSS(cButton, lTransparent)
Retorna CSS para botões de níveis. Assets são carregados de acordo com o parâmetro cButton
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Static Function GetButtonCSS(cButton, lTransparent)

    Local cCss as char    
    Local cPathNormal as char
    Local cPathHover as char
    Local cBorderNormal as char
    Local cBorderHover as char

    Default lTransparent := .T.

    cBorderHover := ''

    cPathNormal := StrTran(GetTempPath(),"\","/") + 'gameadvpl/assets/ui/'+cButton+'.png'
    cPathHover := StrTran(GetTempPath(),"\","/") + 'gameadvpl/assets/ui/'+cButton+'_hover.png'

    If lTransparent
        cBorderNormal := 'background-color: rgba(255, 255, 255, 0.1);'
        cBorderHover := 'background-color: rgba(255, 255, 255, 0.3);'
    Else
        BeginContent var cBorderNormal  
            background-color: white;
            border: 2px dashed black
        EndContent
    EndIf

    BeginContent var cCss

    TButton {
        background-image: url(%Exp:cPathNormal%);
        background-size: contain;
        background-repeat: no-repeat no-repeat;
        background-position: center; 
        border-radius: 3px;
        %Exp:cBorderNormal%

    }

    TButton:hover {
        background-image: url(%Exp:cPathHover%);
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
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

// instância gerenciador do jogo
oGame := GameManager():New("Game Advpl", 50, 50, 650, 1330)

// obtém janela princial onde as cenas serão adicionadas
oWindow := oGame:GetMainWindow()

// retorna dimensões de tela do jogo
aDimensions := oGame:GetDimensions()

// instância uma cena (deverá ser atribuida para janela do jogo)
oMenu := Scene():New(oWindow, "menu", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
oMenu:SetInitCodeBlock({|oLevel| LoadMenu(oLevel, oGame)})

oLevels := Scene():New(oWindow, "levels", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
oLevels:SetInitCodeBlock({|oLevel| LoadLevels(oLevel, oGame)})

// instância uma cena (deverá ser atribuida para janela do jogo)
oLevel1 := Scene():New(oWindow, "level_1", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
oLevel1:SetInitCodeBlock({|oLevel| LoadLvl1(oLevel, oGame)})
oLevel1:SetDescription('Nível 1')

oLevel2 := Scene():New(oWindow, "level_2", aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])
oLevel2:SetInitCodeBlock({|oLevel| LoadLvl2(oLevel, oGame)})
oLevel2:SetDescription('Nível 2')

// adiciona cena ao jogo
oGame:AddScene(oMenu)
oGame:AddScene(oLevels)
oGame:AddScene(oLevel1)
oGame:AddScene(oLevel2)

//inicia o jogo passando como parãmetro a ID da cena inicial
oGame:Start(oMenu:GetSceneID())

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function LoadMenu(oMenu, oGame)

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

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function LoadLevels(oLevels, oGame)

    Local oSky as object
    Local aDimensions as array
    Local oWindow as object
    Local nX as numeric
    Local oButton as object
    Local oBack as object
    Local aScenes as array
    Local nLine as numeric
    Local nCol as numeric
    Local oFont as object

    oFont := TFont():New('Courier new',, -1,.T.)

    aDimensions := oLevels:GetDimensions()
    oWindow := oLevels:GetSceneWindow()

    aScenes := {}

    nLine := 30
    nCol := 30

    oSky := Sky():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])

    AEval(oGame:aScenes, {|x| IIF(!(x:GetSceneID() $ 'menu;levels'), AAdd(aScenes,x), nil)})

    For nX := 1 To Len(aScenes)

        oButton := TButton():New(nLine, nCol, '', oWindow, {|| oGame:LoadScene(GetScnId(::oCtlFocus, aScenes)) },120,50,,oFont,,.T.)
        oButton:SetCss(GetButtonCSS(aScenes[nX]:GetSceneID(), .F.) )
        oButton:cName := aScenes[nX]:GetSceneID()

        nCol += 130

        If nX >= 5
            nLine += 50
            nCol := 30
        EndIf

    Next nX

    oBack := TButton():New(240, 30, '' , oWindow, {|| oGame:LoadScene('menu') },120,50,,,,.T.)
    oBack:SetCss(GetButtonCSS('back'))

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function LoadLvl1(oLevel, oGame)

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

    oEnemy := Enemy():New(oWindow, "Excel", 50, 60, 50, 80)
    oEnemy:SetTag('enemy')
    oEnemy:SetColliderMargin(25, 50, 0, -50)

    oPlayer := Player():New(oWindow, "Protheus", 50, 200, 50, 80)
    oPlayer:SetTag('player')
    oPlayer:SetColliderMargin(25, 50, 0, -50)

    oClouds := Clouds():New(oWindow, aDimensions[TOP], aDimensions[LEFT], aDimensions[HEIGHT], aDimensions[WIDTH])

    oCoin1 := Coin():New(oWindow,, 250, 60, 10, 10)

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
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function LoadLvl2(oLevel, oGame)

    Local oWindow as object
    Local oPlayer as object

    oWindow := oLevel:GetSceneWindow()

    oPlayer := Player():New(oWindow, "Lucas", 50, 50, 50, 80)
    oPlayer:SetTag('player')
    oPlayer:SetColliderMargin(10, 60, -5, -60)

    oLevel:AddObject(oPlayer)

Return

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
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
{Protheus.doc} function
description
@author  author
@since   date
@version version
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
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function GetScnId(oButton, aScenes)

    Local nPos as numeric

    nPos := AScan(aScenes, {|x| x:GetSceneID() == oButton:cName})

Return aScenes[nPos]:GetSceneID()
#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class GameManager From LongNameClass

    Data oKeys
    Data oActiveScene
    Data nDeltaTime
    Data aScenes
    Data oWindow 
    Data cGameName
    Data oWebChannel
    Data oWebEngine
    Data nTop
    Data nLeft
    Data nHeight
    Data nWidth
    Data nPlayerScore
    Data nPlayerLife 

    Data lCameraUpdate
    Data cCameraDirection
    Data nCameraSpeed

    Data oStartLimit
    Data oEndLimit

    Method New() Constructor
    Method AddScene()
    Method SetActiveScene()
    Method GetActiveScene()
    Method LoadScene()
    Method Start()
    Method SetPressedKeys()
    Method GetPressedKeys()
    Method GetMainWindow()
    Method GetDimensions()
    Method StartEngine()
    Method Update()
    Method HandleEvent()
    Method ExportAssets()
    Method Processed()
    Method GetColliders()
    Method UpdateScore()
    Method GetScore()
    Method UpdateLife()
    Method GetLife()
    Method GameOver()
    Method SetCameraUpdate()
    Method ShouldUpdateCamera()
    Method GetMidScreen()
    Method SetCameraLimits()
    Method GetStartLimit()
    Method GetEndLimit()

EndClass

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(cGameName, nTop, nLeft, nHeight, nWidth) Class GameManager

    Static oInstance as object
    Default cGameName := "Game 2D"
    Default nTop := 180
    Default nLeft := 180
    Default nHeight := 550
    Default nWidth := 700

    ::nPlayerScore := 0
    ::nPlayerLife := 0

    ::nTop := nTop
    ::nLeft := nLeft
    ::nHeight := nHeight
    ::nWidth := nWidth

    ::oStartLimit := nil
    ::oEndLimit := nil
        
    ::cGameName := cGameName
    ::aScenes := {}
    ::oKeys := {}

    ::lCameraUpdate := .F.
    ::cCameraDirection := ''
    ::nCameraSpeed := 0

    ::nDeltaTime := 0

    oInstance := Self

    ::oWindow := TDialog():New(::nTop ,::nLeft, ::nHeight,::nWidth,::cGameName ,,,,,CLR_BLACK,CLR_HCYAN,,,.T.)

    ::ExportAssets()

Return Self

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method AddScene(oScene) Class GameManager
    Aadd(::aScenes, oScene)
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetMainWindow() Class GameManager
Return ::oWindow
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Start(cFirstScene) Class GameManager

    Local nPos as numeric
    Static oInstance as object

    oInstance := Self

    nPos := AScan(::aScenes,{|x| x:GetSceneID() == cFirstScene })

    ::SetActiveScene(::aScenes[nPos])
    
    ::oWindow:bStart := {||::aScenes[nPos]:Start(),  oInstance:StartEngine() }
    ::oWindow:Activate()

Return

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method StartEngine() Class GameManager

    Static oInstance as object
    Local cLink as char

    oInstance := Self
    
    cLink := GetTempPath() + "gameadvpl\gameadvpl.html"

    ::oWebChannel := TWebChannel():New()
    ::oWebChannel:Connect()

    If !::oWebChannel:lConnected
    	UserException("Erro na conexao com o WebSocket")
    	Return
    EndIf

    ::oWebChannel:bJsToAdvpl := {|self,codeType,codeContent| oInstance:HandleEvent(self, codeType, codeContent)} 

    //::oWebEngine := TWebEngine():New(oInstance:oWindow, 0, 0, ::nWidth, 10,,::oWebChannel:nPort)	
    ::oWebEngine := TWebEngine():New(oInstance:oWindow, 0, 0, ::nWidth, 10,,::oWebChannel:nPort)	
	::oWebEngine:Navigate(cLink)

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HandleEvent(oWebChannel, codeType, codeContent) Class GameManager

    If codeType == "start"
        ::oWebChannel:advplToJs("started", "true")
    ElseIf codeType == "update"
        ::Update(oWebChannel, codeType, Upper(codeContent))
    EndIf 

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetPressedKeys(oKeys) Class GameManager
    ::oKeys := oKeys
REturn
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetPressedKeys() Class GameManager
Return ::oKeys
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update(oWebChannel, codeType, codeContent) Class GameManager

    Local oKeys as object
    Local oActiveScene as object

    oKeys := JsonObject():New()

    oKeys:FromJson(Lower(codeContent))

    oActiveScene := ::GetActiveScene()

    ::SetPressedKeys(oKeys)
    ::nDeltaTime := TimeCounter() - ::nDeltaTime
    oActiveScene:Update(Self)

    If ::ShouldUpdateCamera()
        //basicamente move todos os objetos na direção contrário do player (incluindo o player)
        oActiveScene:UpdateCamera(Self, ::cCameraDirection, ::nCameraSpeed)
        ::SetCameraUpdate(.F.)
    EndIf

    ::Processed()

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Processed()  Class GameManager
    ::oWebChannel:advplToJs("processed", "true")
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetDimensions() Class GameManager
Return {::nTop, ::nLEft, ::nHeight, ::nWidth}
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method ExportAssets() Class GameManager

    Local cTempPath as char
    Local cFile as char

    cTempPath := GetTempPath()
    cFile := "gameadvpl.app"

    If !Resource2File(cFile,  cTempPath + cFile)
    	UserException("Nao foi possivel copiar o arquivo "+cFile+" para o diretorio temporario")
		Return
    EndIf

    If !ExistDir(cTempPath + "gameadvpl\" )
		If MakeDir(cTempPath + "gameadvpl\" ) != 0
			UserException("Nao foi criar o diretorio" + cTempPath + "gameadvpl\")
			Return
		EndIf
	EndIf

    FUnzip(cTempPath + cFile, cTempPath + "gameadvpl\")

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetActiveScene(oScene) Class GameManager
    ::oActiveScene := oScene
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetActiveScene() Class GameManager
Return ::oActiveScene
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method LoadScene(cSceneID) Class GameManager
    
    Local nPos as numeric

    nPos := AScan(::aScenes,{|x| x:GetSceneID() == cSceneID })
    
    If !Empty(::oActiveScene)
        ::oActiveScene:EndScene()
    EndIf

    ::SetActiveScene(::aScenes[nPos])
    ::oActiveScene:Start()
    ::oWebEngine:SetFocus()
    ProcessMessage()

Return
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method GetColliders() Class GameManager
Return ::GetActiveScene():GetObjectsWithColliders()

/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method GameOver() Class GameManager
    
    Local oSay as object
    Local cText as char

    cText := "<h1>GAME OVER</h1>"

    oSay := TSay():New(1, 1,{||cText}, ::oWindow,,,,,,.T.,,,100,100,,,,,,.T.)
    oSay:SetCSS('QLabel { backgound-color: white }')

    Sleep(1000)

    oSay:Hide()
    FreeObj(oSay)

    ::LoadScene(::GetActiveScene():GetSceneID())

Return
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method UpdateScore(nValue) Class GameManager
    ::nPlayerScore += nValue
Return ::nPlayerScore
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method GetScore() Class GameManager
Return ::nPlayerScore
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method UpdateLife(nLife) Class GameManager
    ::nPlayerLife += nLife
Return ::nPlayerLife
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method GetLife() Class GameManager
Return ::nPlayerLife
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method SetCameraUpdate(lUpdate, cDirection, nSpeed) Class GameManager
    ::lCameraUpdate := lUpdate
    ::cCameraDirection := cDirection
    ::nCameraSpeed := nSpeed
Return 
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method ShouldUpdateCamera() Class GameManager
Return ::lCameraUpdate
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method GetMidScreen() Class GameManager
Return ::oWindow:nWidth / 2
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method SetCameraLimits(oStartLimit, oEndLimit) Class GameManager
    ::oStartLimit := oStartLimit
    ::oEndLimit := oEndLimit
Return
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method GetStartLimit() Class GameManager
Return ::oStartLimit:oGameObject:nLeft
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
Method GetEndLimit() Class GameManager
Return ::oEndLimit:oGameObject:nLeft

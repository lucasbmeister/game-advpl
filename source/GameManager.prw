#include "totvs.ch"

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class GameManager

    Data cLastKey
    Data oActiveScene
    Data aScenes
    Data oWindow 
    Data cGameName
    Data oWebChannel
    Data oWebEngine
    Data nTop
    Data nLeft
    Data nBottom
    Data nRight

    Method New() Constructor
    Method AddScene()
    Method SetActiveScene()
    Method GetActiveScene()
    Method LoadScene()
    Method Start()
    Method SetLastKey()
    Method GetLastKey()
    Method GetMainWindow()
    Method GetDimensions()
    Method StartEngine()
    Method Update()
    Method HandleEvent()
    Method ExportAssets()
    Method Processed()

EndClass

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(cGameName, nTop, nLeft, nBottom, nRight) Class GameManager

    Static oInstance as object
    Default cGameName := "Game 2D"
    Default nTop := 180
    Default nLeft := 180
    Default nBottom := 550
    Default nRight := 700

    ::nTop := nTop
    ::nLeft := nLeft
    ::nBottom := nBottom
    ::nRight := nRight
    
    ::cGameName := cGameName
    ::aScenes := {}
    ::cLastKey := ""

    oInstance := Self

    ::oWindow := TDialog():New(::nTop,::nLeft,::nBottom,::nRight,::cGameName ,,,,,CLR_BLACK,CLR_HCYAN,,,.T.)
    // ::oWindow := TWindow():New(::nTop, ::nLeft, ::nBottom, ::nRight, ::cGameName, NIL, NIL, NIL, NIL, NIL, NIL, NIL,;
    //     CLR_BLACK, CLR_WHITE, NIL, NIL, NIL, NIL, NIL, NIL, .T. )

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

    ::oWebEngine := TWebEngine():New(oInstance:oWindow, 0, 0, ::nRight - ::nLeft, 10,,::oWebChannel:nPort)	
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
Method SetLastKey(cKey) Class GameManager
    ::cLastKey := cKey
REturn
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetLastKey() Class GameManager
Return Upper(::cLastKey)
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update(oWebChannel, codeType, codeContent) Class GameManager

    ::SetLastKey(codeContent)

    ::GetActiveScene():Update(Self)

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
Return {::nTop, ::nLeft, ::nBottom, ::nRight}
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
    ProcessMessage()

Return

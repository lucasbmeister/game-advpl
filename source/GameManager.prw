#include "totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Class GameManager

    Data cLastKey
    Data aObjects 
    Data oWindow 
    Data cGameName
    Data oWebChannel
    Data oWebEngine
    Data nTop
    Data nLeft
    Data nBottom
    Data nRight

    Method New() Constructor
    Method AddObject()
    Method Start()
    Method SetLastKey()
    Method GetLastKey()
    Method GetMainWindow()
    Method GetDimensions()
    Method StartEngine()
    Method Update()
    Method HandleEvent()
    Method Processed()

EndClass

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
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
    ::aObjects := {}
    ::cLastKey := ""

    oInstance := Self

    ::oWindow := TDialog():New(::nTop,::nLeft,::nBottom,::nRight,::cGameName ,,,,,CLR_BLACK,CLR_HCYAN,,,.T.)

Return Self

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method AddObject(oObject) Class GameManager
    Aadd(::aObjects, oObject)
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method GetMainWindow() Class GameManager
Return ::oWindow
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method Start() Class GameManager

    Static oInstance as object
    oInstance := Self

    ::oWindow:Activate( ,,,.T.,,,{|| oInstance:StartEngine() })
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method StartEngine() Class GameManager

    Static oInstance as object

    Local cLink as char
    Local cTempPath as char
    Local cFile as char
    oInstance := Self

    cTempPath := GetTempPath()
    cFile := "gameadvpl.app"
    cLink := cTempPath + "gameadvpl\gameadvpl.html"

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

    ::oWebChannel := TWebChannel():New()
    ::oWebChannel:Connect()

    If !::oWebChannel:lConnected
    	UserException("Erro na conexao com o WebSocket")
    	Return
    EndIf

    ::oWebChannel:bJsToAdvpl := {|self,codeType,codeContent| oInstance:HandleEvent(self, codeType, codeContent)} 

    ::oWebEngine := TWebEngine():New(oInstance:oWindow, 0, 0, ::nRight - ::nLeft, 10,,::oWebChannel:nPort)	
	::oWebEngine:Navigate(cLink)
    ConOut(cLink)
    ConOut(::oWebChannel:nPort)
    
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method HandleEvent(oWebChannel, codeType, codeContent) Class GameManager

    If codeType == "start"
        ::oWebChannel:advplToJs("started", "true")
    ElseIf codeType == "update"
        ::Update(oWebChannel, codeType, Upper(codeContent))
    EndIf 

Return
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method SetLastKey(cKey) Class GameManager
    ::cLastKey := cKey
REturn
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method GetLastKey() Class GameManager
Return Upper(::cLastKey)
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method Update(oWebChannel, codeType, codeContent) Class GameManager
    
    Local nX as numeric

    ::SetLastKey(codeContent)

    For nX := 1 To Len(::aObjects)
        ::aObjects[nX]:Update(Self)
    Next nX

    ::Processed()

Return
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method Processed()  Class GameManager
    ::oWebChannel:advplToJs("processed", "true")
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method GetDimensions() Class GameManager
    Local aDimensions as array
    aDimensions := {::nTop, ::nLeft, ::nBottom, ::nRight}
Return aDimensions

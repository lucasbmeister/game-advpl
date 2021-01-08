#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class GameEditor From LongNameClass

    Data oSelectedObject
    Data aObjects
    Data aCombo
    Data oComboObjects
    Data cComboObject
    Data oInspector
    Data oScrollObjects
    Data oObjectAxis
    Data oSceneNavigator
    Data oTopBar
    Data nMovementSpeed
    Data nScenePanSpeed
    Data oWindow 
    Data oGame

    Method New() Constructor
    Method LoadObjects()
    Method GetObjectList()
    Method SpawnObject()
    Method SetupObjectList()
    Method SetupInspector()
    Method SetupObjectAxis()
    Method SetupSceneNavigator()
    Method SetSelectedObject()
    Method GetSelectedObject()
    Method AddComboOption()
    Method SetupTopBar()
    Method ToggleUIObject()
    Method MoveObjectUp()
    Method MoveObjectLeft()
    Method MoveObjectDown()
    Method MoveObjectRight()
    Method SetMovementSpeed()
    Method GetMovementSpeed()
    Method SetScenePanSpeed()
    Method GetScenePanSpeed()
    Method MoveSceneLeft()
    Method MoveSceneRight()
    Method MoveUIToTop()
    Method SetGameManager()
    Method SetMainWindow()
    Method GetGameManager()
    Method GetMainWindow()
    Method DuplicateObject()


EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, oGame) Class GameEditor

    ::aObjects := {}
    ::aCombo := {}
    ::cComboObject := ''
    ::nMovementSpeed := 1
    ::nScenePanSpeed := 1

    ::SetGameManager(oGame)
    ::SetMainWindow(oWindow)

    ::SetupObjectList()
    ::SetupInspector()
    ::SetupTopBar()
    ::SetupObjectAxis()
    ::SetupSceneNavigator()

Return Self
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method LoadObjects(oListObjects) Class GameEditor

    Local nX as numeric
    Local aObjects as array
    Local oFont as object
    Local nLine as numeric
    Local nCol as numeric
    Local oButton as object

    Static oInstance as object

    oInstance := Self
    oFont := TFont():New('Courier new',, -16,.T.)

    nLine := 01
    nCol := 01

    aObjects := ::GetObjectList()

    For nX := 1 To Len(aObjects)
        oButton := TButton():New(nLine, nCol, aObjects[nX], oListObjects, {|o| oInstance:SpawnObject(o:cName) },70,50,,oFont,,.T.)
        oButton:cName := aObjects[nX]
        nLine += 51
    Next

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetupObjectList() Class GameEditor

    Local oListObjects as object
    Local nPanelHeight as numeric
    Local oWindow as object
    Local oGame as object

    oWindow := ::GetMainWindow()
    oGame := ::GetGameManager()

    Static oInstance as object

    oInstance := Self

    ::oScrollObjects := TScrollArea():New(oWindow, 25, 00, 277, 80)

    nPanelHeight := ::GetObjectList(.T.) * 51

    oListObjects := TPanel():New(25, 00, , oInstance:oScrollObjects,,,,CLR_WHITE,CLR_BLACK, 70, nPanelHeight)

    ::oScrollObjects:SetFrame(oListObjects)

    ::LoadObjects(oListObjects)

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetupInspector() Class GameEditor

    Local oWindow as object
    Local oGame as object

    oWindow := ::GetMainWindow()
    oGame := ::GetGameManager()

    Static oInstance as object

    oInstance := Self

    ::oInspector := TPanel():New(25, (oWindow:nWidth / 2) - 80, , oWindow,,,,/*CLR_WHITE*/,CLR_BLACK, 80, oWindow:nHeight / 2)
    oInstance:cComboObject := ''
    ::oComboObjects := TComboBox():New(5,5,{|u|if(PCount()>0,oInstance:cComboObject:=u,oInstance:cComboObject) };
        , {''},70,30,::oInspector,,{|u|oInstance:SetSelectedObject(u:nAt, .T.)},,CLR_BLACK,CLR_WHITE,.T.,,,,,,,,, 'oInstance:cComboObject', 'Selecionado', 1, ,CLR_WHITE)

    //::oComboObjects:MoveToTop()

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetObjectList(lOnlyLen) Class GameEditor

    Local aObjects as array

    Default lOnlyLen := .F.

    aObjects := {}

    // por enquanto uma lista simples com os nomes das classes
    Aadd(aObjects, 'Ground')
    Aadd(aObjects, 'Coin')
    Aadd(aObjects, 'Player')
    Aadd(aObjects, 'FloatingGround')
    Aadd(aObjects, 'Enemy')
    Aadd(aObjects, 'Square')
    Aadd(aObjects, 'PlayerLife')
    Aadd(aObjects, 'PlayerScore')

Return IIF(lOnlyLen, Len(aObjects), aObjects)
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SpawnObject(cClassName, nTop, nLeft, lSetSelected) Class GameEditor

    Local cTop as char
    Local cLeft as char
    Local oObject as object
    Local bLeftBlock as codeblock
    Local bRightBlock as codeblock
    Local oWindow as object
    Local oGame as object

    oWindow := ::GetMainWindow()
    oGame := ::GetGameManager()

    Default nTop := oWindow:nHeight / 2  - 190
    Default nLeft := oGame:GetMidScreen() - 340
    Default lSetSelected := .F.

    Static oInstance as object

    oInstance := Self

    cTop := cValToChar(nTop)
    cLeft := cValToChar(nLeft)

    oObject := &(cClassName + '():New(oWindow, ' + cTop + ','+ cLeft +')')
    AAdd(::aObjects, oObject)

    bLeftBlock := &('{|| oInstance:SetSelectedObject('+cValToChar(Len(::aObjects))+')} ')
    bRightBlock := &('{|| oInstance:DuplicateObject("'+cClassName+'", '+ cValToChar(Len(::aObjects))+')} ')

    oObject:SetLeftClickAction(bLeftBlock)
    oObject:SetRightClickAction(bRightBlock)

    ::AddComboOption(Len(::aObjects), cClassName)

    // If lSetSelected
    //     ::SetSelectedObject(Len(::aObjects))
    // EndIf
    
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetSelectedObject(nObject, lCombo) Class GameEditor

    Default lCombo := .F.

    If nObject > 0
        ::oSelectedObject := ::aObjects[nObject]
        //::oComboObjects:nAt := nObject
        //::cComboObject := Str(nObject)
        If !lCombo
            //::oComboObjects:Select(nObject)
            ::cComboObject := cValToChar(nObject)
        EndIf
    EndIf
    //::oComboObjects:Refresh()
    //ProcessMessage()
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetSelectedObject() Class GameEditor
Return ::oSelectedObject

/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method AddComboOption(nPos, cClassName) Class GameEditor
    Local nAtBkp as numeric

    nAtBkp := ::oComboObjects:nAt

    Aadd(::aCombo, cValTochar(nPos) + '=' + cClassName)
    //::oComboObjects:aItems := AClone(::aCombo)
    ::oComboObjects:SetItems(AClone(::aCombo))

    //::oComboObjects:Select(nAtBkp)
    ::cComboObject := cValToChar(nAtBkp)

    If Len(::aCombo) == 1
        ::SetSelectedObject(1)
    EndIf

    ::MoveUIToTop()
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetupTopBar() Class GameEditor

    Local oWindow as object
    Local oGame as object

    oWindow := ::GetMainWindow()
    oGame := ::GetGameManager()

    Static oInstance as object

    oInstance := Self

    ::oTopBar := TPanel():New(01,00, , oWindow,,,,CLR_WHITE,CLR_BLACK, oWindow:nWidth / 2, 25)

    TButton():New( 14, 01, "-",::oTopBar,{|o| oInstance:ToggleUIObject(oInstance:oScrollObjects, o)}, 10,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TSay():New(15,13,{||'Lista Objetos'},::oTopBar,,,,,,.T.,CLR_WHITE,CLR_BLACK,50,20)

    TButton():New( 14, (oWindow:nWidth / 2) - 12, "-",::oTopBar,{|o|oInstance:ToggleUIObject(oInstance:oInspector, o)}, 10,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TSay():New(15,(oWindow:nWidth / 2) - 35,{||'Inspetor'},::oTopBar,,,,,,.T.,CLR_WHITE,CLR_BLACK,30,20)

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method ToggleUIObject(oObject, oButton) Class GameEditor

    If oObject:lVisible
        oObject:Hide()
        oButton:cCaption := oButton:cTitle := '+'
    Else
        oObject:Show()
        oButton:cCaption := oButton:cTitle := '-'
    EndIf

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetupObjectAxis() Class GameEditor

    Local oSlider as object
    Local oMovementSpeed as object
    Local oWindow as object
    Local oGame as object

    oWindow := ::GetMainWindow()
    oGame := ::GetGameManager()

    Static oInstance as object

    oInstance := Self

    ::oObjectAxis := TPanel():New((oWindow:nHeight / 2) - 080,(oWindow:nWidth / 2) - 150, , oWindow,,,,/*CLR_BLACK*/,/*CLR_BLACK*/, 65, 60)
    ::oObjectAxis:SetCss('TPanel { border-color: black; border-style: solid; border-width: 1px}')

    TSay():New(03,03,{||'Mov. Objeto'},::oObjectAxis,,,,,,.T.,CLR_BLACK,CLR_BLACK,50,20)
    oMovementSpeed := TSay():New(03,50,{||'1'},::oObjectAxis,,,,,,.T.,CLR_BLACK,CLR_BLACK,50,20)

    TBtnBmp2():New(35,32,26,26,'PMSSETAUP',,,,{|| oInstance:MoveObjectUp(oInstance:GetSelectedObject())},::oObjectAxis,,,.T.) 
    TBtnBmp2():New(61,06,26,26,'PMSSETAESQ',,,,{||oInstance:MoveObjectLeft(oInstance:GetSelectedObject())},::oObjectAxis,,,.T.) 
    TBtnBmp2():New(87,32,26,26,'PMSSETADOWN',,,,{||oInstance:MoveObjectDown(oInstance:GetSelectedObject())},::oObjectAxis,,,.T.) 
    TBtnBmp2():New(61,57,26,26,'PMSSETADIR',,,,{||oInstance:MoveObjectRight(oInstance:GetSelectedObject())},::oObjectAxis,,,.T.) 

    oSlider := TSlider():New(17,50,::oObjectAxis,{|x| oInstance:SetMovementSpeed(x), oMovementSpeed:SetText(cValToChar(x))},10,40,"Inc.",nil)

    oSlider:SetOrient(1)
    oSlider:SetRange(1, 50)
    oSlider:SetStep(1)
    oSlider:SetValue(1)

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveObjectUp(oObject) Class GameEditor
    
    Local nSpeed as numeric

    nSpeed := ::GetMovementSpeed()

    If !Empty(oObject)
        oObject:oGameObject:nTop -= nSpeed
    EndIf

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveObjectLeft(oObject) Class GameEditor
    Local nSpeed as numeric

    nSpeed := ::GetMovementSpeed()
    
    If !Empty(oObject)
        oObject:oGameObject:nLeft -= nSpeed
    EndIf

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveObjectDown(oObject) Class GameEditor
    Local nSpeed as numeric

    nSpeed := ::GetMovementSpeed()
    
    If !Empty(oObject)
        oObject:oGameObject:nTop += nSpeed
    EndIf

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveObjectRight(oObject) Class GameEditor

    Local nSpeed as numeric

    nSpeed := ::GetMovementSpeed()
    
    If !Empty(oObject)
        oObject:oGameObject:nLeft += nSpeed
    EndIf

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetMovementSpeed(nValue) Class GameEditor
    ::nMovementSpeed := nValue
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetMovementSpeed() Class GameEditor
Return ::nMovementSpeed
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetupSceneNavigator() Class GameEditor

    Local oSlider as object
    Local oScenePanSpeed as object
     Local oWindow as object
    Local oGame as object

    oWindow := ::GetMainWindow()
    oGame := ::GetGameManager()

    Static oInstance as object

    oInstance := Self

    ::oSceneNavigator := TPanel():New((oWindow:nHeight / 2) - 126,(oWindow:nWidth / 2) - 150, , oWindow,,,,/*CLR_BLACK*/,/*CLR_BLACK*/, 65, 45)
    ::oSceneNavigator:SetCss('TPanel { border-color: black; border-style: solid; border-width: 1px}')

    TSay():New(03,03,{||'Mov. Cena'},::oSceneNavigator,,,,,,.T.,CLR_BLACK,CLR_BLACK,50,20)
    oScenePanSpeed := TSay():New(03,50,{||'1'},::oSceneNavigator,,,,,,.T.,CLR_BLACK,CLR_BLACK,50,20)

    TBtnBmp2():New(25,06,26,26,'PMSSETAESQ',,,,{||oInstance:MoveSceneLeft()},::oSceneNavigator,,,.T.) 
    TBtnBmp2():New(25,57,26,26,'PMSSETADIR',,,,{||oInstance:MoveSceneRight()},::oSceneNavigator,,,.T.) 

    oSlider := TSlider():New(30,03,::oSceneNavigator,{|x| oInstance:SetScenePanSpeed(x), oScenePanSpeed:SetText(cValToChar(x))},57,10,"Inc.",nil)

    oSlider:SetOrient(0)
    oSlider:SetRange(1, 100)
    oSlider:SetStep(1)
    oSlider:SetValue(1)
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveSceneLeft() Class GameEditor

    Local nX as numeric
    Local nSpeed as numeric

    nX := 1
    nSpeed := ::GetScenePanSpeed()

    For nX := 1 To Len(::aObjects)
        ::aObjects[nX]:oGameObject:nLeft += nSpeed
    Next

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveSceneRight() Class GameEditor

    Local nX as numeric
    Local nSpeed as numeric

    nX := 1
    nSpeed := ::GetScenePanSpeed()

    For nX := 1 To Len(::aObjects)
        ::aObjects[nX]:oGameObject:nLeft -= nSpeed
    Next

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetScenePanSpeed(nSpeed) Class GameEditor
    ::nScenePanSpeed := nSpeed
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetScenePanSpeed() Class GameEditor
Return ::nScenePanSpeed
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveUIToTop() Class GameEditor
    ::oInspector:MoveToTop()
    ::oScrollObjects:MoveToTop()
    ::oObjectAxis:MoveToTop()
    ::oSceneNavigator:MoveToTop()
    ::oTopBar:MoveToTop()
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetGameManager(oGame) Class GameEditor
    ::oGame := oGame
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetMainWindow(oWindow) Class GameEditor
    ::oWindow := oWindow
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetGameManager() Class GameEditor
Return ::oGame
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetMainWindow() Class GameEditor
Return ::oWindow
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method DuplicateObject(cClassName, nObject) Class GameEditor
    ::SpawnObject(cClassName, ::aObjects[nObject]:oGameObject:nTop, ::aObjects[nObject]:oGameObject:nLeft, .T.)
    ProcessMessage()
Return

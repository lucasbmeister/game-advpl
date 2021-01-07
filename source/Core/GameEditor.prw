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
    Data oTopBar

    Method New() Constructor
    Method LoadObjects()
    Method GetObjectList()
    Method SpawnObject()
    Method SetupObjectList()
    Method SetupInspector()
    Method SetSelectedObject()
    Method AddComboOption()
    Method SetupTopBar()
    Method ToggleObjectList()
    Method ToggleInspector()

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
    ::SetupObjectList(oWindow, oGame)
    ::SetupInspector(oWindow, oGame)
    ::SetupTopBar(oWindow, oGame)
Return Self
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method LoadObjects(oListObjects, oWindow, oGame) Class GameEditor

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
        oButton := TButton():New(nLine, nCol, aObjects[nX], oListObjects, {|o| oInstance:SpawnObject(o:cName, oWindow, oGame) },70,50,,oFont,,.T.)
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
Method SetupObjectList(oWindow, oGame) Class GameEditor

    Local oListObjects as object
    Local nPanelHeight as numeric

    Static oInstance as object

    oInstance := Self

    ::oScrollObjects := TScrollArea():New(oWindow, 25, 01, 275, 80)

    nPanelHeight := ::GetObjectList(.T.) * 51

    oListObjects := TPanel():New(25, 01, , oInstance:oScrollObjects,,,,CLR_WHITE,CLR_GRAY, 70, nPanelHeight)

    ::oScrollObjects:SetFrame(oListObjects)

    ::LoadObjects(oListObjects, oWindow, oGame)

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetupInspector(oWindow, oGame) Class GameEditor

    Static oInstance as object

    oInstance := Self

    ::oInspector := TPanel():New(25, (oWindow:nWidth / 2) - 80, , oWindow,,,,CLR_WHITE,CLR_GRAY, 80, oWindow:nHeight / 2)
    oInstance:cComboObject := ''
    ::oComboObjects := TComboBox():New(5,5,{|u|if(PCount()>0,oInstance:cComboObject:=u,oInstance:cComboObject) };
        , {},70,30,::oInspector,,{|u|oInstance:SetSelectedObject(u:nAt), u:Refresh()},,,,.T.,,,,,,,,, 'oInstance:cComboObject', 'Selecionado', 1)

    ::oComboObjects:MoveToTop()

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
Method SpawnObject(cClassName, oWindow, oGame) Class GameEditor

    Local cTop as char
    Local oObject as object
    Local bBlock as codeblock
    Static oInstance as object

    oInstance := Self

    cTop := AllTrim(Str(oWindow:nHeight / 2  - 190))
    cLeft := AllTrim(Str(oGame:GetMidScreen() - 340))

    oObject := &(cClassName + '():New(oWindow, ' + cTop + ','+ cLeft +')')
    AAdd(::aObjects, oObject)

    bBlock := &('{|| oInstance:SetSelectedObject('+AllTrim(Str(Len(::aObjects)))+')} ')
    oObject:SetClickAction(bBlock)
    ::AddComboOption(Len(::aObjects), cClassName)
    
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetSelectedObject(nObject) Class GameEditor
    ::oSelectedObject := ::aObjects[nObject]
    //::oComboObjects:nAt := nObject
    ::cComboObject := Str(nObject)
Return

/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method AddComboOption(nPos, cClassName) Class GameEditor
    Aadd(::aCombo, AllTrim(Str(nPos)) + '=' + cClassName)
    ::oComboObjects:aItems := ::aCombo
Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method SetupTopBar(oWindow, oGame) Class GameEditor

    Static oInstance as object

    oInstance := Self

    ::oTopBar := TPanel():New(01,01, , oWindow,,,,CLR_WHITE,CLR_GRAY, oWindow:nWidth / 2, 25)

    TButton():New( 15, 15, "Minimizar",::oTopBar,{|o| oInstance:ToggleObjectList(o)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 15, (oWindow:nWidth / 2) - 60, "Minimizar",::oTopBar,{|o|oInstance:ToggleInspector(o)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method ToggleObjectList(oButton) Class GameEditor

    If ::oScrollObjects:lVisible
        ::oScrollObjects:Hide()
        oButton:cCaption := 'Maximizar'
        oButton:cTitle := 'Maximizar'
    Else
        ::oScrollObjects:Show()
        oButton:cCaption := 'Minimizar'
        oButton:cTitle := 'Minimizar'
    EndIf

Return
/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method ToggleInspector(oButton) Class GameEditor

    If ::oInspector:lVisible
        ::oInspector:Hide()
        oButton:cCaption := 'Maximizar'
        oButton:cTitle := 'Maximizar'
    Else
        ::oInspector:Show()
        oButton:cCaption := 'Minimizar'
        oButton:cTitle := 'Minimizar'
    EndIf

Return
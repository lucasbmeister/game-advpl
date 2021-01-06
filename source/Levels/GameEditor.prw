#include "totvs.ch"
#include "gameadvpl.ch"

/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
User Function GameEditor(oLevel, oGame)

    Local oWindow as object
    Local oListObjects as object
    Local oScroll as object
    Local aDimensions as array
    Local nPanelHeight as numeric

    aDimensions := oLevel:GetDimensions()
    oWindow := oLevel:GetSceneWindow()

    oScroll := TScrollArea():New(oWindow, 01, 01, 300, 80)
    
    nPanelHeight := GetObjectList(.T.) * 51
    
    oListObjects := TPanel():New(01, 01, , oScroll,,,,,, 70, nPanelHeight)

    oScroll:SetFrame(oListObjects)

    LoadObjects(oListObjects, oWindow, oGame)

Return

/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function LoadObjects(oListObjects, oWindow, oGame)

    Local nX as numeric
    Local aObjects as array
    Local oFont as object
    Local nLine as numeric
    Local nCol as numeric
    Local oButton as object

    oFont := TFont():New('Courier new',, -16,.T.)

    nLine := 01
    nCol := 01

    aObjects := GetObjectList()

    For nX := 1 To Len(aObjects)
        oButton := TButton():New(nLine, nCol, aObjects[nX], oListObjects, {|| SpawnObject(::oCtlFocus:cName, oWindow, oGame) },70,50,,oFont,,.T.)
        oButton:cName := aObjects[nX]
        nLine += 51 
    Next

Return

/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Static Function GetObjectList(lOnlyLen)

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
Static Function SpawnObject(cClassName, oWindow, oGame)

    Local cTop as char

    cTop := AllTrim(Str(oWindow:nHeight / 2  - 100))
    cLeft := AllTrim(Str(oGame:GetMidScreen() - 100))

    oObject := &(cClassName + '():New(oWindow, ' + cTop + ','+ cLeft +')')

Return


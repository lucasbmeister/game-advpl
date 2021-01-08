#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} Class GameEditor 
Classe responsável por montar a tela de edição de níveis
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
    Data nCameraOffset
    Data oWindow 
    Data oGame
    Data oSpinBoxTop
    Data oSpinBoxLeft
    Data oSpinBoxHeight
    Data oSpinBoxWidth
    Data oCheckHasCollider
    Data oContextMenu

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
    Method UpdateInspector()
    Method OpenContextMenu()
    Method HideContextMenu()
    Method ExecuteContextOption()
    Method DeleteObject()
    Method ClearInspector()
    Method ClearSelectedObject()
    Method SetObjectTop()
    Method SetObjectLeft()
    Method SetObjectHeight()
    Method SetObjectWidth()

EndClass
/*
{Protheus.doc} Method New(oWindow, oGame) Class GameEditor
Método que instância a classe GameEditor e constrói os componentes de tela
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, oGame) Class GameEditor

    ::aObjects := {}
    ::aCombo := {}
    ::cComboObject := ''
    ::nMovementSpeed := 1
    ::nScenePanSpeed := 1
    ::nCameraOffset := 0

    ::SetGameManager(oGame)
    ::SetMainWindow(oWindow)

    ::SetupObjectList()
    ::SetupInspector()
    ::SetupTopBar()
    ::SetupObjectAxis()
    ::SetupSceneNavigator()

Return Self
/*
{Protheus.doc} Method LoadObjects(oListObjects) Class GameEditor
Carrega a lista de opções de objetos e monta um botão para cada objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
{Protheus.doc} Method SetupObjectList() Class GameEditor
Monta área de scroll da lista de objetos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
{Protheus.doc} Method SetupInspector() Class GameEditor
Monta área de inspeção do objeto selecionado permitindo alterações de suas propriedades. Aqui
também é possível alterar o objeto selecioando
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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


    TSay():new(25, 5, {|| "Topo "}, ::oInspector, , , , , , .T., CLR_WHITE, , 70, 10)
    
    ::oSpinBoxTop := TSpinBox():new(33, 5, ::oInspector, {|x| oInstance:SetObjectTop(x), oInstance:HideContextMenu()  }, 70, 13)
    ::oSpinBoxTop:SetRange(-9999, 9999)
    ::oSpinBoxTop:SetStep(1)
    ::oSpinBoxTop:SetValue(0)

    TSay():new(48, 5, {|| "Esquerda "}, ::oInspector, , , , , , .T., CLR_WHITE, , 70, 10)
    
    ::oSpinBoxLeft := TSpinBox():new(56, 5, ::oInspector, {|x| oInstance:SetObjectLeft(x - oInstance:nCameraOffset), oInstance:HideContextMenu() }, 70, 13)
    ::oSpinBoxLeft:SetRange(-9999, 9999)
    ::oSpinBoxLeft:SetStep(1)
    ::oSpinBoxLeft:SetValue(0)

    TSay():new(71, 5, {|| "Altura "}, ::oInspector, , , , , , .T., CLR_WHITE, , 70, 10)

    ::oSpinBoxHeight := TSpinBox():new(79, 5, ::oInspector, {|x| oInstance:SetObjectHeight(x), oInstance:HideContextMenu()  }, 70, 13)
    ::oSpinBoxHeight:SetRange(-9999, 9999)
    ::oSpinBoxHeight:SetStep(1)
    ::oSpinBoxHeight:SetValue(0)

    TSay():new(94, 5, {|| "Largura "}, ::oInspector, , , , , , .T., CLR_WHITE, , 70, 10)

    ::oSpinBoxWidth := TSpinBox():new(102, 5, ::oInspector, {|x|  oInstance:SetObjectWidth(x), oInstance:HideContextMenu() }, 70, 13)
    ::oSpinBoxWidth:SetRange(-9999, 9999)
    ::oSpinBoxWidth:SetStep(1)
    ::oSpinBoxWidth:SetValue(0)

    ::oCheckHasCollider := TCheckBox():New(120,5,'Colisão?',{||.T. }, ::oInspector,70,10,,,,,CLR_WHITE,,,.T.,,,)


Return
/*
{Protheus.doc} Method GetObjectList(lOnlyLen) Class GameEditor
Retorna uma array com os nomes das classes disponíveis para uso. Caso seja passado o parâmetro lOnlyLen
como .T., será retornado somente a quantidade de objetos.
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
    // deverá ser adicionado automaticamente nas cenas
    //Aadd(aObjects, 'PlayerLife')
    //Aadd(aObjects, 'PlayerScore')

Return IIF(lOnlyLen, Len(aObjects), aObjects)

/*{Protheus.doc} Method SpawnObject(cClassName, nTop, nLeft, lSetSelected) Class GameEditor
Realizada a instanciação de um objeto na área do editor e atribui funções a serem executadas quando algum
objeto for selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
    bRightBlock := &('{|| oInstance:OpenContextMenu("'+cClassName+'", '+ cValToChar(Len(::aObjects))+')} ')

    oObject:SetLeftClickAction(bLeftBlock)
    oObject:SetRightClickAction(bRightBlock)

    ::AddComboOption(Len(::aObjects), cClassName)

    If lSetSelected
        ::SetSelectedObject(Len(::aObjects))
    EndIf

    ::HideContextMenu()
    
Return

/*{Protheus.doc} Method SetSelectedObject(nObject, lCombo) Class GameEditor
Torna um objeto selecionado com base no array de objetos ativos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetSelectedObject(nObject, lCombo) Class GameEditor

    Default lCombo := .F.

    If nObject > 0 .and. !Empty(::aObjects)
        ::oSelectedObject := ::aObjects[nObject]
)
        If !lCombo
            ::cComboObject := cValToChar(nObject)
        EndIf

        ::UpdateInspector(nObject)
    EndIf

    ::HideContextMenu()

Return

/*{Protheus.doc} Method GetSelectedObject() Class GameEditor
Retorna o objeto selecionado atualmente
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetSelectedObject() Class GameEditor
Return ::oSelectedObject

/*{Protheus.doc} Method AddComboOption(nPos, cClassName) Class GameEditor
Adiciona uma nova opção na lista de objetos disponíveis (combo do inspetor)
Ex.: 1=Coin
Todo momento que ele é executado, é executado um método para trazer toda a UI para frente.
Dessa forma impede que elementos de tela fiquem atrás de objetos de jogo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method AddComboOption(nPos, cClassName) Class GameEditor
    Local nAtBkp as numeric

    nAtBkp := ::oComboObjects:nAt

    Aadd(::aCombo, cValTochar(nPos) + '=' + cClassName)

    ::oComboObjects:SetItems(AClone(::aCombo))

    ::cComboObject := cValToChar(nAtBkp)

    If Len(::aCombo) == 1
        ::SetSelectedObject(1)
    EndIf

    ::MoveUIToTop()
Return

/*{Protheus.doc} Method SetupTopBar() Class GameEditor
Realiza a instanciação da barra superior.
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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

/*{Protheus.doc} Method ToggleUIObject(oObject, oButton) Class GameEditor
Realiza a minimização/maximização de algum objeto em tela (UI)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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

/*{Protheus.doc} Method SetupObjectAxis() Class GameEditor
Realiza a instanciação das setas de manipulação de obejtos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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

/*{Protheus.doc} Method MoveObjectUp(oObject) Class GameEditor
Move o objeto do parâmetro para cima
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveObjectUp(oObject) Class GameEditor
    
    Local nSpeed as numeric

    nSpeed := ::GetMovementSpeed()

    If !Empty(oObject)
        oObject:oGameObject:nTop -= nSpeed
        ::UpdateInspector(Val(::cComboObject))
    EndIf

Return

/*{Protheus.doc} Method MoveObjectLeft(oObject) Class GameEditor
Move o objeto do parâmetro para esquerda
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveObjectLeft(oObject) Class GameEditor
    Local nSpeed as numeric

    nSpeed := ::GetMovementSpeed()
    
    If !Empty(oObject)
        oObject:oGameObject:nLeft -= nSpeed
        ::UpdateInspector(Val(::cComboObject))
    EndIf

Return

/*{Protheus.doc} Method MoveObjectLeft(oObject) Class GameEditor
Move o objeto do parâmetro para baixo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveObjectDown(oObject) Class GameEditor
    Local nSpeed as numeric

    nSpeed := ::GetMovementSpeed()
    
    If !Empty(oObject)
        oObject:oGameObject:nTop += nSpeed
        ::UpdateInspector(Val(::cComboObject))
    EndIf

Return

/*{Protheus.doc} Method MoveObjectRight(oObject) Class GameEditor
Move o objeto do parâmetro para direita
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveObjectRight(oObject) Class GameEditor

    Local nSpeed as numeric

    nSpeed := ::GetMovementSpeed()
    
    If !Empty(oObject)
        oObject:oGameObject:nLeft += nSpeed
        ::UpdateInspector(Val(::cComboObject))
    EndIf

Return

/*{Protheus.doc} Method SetMovementSpeed(nValue) Class GameEditor
Define qual será a velocidade de moviemnto dos objetos (valor de incremento das coordenadas)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetMovementSpeed(nValue) Class GameEditor
    ::nMovementSpeed := nValue
Return

/*{Protheus.doc} Method GetMovementSpeed() Class GameEditor
Retorna a velocidade de moviemnto dos objetos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetMovementSpeed() Class GameEditor
Return ::nMovementSpeed

/*{Protheus.doc} Method SetupSceneNavigator() Class GameEditor
Realiza a instanciação das setas para movimentação da câmera (movimenta a cena para os lados)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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

/*{Protheus.doc} Method MoveSceneLeft() Class GameEditor
Move a cena para esquerda
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveSceneLeft() Class GameEditor

    Local nX as numeric
    Local nSpeed as numeric

    nX := 1
    nSpeed := ::GetScenePanSpeed()

    For nX := 1 To Len(::aObjects)
        ::aObjects[nX]:oGameObject:nLeft += nSpeed
    Next

    ::nCameraOffset -= nSpeed

Return

/*{Protheus.doc} Method MoveSceneRight() Class GameEditor
Move a cena para direita
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveSceneRight() Class GameEditor

    Local nX as numeric
    Local nSpeed as numeric

    nX := 1
    nSpeed := ::GetScenePanSpeed()

    For nX := 1 To Len(::aObjects)
        ::aObjects[nX]:oGameObject:nLeft -= nSpeed
    Next

    ::nCameraOffset += nSpeed

Return

/*{Protheus.doc} Method SetScenePanSpeed(nSpeed) Class GameEditor
Define qual será a velocidade de moviemnto da câmera da cena (valor de incremento das coordenadas)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetScenePanSpeed(nSpeed) Class GameEditor
    ::nScenePanSpeed := nSpeed
Return

/*{Protheus.doc} Method GetScenePanSpeed() Class GameEditor
Retorna a velocidade de moviemnto da câmera da cena (valor de incremento das coordenadas)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetScenePanSpeed() Class GameEditor
Return ::nScenePanSpeed

/*{Protheus.doc} Method MoveUIToTop() Class GameEditor
Move os elementos de UI principais para a camada superior da tela, acima dos demais objetos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveUIToTop() Class GameEditor
    ::oInspector:MoveToTop()
    ::oScrollObjects:MoveToTop()
    ::oObjectAxis:MoveToTop()
    ::oSceneNavigator:MoveToTop()
    ::oTopBar:MoveToTop()
Return

/*{Protheus.doc} Method SetGameManager(oGame) Class GameEditor
Define a váriavel que armazena instância do GameManager
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetGameManager(oGame) Class GameEditor
    ::oGame := oGame
Return

/*{Protheus.doc} Method SetMainWindow(oWindow) Class GameEditor
Define váriavel de janela principal que será utilizada pelos elementos de tela
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetMainWindow(oWindow) Class GameEditor
    ::oWindow := oWindow
Return

/*{Protheus.doc} Method GetGameManager() Class GameEditor
Retorna instância do GameManager
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetGameManager() Class GameEditor
Return ::oGame

/*{Protheus.doc} Method GetMainWindow() Class GameEditor
Retorna janela principal do jogo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/

Method GetMainWindow() Class GameEditor
Return ::oWindow

/*{Protheus.doc} Method DuplicateObject(cClassName, nObject) Class GameEditor
Duplica um objeto que foi selecionado na área de edição
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method DuplicateObject(cClassName, nObject) Class GameEditor
    ::SpawnObject(cClassName, ::aObjects[nObject]:oGameObject:nTop / 2, ::aObjects[nObject]:oGameObject:nLeft / 2, .T.)
    ProcessMessage()
Return

/*{Protheus.doc} Method UpdateInspector(nObject) Class GameEditor
Atualiza os dados do inspetor com os do objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method UpdateInspector(nObject) Class GameEditor

    Local oObject as object
    
    oObject := ::aObjects[nObject]

    ::oSpinBoxTop:SetValue(oObject:oGameObject:nTop)
    ::oSpinBoxLeft:SetValue(oObject:oGameObject:nLeft - ::nCameraOffset)
    ::oSpinBoxHeight:SetValue(oObject:oGameObject:nHeight)
    ::oSpinBoxWidth:SetValue(oObject:oGameObject:nWidth)

Return

/*{Protheus.doc} Method OpenContextMenu(cClassName, nObject) Class GameEditor
Abre menu de contexto ao clicar com o botão direito em algum objeto no editor
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method OpenContextMenu(cClassName, nObject) Class GameEditor

    Local oWindow as object
    Local oObject as object
    Local nTop as numeric
    Local nLeft as numeric
    Local aItems as array
    
    ::HideContextMenu()

    oObject := ::aObjects[nObject]
    oWindow := ::GetMainWindow()

    nTop := oObject:oGameObject:nTop
    nLeft := oObject:oGameObject:nLeft

    aItems := {cValTochar(nObject) + '=' + cClassName, 'Duplicar','Excluir'}

    ::oContextMenu := TListBox():New(nTop / 2,nLeft / 2,{|u| },aItems,50,50,;
        {||oInstance:ExecuteContextOption(cClassName, nObject, ::oContextMenu:nAt)}, oWindow,,,,.T.)

Return

/*{Protheus.doc} Method HideContextMenu() Class GameEditor
Esconde menu de contexto caso ele esteja aberto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method HideContextMenu() Class GameEditor

    If !Empty(::oContextMenu)
        ::oContextMenu:Hide()
        FreeObj(::oContextMenu)
    EndIf

Return

/*{Protheus.doc} Method ExecuteContextOption(cClassName, nObject, nOption) Class GameEditor
Exxecuta opção selecionado no menu de contexto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method ExecuteContextOption(cClassName, nObject, nOption) Class GameEditor

    Do Case
        Case nOption == 2
            ::DuplicateObject(cClassName, nObject)
        Case nOption == 3
            ::DeleteObject(nObject)
    EndCase

    If nOption != 1
        ::HideContextMenu()
    EndIf

Return

/*{Protheus.doc} Method DeleteObject(nObject) Class GameEditor
Deleta um objeto da cena e reorganiza arrays de objetos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method DeleteObject(nObject) Class GameEditor

    Local oObject as object
    Local nX as numeric
    Local bLeftBlock as codeblock
    Local bRightBlock as codeblock
    Local cClassName as char

    oObject := ::aObjects[nObject]

    ::aCombo := {}

    oObject:HideGameObject()

    FreeObj(oObject)

    ADel(::aObjects, nObject)

    ASize(::aObjects, Len(::aObjects) - 1)

    For nX := 1 To Len(::aObjects)

        cClassName := Capital(GetClassName(::aObjects[nX]))
        Aadd(::aCombo, cValTochar(nX) + '=' + cClassName)

        bLeftBlock := &('{|| oInstance:SetSelectedObject('+cValToChar(nX)+')} ')
        bRightBlock := &('{|| oInstance:OpenContextMenu("'+cClassName+'", '+ cValToChar(nX)+')} ')

        ::aObjects[nX]:SetLeftClickAction(bLeftBlock)
        ::aObjects[nX]:SetRightClickAction(bRightBlock)
    Next

    ::ClearInspector()

    If Empty(::aCombo)
        ::oComboObjects:aItems := {''}
    Else
        ::oComboObjects:aItems := AClone(::aCombo)
        ::SetSelectedObject(1)
    EndIf

    ::oComboObjects:Refresh()

Return

/*{Protheus.doc} Method ClearInspector() Class GameEditor
Limpa dados do inspetor de objetos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method ClearInspector() Class GameEditor
    ::oSpinBoxTop:SetValue(0)
    ::oSpinBoxLeft:SetValue(0)
    ::oSpinBoxHeight:SetValue(0)
    ::oSpinBoxWidth:SetValue(0)

    ::ClearSelectedObject()
Return

/*{Protheus.doc} Method ClearSelectedObject() Class GameEditor
Limpa objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method ClearSelectedObject() Class GameEditor

    ::oSelectedObject := Nil
    ::cComboObject := ''

Return

/*{Protheus.doc} Method SetObjectTop(nTop) Class GameEditor
Altera coordenada nTop do objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectTop(nTop) Class GameEditor

    Local oObject as object

    oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:oGameObject:nTop := nTop
    EndIf

Return 

/*{Protheus.doc} Method SetObjectLeft(nLeft) Class GameEditor
Altera coordenada nLeft do objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectLeft(nLeft) Class GameEditor

    Local oObject as object

    oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:oGameObject:nLeft := nLeft
    EndIf

Return 

/*{Protheus.doc} Method SetObjectHeight(nHeight) Class GameEditor
Altera propriedade nHeight do objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectHeight(nHeight) Class GameEditor

    Local oObject as object

    oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:oGameObject:nHeight := nHeight
    EndIf

Return 

/*{Protheus.doc} Method SetObjectWidth(nWidth) Class GameEditor
Altera propriedade nWidth do objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectWidth(nWidth) Class GameEditor

    Local oObject as object

    oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:oGameObject:nWidth := nWidth
    EndIf

Return 

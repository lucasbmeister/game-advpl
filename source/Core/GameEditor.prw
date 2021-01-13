#include "totvs.ch"
#include "gameadvpl.ch"
#include "fileio.ch"

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
    Data cSceneDescription
    Data cSceneId
    Data aUIObjects
    Data oSpinBoxTopMargin
    Data oSpinBoxLeftMargin
    Data oSpinBoxBottomMargin
    Data oSpinBoxRightMargin
    Data lHasCollider    
    Data lIsEditing

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
    Method SetObjectTopMargin()
    Method SetObjectLeftMargin()
    Method SetObjectBottomMargin()
    Method SetObjectRightMargin()
    Method ToggleObjectCollision()
    Method DisableMarginFields() 
    Method EnableMarginFields()
    Method SceneFromJson()
    Method SceneToJson()
    Method Save()
    Method Load()
    Method GoBack()
    Method Hide()
    Method IsEditing()
    Method SetEditing()
    Method NewScene()
    Method UnloadCurrentScene()
    Method Import()
    Method Export()

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
    ::aUIObjects := {}
    ::lHasCollider := .F.
    ::lIsEditing := .F.

    ::cSceneId := Space(20)
    ::cSceneDescription := Space(40)

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
    Local cName as char

    Static oInstance as object

    oInstance := Self
    oFont := TFont():New('Courier new',, -16,.T.)

    nLine := 01
    nCol := 01

    aObjects := ::GetObjectList()

    For nX := 1 To Len(aObjects)

        cName := aObjects[nX][1]

        If !Empty(aObjects[nX][2])
            cName := ''
        EndIf

        oButton := TButton():New(nLine, nCol, cName, oListObjects, {|o| oInstance:SpawnObject(o:cName) },70,50,,oFont,,.T.) 
        oButton:SetCSS(U_GetButtonCSS(aObjects[nX][2], .F., .F.))

        oButton:cName := aObjects[nX][1]
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

    AAdd(::aUIObjects, ::oScrollObjects)

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

    AAdd(::aUIObjects, ::oInspector)

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

    ::oCheckHasCollider := TCheckBox():New(120,5,'Colisão?',{|x| IIF(PCount()>0,oInstance:lHasCollider:=x,oInstance:lHasCollider) }, ::oInspector,70,10,,{|x| oInstance:ToggleObjectCollision(x)},,,CLR_WHITE,,,.T.,,,)

    TSay():new(135, 5, {|| "Margem Superior"}, ::oInspector, , , , , , .T., CLR_WHITE, , 70, 10)

    ::oSpinBoxTopMargin := TSpinBox():new(143, 5, ::oInspector, {|x|  oInstance:SetObjectTopMargin(x), oInstance:HideContextMenu() }, 70, 13)
    ::oSpinBoxTopMargin:SetRange(-9999, 9999)
    ::oSpinBoxTopMargin:SetStep(1)
    ::oSpinBoxTopMargin:SetValue(0)

    TSay():new(158, 5, {|| "Margem Esquerda "}, ::oInspector, , , , , , .T., CLR_WHITE, , 70, 10)

    ::oSpinBoxLeftMargin := TSpinBox():new(166, 5, ::oInspector, {|x|  oInstance:SetObjectLeftMargin(x), oInstance:HideContextMenu() }, 70, 13)
    ::oSpinBoxLeftMargin:SetRange(-9999, 9999)
    ::oSpinBoxLeftMargin:SetStep(1)
    ::oSpinBoxLeftMargin:SetValue(0)

    TSay():new(181, 5, {|| "Margem Inferior "}, ::oInspector, , , , , , .T., CLR_WHITE, , 70, 10)

    ::oSpinBoxBottomMargin := TSpinBox():new(189, 5, ::oInspector, {|x|  oInstance:SetObjectBottomMargin(x), oInstance:HideContextMenu() }, 70, 13)
    ::oSpinBoxBottomMargin:SetRange(-9999, 9999)
    ::oSpinBoxBottomMargin:SetStep(1)
    ::oSpinBoxBottomMargin:SetValue(0)

    TSay():new(204, 5, {|| "Margem Direita "}, ::oInspector, , , , , , .T., CLR_WHITE, , 70, 10)

    ::oSpinBoxRightMargin := TSpinBox():new(212, 5, ::oInspector, {|x|  oInstance:SetObjectRightMargin(x), oInstance:HideContextMenu() }, 70, 13)
    ::oSpinBoxRightMargin:SetRange(-9999, 9999)
    ::oSpinBoxRightMargin:SetStep(1)
    ::oSpinBoxRightMargin:SetValue(0)

    ::DisableMarginFields()

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
    Aadd(aObjects, {'Ground', 'environment/ground.png'})
    Aadd(aObjects, {'Coin', 'collectables/coin_1/animation/idle/forward/coin_1_1.png'})
    Aadd(aObjects, {'Player', 'player/animation/idle/forward/HeroKnight_Idle_0.png'})
    Aadd(aObjects, {'FloatingGround1', 'environment/floating_ground_1.png'})
    Aadd(aObjects, {'FloatingGround2', 'environment/floating_ground_2.png'})
    Aadd(aObjects, {'FloatingGround3', 'environment/floating_ground_3.png'})
    Aadd(aObjects, {'Enemy', 'player/animation/idle/backward/HeroKnight_Idle_0.png'})
    Aadd(aObjects, {'Square', ''})
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

Return oObject

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

    AAdd(::aUIObjects, ::oTopBar)

    TButton():New( 14, 01, "-",::oTopBar,{|o| oInstance:ToggleUIObject(oInstance:oScrollObjects, o)}, 10,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TSay():New(15,13,{||'Lista Objetos'},::oTopBar,,,,,,.T.,CLR_WHITE,CLR_BLACK,50,20)

    TButton():New( 14, (oWindow:nWidth / 2) - 12, "-",::oTopBar,{|o|oInstance:ToggleUIObject(oInstance:oInspector, o)}, 10,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TSay():New(15,(oWindow:nWidth / 2) - 35,{||'Inspetor'},::oTopBar,,,,,,.T.,CLR_WHITE,CLR_BLACK,30,20)

    TButton():New( 02, 01, "Novo",::oTopBar,{|o|oInstance:NewScene()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 02, 31, "Importar",::oTopBar,{|o|oInstance:Import()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 02, 61, "Exportar",::oTopBar,{|o|oInstance:Export()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 02, (oWindow:nWidth / 2) - 92, "Voltar",::oTopBar,{|o|oInstance:GoBack()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 02, (oWindow:nWidth / 2) - 62, "Carregar",::oTopBar,{|o|oInstance:Load()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 02, (oWindow:nWidth / 2) - 32, "Salvar",::oTopBar,{|o|oInstance:Save()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )

    TGet():New(02,95,{|u| If( PCount() == 0, oInstance:cSceneId, oInstance:cSceneId := u) },;
        ::oTopBar,70,9,"@!",,0,,,.F.,,.T.,,.F.,{|| !oInstance:IsEditing()},.F.,.F.,,.F.,.F.,,oInstance:cSceneId,,,,,,,'ID Cena',1,,CLR_WHITE )

    TGet():New(02,166,{|u| If( PCount() == 0, oInstance:cSceneDescription, oInstance:cSceneDescription := u) },;
        ::oTopBar,70,9,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,oInstance:cSceneDescription,,,,,,,'Desc. Cena',1,,CLR_WHITE  )

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

    AAdd(::aUIObjects, ::oObjectAxis)

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
        oObject:MoveUp(nSpeed)
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
        oObject:MoveLeft(nSpeed)
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
        oObject:MoveDown(nSpeed)
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
        oObject:MoveRight(nSpeed)
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

    AAdd(::aUIObjects, ::oSceneNavigator)

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
        ::aObjects[nX]:MoveRight(nSpeed)
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
        ::aObjects[nX]:MoveLeft(nSpeed)
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

    If oObject:HasCollider()

        ::lHasCollider := .T.
        ::EnableMarginFields()

        ::oSpinBoxTopMargin:SetValue(oObject:nTopMargin)
        ::oSpinBoxLeftMargin:SetValue(oObject:nLeftMargin)
        ::oSpinBoxBottomMargin:SetValue(oObject:nBottomMargin)
        ::oSpinBoxRightMargin:SetValue(oObject:nRightMargin)
    Else
        ::lHasCollider := .F.
        ::DisableMarginFields(.T.)
    EndIf

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
Method ClearInspector(lNewScene) Class GameEditor

    Default lNewScene := .F.

    ::oSpinBoxTop:SetValue(0)
    ::oSpinBoxLeft:SetValue(0)
    ::oSpinBoxHeight:SetValue(0)
    ::oSpinBoxWidth:SetValue(0)

    ::oSpinBoxTopMargin:SetValue(0)
    ::oSpinBoxLeftMargin:SetValue(0)
    ::oSpinBoxBottomMargin:SetValue(0)
    ::oSpinBoxRightMargin:SetValue(0)

    ::lHasCollider := .F.

    ::DisableMarginFields()

    If lNewScene
        ::oComboObjects:aItems := {''}
        ::cComboObject := ''
        ::aCombo := {}
    EndIf

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
Method SetObjectTop(nTop, oObject) Class GameEditor

    Default oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:SetTop(nTop)
    EndIf

Return

/*{Protheus.doc} Method SetObjectLeft(nLeft) Class GameEditor
Altera coordenada nLeft do objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectLeft(nLeft, oObject) Class GameEditor

    Default oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:SetLeft(nLeft)
    EndIf

Return

/*{Protheus.doc} Method SetObjectHeight(nHeight) Class GameEditor
Altera propriedade nHeight do objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectHeight(nHeight, oObject) Class GameEditor

    Default oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:SetHeight(nHeight)
    EndIf

Return

/*{Protheus.doc} Method SetObjectWidth(nWidth) Class GameEditor
Altera propriedade nWidth do objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectWidth(nWidth, oObject) Class GameEditor

    Default oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:SetWidth(nWidth)
    EndIf

Return

/*{Protheus.doc} Method SetObjectWidth(nWidth) Class GameEditor
Instância cena no editor com base no JSON salvo.
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SceneFromJson(cFilePath) Class GameEditor

    Local oScene as object
    Local nHandle as numeric
    Local cJson as char

    nHandle := FT_FUse(cFilePath)

    cJson := ''

    FT_FGoTop()

    While !FT_FEoF()
        cJson += FT_FReadLn()
        FT_FSkip()
    EndDo

    oScene := JsonObject():New()

    oScene:FromJson(cJson)

    FClose(nHandle)

Return oScene

/*{Protheus.doc} Method ToJson()
Transofrma informaçõoes da cena em um json para ser salvo em disco
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SceneToJson() Class GameEditor

    Local nX as numeric
    Local oScene as object
    Local oObject as object

    oScene := JsonObject():New()

    oScene['sceneId'] := AllTrim(::cSceneId)
    oScene['sceneDescription'] := ::cSceneDescription

    oScene['objects'] := {}

    For nX := 1 To Len(::aObjects)
        oObject := JsonObject():New()

        oObject['className'] := Capital(GetClassName(::aObjects[nX]))
        oObject['top'] := ::aObjects[nX]:oGameObject:nTop / 2
        oObject['left'] := (::aObjects[nX]:oGameObject:nLeft - ::nCameraOffset) / 2
        oObject['height'] := ::aObjects[nX]:oGameObject:nHeight
        oObject['width'] := ::aObjects[nX]:oGameObject:nWidth

        oObject['hasCollider'] := ::aObjects[nX]:HasCollider()

        oObject['topMargin'] := ::aObjects[nX]:nTopMargin
        oObject['leftMargin'] := ::aObjects[nX]:nLeftMargin
        oObject['bottomMargin'] := ::aObjects[nX]:nBottomMargin
        oObject['rightMargin'] := ::aObjects[nX]:nRightMargin

        Aadd(oScene['objects'], oObject)
    Next

Return oScene:ToJson()

/*{Protheus.doc} Method Save()
Salva cena
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Save() Class GameEditor

    Local cJson as char
    Local cTempDir as char
    Local cFilePath as char
    Local nHandle as numeric

    If Empty(::cSceneId) .or. Empty(::cSceneDescription)
        MsgAlert('Preencher os campos de ID e descrição da cena.', 'Editor')
        Return
    EndIf 

    If Empty(::aObjects)
        MsgAlert('Nenhum objeto em cena. Nada será salvo.', 'Editor')
        Return
    EndIf

    cTempDir := GetTempPath()
    cJson := ::SceneToJson()

    cTempDir +=  'gameadvpl\levels'

    cFilePath := cTempDir + '\' + AllTrim(::cSceneId) + '.json'

    If !ExistDir(cTempDir)
        MakeDir(cTempDir)
    EndIf

    If File(cFilePath) .and. !::IsEditing() .and. !MsgNoYes('Já existe uma cena com este ID. Por favor, deseja substituir?','Aviso')
        Return
    ElseIf File(cFilePath) .and. ::IsEditing()
        FErase(cFilePath)
    EndIf

    nHandle := FCreate(cFilePath, FC_NORMAL)

    FWrite(nHandle,cJson)

    FClose(nHandle)

    MsgInfo('Salvo!','Editor')

Return

/*{Protheus.doc} Method Load()
Carrega cena salva
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Load() Class GameEditor

    Local cTempDir as char
    Local cFilePath as char
    Local oScene as object
    Local nX as numeric
    Local oCurrentObject as object
    Local oObject as object
    Local lDiscard as logical

    cTempDir := GetTempPath() + 'gameadvpl\levels'

    If !Empty(::aObjects)
        lDiscard := MsgNoYes('Os dados não salvos serão perdidos. Deseja continuar?','Aviso')
    Else
        lDiscard := .T.
    EndIf

    If lDiscard
        ::UnloadCurrentScene()
        // não há cristo que faça essa função funcionar
        //cFilePath := TFileDialog( "Arquivos JSON (*.json)", 'Selecao de Cena',, cTempDir, .F., 16 + 256 + 512)
        cFilePath := cGetFile( '*.json|*.json' , 'Arquivos JSON (.json)', 1, cTempDir, .F., 16 + 256 + 512 ,.F., .T. )
        If !Empty(cFilePath)
            oScene := ::SceneFromJson(cFilePath)
        Else
            MsgAlert('Nada Selecionado', 'Aviso')
        EndIf

        If ValType(oScene) == 'J'

            ::cSceneID := oScene['sceneId']
            ::cSceneDescription := oScene['sceneDescription']

            ::SetEditing(.T.)

            For nX := 1 To Len(oScene['objects'])
                oCurrentObject := oScene['objects'][nX]
                oObject := ::SpawnObject(oCurrentObject['className'], oCurrentObject['top'], oCurrentObject['left'])

                ::SetObjectHeight(oCurrentObject['height'], oObject)
                ::SetObjectWidth(oCurrentObject['width'], oObject)

                If oCurrentObject['hasCollider']

                    oObject:EnableEditorCollider()

                    oObject:SetTopMargin(oCurrentObject['topMargin'])
                    oObject:SetLeftMargin(oCurrentObject['leftMargin'])
                    oObject:SetBottomMargin(oCurrentObject['bottomMargin'])
                    oObject:SetRightMargin(oCurrentObject['rightMargin'])
                EndIf

            Next
        EndIf

    EndIf

Return

/*{Protheus.doc} Method GoBack()
Volta para tela de níveis
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GoBack() Class GameEditor

    Local oGame as object

    oGame := ::GetGameManager()

    oGame:LoadScene('levels')

Return

/*{Protheus.doc} Method Hide()
Destrói cena
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Hide() Class GameEditor

    Local nX as numeric

    ::UnloadCurrentScene()

    For nX := Len(::aUIObjects) To 1 STEP -1
        ::aUIObjects[nX]:Hide()
        FreeObj(::aUIObjects[nX])
        ADel(::aUIObjects, nX)
        ASize(::aUIObjects, Len(::aUIObjects) - 1)
    Next

Return

/*{Protheus.doc} Method SetObjectTopMargin() Class GameEditor
Define margem superior do objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectTopMargin(nTopMargin, oObject) Class GameEditor

    Default oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:SetTopMargin(nTopMargin)
    EndIf

Return

/*{Protheus.doc} Method SetObjectLeftMargin(nLeftMargin) Class GameEditor
Define margem esquerda do objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectLeftMargin(nLeftMargin, oObject) Class GameEditor

    Default oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:SetLeftMargin(nLeftMargin)
    EndIf

Return

/*{Protheus.doc} Method SetObjectBottomMargin(nBottomMargin) Class GameEditor
Define margem inferior do objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectBottomMargin(nBottomMargin, oObject) Class GameEditor

    Default oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:SetBottomMargin(nBottomMargin)
    EndIf

Return

/*{Protheus.doc} Method SetObjectRightMargin(nRightMargin) Class GameEditor
Define margem direita do objeto
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetObjectRightMargin(nRightMargin, oObject) Class GameEditor

    Default oObject := ::GetSelectedObject()

    If !Empty(oObject)
        oObject:SetRightMargin(nRightMargin)
    EndIf

Return

/*{Protheus.doc} Method ToggleObjectCollision() Class GameEditor
HAbilita ou desabilitar colisão do objeto selecionado
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method ToggleObjectCollision(nEnable, oObject) Class GameEditor

    Default oObject := ::GetSelectedObject()

    If !Empty(oObject)
        If ::lHasCollider .and. !oObject:HasCollider()
            oObject:EnableEditorCollider()
            ::EnableMarginFields()
            ::MoveUIToTop()
        ElseIF oObject:HasCollider()
            oObject:DisableEditorCollider()
            ::DisableMarginFields(.T.)
        EndIf
    EndIf

Return

/*{Protheus.doc} Method DisableMarginFields() Class GameEditor
Desabilita campos de margem 
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method DisableMarginFields(lZero) Class GameEditor

    ::oSpinBoxTopMargin:Disable()
    ::oSpinBoxLeftMargin:Disable()
    ::oSpinBoxBottomMargin:Disable()
    ::oSpinBoxRightMargin:Disable()

    If lZero
        ::oSpinBoxTopMargin:SetValue(0)
        ::oSpinBoxLeftMargin:SetValue(0)
        ::oSpinBoxBottomMargin:SetValue(0)
        ::oSpinBoxRightMargin:SetValue(0)
    EndIf
Return

/*{Protheus.doc} Method DisableMarginFields() Class GameEditor
Desabilita campos de margem 
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method EnableMarginFields() Class GameEditor
    ::oSpinBoxTopMargin:Enable()
    ::oSpinBoxLeftMargin:Enable()
    ::oSpinBoxBottomMargin:Enable()
    ::oSpinBoxRightMargin:Enable()
Return

/*{Protheus.doc} Method IsEditing() Class GameEditor
Retorna se está editando um cena
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsEditing() Class GameEditor
Return ::lIsEditing

/*{Protheus.doc} Method SetEditing(lEditing) Class GameEditor
Define se o editor está em edição de cena salva
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetEditing(lEditing) Class GameEditor
    ::lIsEditing := lEditing
Return

/*{Protheus.doc} Method SetEditing(lEditing) Class GameEditor
Define se o editor está em edição de cena salva
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method NewScene() Class GameEditor

    If !Empty(::aObjects) .and. MsgNoYes('Os dados não salvos serão perdidos. Deseja continuar?','Aviso')
        ::SetEditing(.F.)
        ::UnloadCurrentScene()
    EndIf

Return

/*{Protheus.doc} Method UnloadCurrentScene() Class GameEditor
Descarrega cena atual
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method UnloadCurrentScene() Class GameEditor

    AEval(::aObjects,{|x| IIF(MethIsMemberOf(x, 'HideGameObject'),x:HideGameObject(), x:Hide()), FreeObj(x) })
    ASize(::aObjects , 0)

    ::cSceneDescription := ''
    ::cSceneID := ''

    ::ClearInspector(.T.)
    ::ClearSelectedObject()

Return

/*{Protheus.doc} Method Import() Class GameEditor
Importa cena no formato .level (.zip renomeado)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Import() Class GameEditor
Return

/*{Protheus.doc} Method Export() Class GameEditor
Exporta cena no formato .level (.zip renomeado)
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Export() Class GameEditor
Return

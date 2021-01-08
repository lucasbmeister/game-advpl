#include "totvs.ch"
#include "gameadvpl.ch"

/*
{Protheus.doc} Class Scene
Classe que representa uma cena. Ela �  respons�vel por armazenar os objetos de uma
cena e realizar opera��es de atualiz��es por frame. Ela tamb�m atualiza a poi��o
da c�mera
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class Scene

    Data aObjects
    Data oParent
    Data lActive
    Data cId
    Data nLeft
    Data nTop
    Data nHeight
    Data nWidth
    Data bLoadObjects
    Data cDescription
    Data nCameraPostion

    Method New() Constructor
    Method GetSceneID()
    Method AddObject()
    Method GetSceneWindow()
    Method Update()
    Method Start()
    Method EndScene()
    Method SetInitCodeBlock()
    Method GetDimensions()
    Method SetActive()
    Method IsActive()
    Method ClearScene()
    Method GetObjectsWithColliders()
    Method SetDescription()
    Method GetDescription()
    Method UpdateCamera()
    Method IsGameObject()

EndClass

/*
{Protheus.doc} Method New(oWindow, cId, nTop, nLeft, nHeight, nWidth) Class Scene
Inst�ncia classe Scene
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, cId, nTop, nLeft, nHeight, nWidth) Class Scene

    Static oInstance as object

    Default nLeft := 180
    Default nTop := 180
    Default nHeight := 550
    Default nWidth := 700

    oInstance := Self
    ::oParent := oWindow

    ::nLeft := nLeft
    ::nTop := nTop
    ::nHeight := nHeight
    ::nWidth := nWidth
    ::cId := cId
    ::cDescription := cId
    ::nCameraPostion := nil

    ::aObjects := {}

    ::SetActive(.F.)

Return

/*
{Protheus.doc} Method GetSceneID() Class Scene
Retorna ID �nico da cena.
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetSceneID() Class Scene
Return ::cId

/*
{Protheus.doc} Method Update(oGameManager) Class Scene
Realiza as l�gicas de atualiza��o de frame de cada objeto e remove objetos
marcados para destrui��o
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Update(oGameManager) Class Scene

    Local nX as numeric

    For nX := Len(::aObjects)  To 1 STEP -1
        If ::IsActive()
            //::aObjects[nX]:Update(oGameManager)
            If MethIsMemberOf(::aObjects[nX], 'Update')
                ::aObjects[nX]:Update(oGameManager)
            EndIf
            //If ::aObjects[nX]:ShouldDestroy()
            If MethIsMemberOf(::aObjects[nX], 'ShouldDestroy') .and. ::aObjects[nX]:ShouldDestroy()
                FreeObj(::aObjects[nX])
                ADel(::aObjects, nX)
                ASize(::aObjects, Len(::aObjects) - 1)
            EndIf
        Else
            Exit
        EndIf
    Next nX

Return

/*
{Protheus.doc} Method AddObject(oObject) Class Scene
Adiciona um objeto na cena
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method AddObject(oObject) Class Scene
    Aadd(::aObjects, oObject)
Return

/*
{Protheus.doc} Method Start() CLass Scene
Inicia a cena, chamandoo o bloco de c�digo de constru��o
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method Start() CLass Scene
    ::ClearScene()
    ::SetActive(.T.)
    Eval(::bLoadObjects, Self)
Return

/*
{Protheus.doc} Method EndScene() Class Scene
Encerra uma cena limpando seus objetos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method EndScene() Class Scene
    ::SetActive(.F.)
    ::ClearScene()
Return

/*
{Protheus.doc} Method GetSceneWindow() Class Scene
Retorna janela pai da cena
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetSceneWindow() Class Scene
Return ::oParent

/*
{Protheus.doc} Method SetInitCodeBlock(bBlock) Class Scene
Define bloco de c�digo que ser� executado no m�todo ::Start()
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetInitCodeBlock(bBlock) Class Scene
    ::bLoadObjects := bBlock
Return

/*
{Protheus.doc} Method GetDimensions() Class Scene
Retorna array dimens�es da cena
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetDimensions() Class Scene
Return { ::nTop, ::nLeft, ::nHeight, ::nWidth}

/*
{Protheus.doc} Method SetActive(lActive) Class Scene
Maraca a cena como ativa
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetActive(lActive) Class Scene
    ::lActive := lActive
Return

/*
{Protheus.doc} Method IsActive() Class Scene
Verifica se a cena est� ativa
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsActive() Class Scene
Return ::lActive

/*
{Protheus.doc} Method ClearScene() Class Scene
Limpa a cena, eliminando todos os objetos
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method ClearScene() Class Scene
    //AEval(::aObjects,{|x| x:HideGameObject(), FreeObj(x) })
    AEval(::aObjects,{|x| IIF(MethIsMemberOf(x, 'HideGameObject'),x:HideGameObject(), x:Hide()), FreeObj(x) })
    ASize(::aObjects , 0)
Return

/*
{Protheus.doc} Method GetObjectsWithColliders() Class Scene
Retorna todos os objetos que possuem colis�es ativas
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetObjectsWithColliders() Class Scene
    Local aObjColl as array
    aObjColl := {}

    AEval(::aObjects,{|x| IIF(x:HasCollider(), AAdd(aObjColl, x), nil)})

Return aObjColl

/*
{Protheus.doc} Method SetDescription(cDesc) Class Scene
Define descri��o da cena
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method SetDescription(cDesc) Class Scene
    ::cDescription := cDesc
Return

/*
{Protheus.doc} Method GetDescription() Class Scene
Retorna descri��o da cena
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method GetDescription() Class Scene
Return ::cDescription

/*
{Protheus.doc} Method UpdateCamera(oGame, cDirection, nSpeed) Class Scene
Atualiza posi��o da c�mera
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method UpdateCamera(oGame, cDirection, nSpeed) Class Scene

    Local nX as numeric

    If cDirection == 'forward'
        nSpeed := -nSpeed
    EndIF

    If ::nCameraPostion == nil
        ::nCameraPostion := oGame:GetMidScreen()
    EndIf

    For nX := 1 To Len(::aObjects)
        If ::IsGameObject(::aObjects[nX]) .and.::aObjects[nX]:GetTag() != 'background'
            // If ::nCameraPostion - oGame:GetStartLimit() >= oGame:GetMidScreen() .or.;
            //         oGame:GetEndLimit() - ::nCameraPostion <= oGame:GetMidScreen()
            ::aObjects[nX]:oGameObject:nLeft += nSpeed
            //EndIf
        EndIf
    Next
    
    ::nCameraPostion += nSpeed

Return

/*
{Protheus.doc} Method IsGameObject(oObject) Class Scene
Verifica se objeto � um objeto de jogo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method IsGameObject(oObject) Class Scene
REturn AttIsMemberOf(oObject, 'oGameObject', .T.) .and. MethIsMemberOf(oObject, 'GetTag', .T.) .and. !Empty(oObject:oGameObject)
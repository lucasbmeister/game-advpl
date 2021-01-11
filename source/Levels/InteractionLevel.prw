#include "totvs.ch"
#include "gameadvpl.ch"

/*{Protheus.doc} User Function LoadInteraction(oEditor, oGame)
Espera interação do usuário para poder executar sons posteriormente
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
User Function LoadInteraction(oInteraction, oGame)

    Local oWindow as object
    Local oObject as object

    oWindow := oEditor:GetSceneWindow()

    oObject := InteractionObejct():New(oWindow, oGame)

    oInteraction:AddObject(oObject)

Return
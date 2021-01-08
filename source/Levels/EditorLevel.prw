#include "totvs.ch"
#include "gameadvpl.ch"

/*{Protheus.doc} User Function EditorLevel(oEditor, oGame)
Monta cena do editor
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
User Function EditorLevel(oEditor, oGame)

    Local oWindow as object
    Local oGameEditor as object

    oWindow := oEditor:GetSceneWindow()

    oGameEditor := GameEditor():New(oWindow, oGame)

    oEditor:AddObject(oGameEditor)

Return
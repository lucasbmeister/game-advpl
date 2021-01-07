#include "totvs.ch"
#include "gameadvpl.ch"

/*{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
User Function EditorLevel(oEditor, oGame)

    Local oWindow as object
    Local oGameEditor as object

    oWindow := oEditor:GetSceneWindow()

    oGameEditor := GameEditor():New(oWindow, oGame)

    oEditor:AddObject(oGameEditor)

Return
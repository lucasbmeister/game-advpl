#include "totvs.ch"

Class BaseGameObject

    Data cAssetsPath
    Data oWindow

    Method New() Constructor
    Method SetWindow()
    Method GetAssetsPath()

EndClass

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method New(oWindow) Class BaseGameObject
    Local cTempPath as char
    cTempPath := GetTempPath()
    ::cAssetsPath := cTempPath + "gameadvpl\assets\

    if !Empty(oWindow)
        ::SetWindow(oWindow)
    EndIf
    
Return Self

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method SetWindow(oWindow) Class BaseGameObject
    ::oWindow := oWindow
Return 

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method GetAssetsPath(cAsset) Class BaseGameObject
Return ::cAssetsPath + cAsset
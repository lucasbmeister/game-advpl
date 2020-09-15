#include "totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------  
Class SidePanel From BaseGameObject

    Data oPanel
    Data aDimensions

    Method New() Constructor
    Method Update()

EndClass
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method New(oWindow, nTop, nLeft, nWidth, nHeight) Class SidePanel

    ::SetWindow(oWindow)
    ::aDimensions := {nTop, nLeft, nWidth, nHeight}

    ::oPanel := TPanel():New(::aDimensions[1], ::aDimensions[2],"",::oWindow,,.T.,, CLR_GRAY, CLR_GRAY, ::aDimensions[3], ::aDimensions[4])

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method Update() Class SidePanel
Return
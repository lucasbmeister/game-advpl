#include "totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
CLass Clouds From BaseGameObject

    Data aClouds
    Data aDimensions

    Method New() Constructor
    Method Update()
    Method CreateCloud()

EndClass

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method New(oWindow, nTop, nLeft, nBottom, nRight) Class Clouds
    _Super:New(oWindow)
    ::aClouds := {}
    ::aDimensions := {nTop, nLeft, nBottom, nRight}
    // ::oPanel := TBitmap():New( 1, 1, 100, 100, , ::GetAssetsPath("cloud.png"), .T., oInstance:oWindow,;
    //  nil, nil, .F.,  .F., nil, nil, nil, nil, .F.)

Return
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method Update(oGameManager) Class Clouds

    Local nX as numeric

    While Len(::aClouds) <= 5
        AAdd(::aClouds,::CreateCloud())
    EndDo

    For nX := Len(::aClouds) To 1 STEP -1
        If ::aClouds[nX]:nLeft + 1 >= ::aDimensions[4]//fora da tela
            ADel(::aClouds, nX)
            ::aClouds[Len(::aClouds)] := ::CreateCloud()
        Else
            ::aClouds[nX]:nLeft += 1
        EndIf
    Next nX

Return
//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Method CreateCloud() Class Clouds
    Local oCloud as object

    oCloud := TBitmap():New(Randomize(1, 15), Randomize(1, 30), 100, 100, , ::GetAssetsPath("cloud.png"), .T., ::oWindow,;
        nil, nil, .F.,  .F., nil, nil, nil, nil, .F.)

Return oCloud

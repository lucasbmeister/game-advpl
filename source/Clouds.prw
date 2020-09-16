#include "totvs.ch"

#DEFINE SPAWN_INTERVAL 7000
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
CLass Clouds From BaseGameObject

    Data aClouds
    Data aDimensions
    Data cStyle
    Data nLastSpawn

    Method New() Constructor
    Method Update()
    Method CreateCloud()

EndClass

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, nTop, nLeft, nBottom, nRight) Class Clouds
    _Super:New(oWindow)
    ::aClouds := {}
    ::nLastSpawn := 0
    ::aDimensions := {nTop, nLeft, nBottom, nRight}
    ::cStyle := "QFrame{ border-image: url("+StrTran(::GetAssetsPath("cloud.png"),"\","/")+") 0 0 0 0 stretch stretch }"


Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method Update(oGameManager) Class Clouds

    Local nX as numeric
    Local nTime as numeric

    nTime := TimeCounter()

    If Len(::aClouds) <= 5 .and. nTime - ::nLastSpawn >= SPAWN_INTERVAL
        AAdd(::aClouds,::CreateCloud())
        ::nLastSpawn := nTime
    EndIf

    For nX := Len(::aClouds) To 1 STEP -1
        If ::aClouds[nX]:nLeft + 1 >= ::aDimensions[4]//fora da tela
            ADel(::aClouds, nX)
            ::aClouds[Len(::aClouds)] := ::CreateCloud()
        Else
            ::aClouds[nX]:nLeft += 1
        EndIf
    Next nX

Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method CreateCloud() Class Clouds
    Local oCloud as object

    // oCloud := TBitmap():New(Randomize(1, 15), Randomize(1, 30), 100, 100, , ::GetAssetsPath("cloud.png"), .T., ::oWindow,;
    //     nil, nil, .F.,  .F., nil, nil, nil, nil, .F.)
    oCloud := TPanelCss():New(Randomize(1, 150), -70, , ::oWindow,,,,,, 70, 25)
    oCloud:SetCss(::cStyle)

Return oCloud

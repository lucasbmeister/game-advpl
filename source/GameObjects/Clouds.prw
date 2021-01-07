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
    Method HideGameObject()

EndClass

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth) Class Clouds
    _Super:New(oWindow)
    ::aClouds := {}
    ::nLastSpawn := 0
    ::aDimensions := {nTop, nLeft, nHeight, nWidth}
    ::cStyle := "TPanel { border-image: url("+StrTran(::GetAssetsPath("environment\cloud.png"),"\","/")+") 0 0 0 0 stretch stretch }"


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

    If Len(::aClouds) < 5 .and. nTime - ::nLastSpawn >= SPAWN_INTERVAL 
        If Randomize(1, 100) < 40
            AAdd(::aClouds,::CreateCloud())
        EndIf

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

    oCloud := TPanel():New(Randomize(1, 20), -70, , ::oWindow,,,,,, 70, 25)
    oCloud:SetCss(::cStyle)

Return oCloud
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method HideGameObject() Class Clouds

    Local nX as numeric

    For nX := 1 To Len(::aClouds)
        ::aClouds[nX]:Hide()
        FreeObj(::aClouds[nX])
    Next nX

    ASize(::aClouds, 0)

Return
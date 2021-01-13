#include "totvs.ch"

/*
{Protheus.doc} Class FloatingGround2
Classe para objetos de piso flutuantes do tipo 12
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class FloatingGround2 From FloatingGroundBase

    Method New() Constructor

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth, nType) Class FloatingGround2
Instância classe FloatinGround1
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth) Class FloatingGround2
    _Super:New(oWindow, nTop, nLeft, /*height*/,/*width*/,2)
Return

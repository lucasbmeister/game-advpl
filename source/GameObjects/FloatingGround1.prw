#include "totvs.ch"

/*
{Protheus.doc} Class FloatingGround1
Classe para objetos de piso flutuantes do tipo 1
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class FloatingGround1 From FloatingGroundBase

    Method New() Constructor

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth, nType) Class FloatingGround1
Instância classe FloatinGround1
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth) Class FloatingGround1
    _Super:New(oWindow, nTop, nLeft, /*height*/,/*width*/,1)
Return

#include "totvs.ch"

/*
{Protheus.doc} Class FloatingGround3
Classe para objetos de piso flutuantes do tipo 3
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Class FloatingGround3 From FloatingGroundBase

    Method New() Constructor

EndClass

/*
{Protheus.doc} Method New(oWindow, nTop, nLeft, nHeight, nWidth, nType) Class FloatingGround3
Instância classe FloatinGround3
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oWindow, nTop, nLeft, nHeight, nWidth) Class FloatingGround3
    _Super:New(oWindow, nTop, nLeft, /*height*/,/*width*/,3)
Return

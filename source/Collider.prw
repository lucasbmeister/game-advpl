#include "totvs.ch"

#DEFINE X_POS 1
#DEFINE Y_POS 2
#DEFINE HEIGHT 3
#DEFINE WIDTH 4
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class Collider

    Data nHeight
    Data nWidth

    Method New() Constructor
    Method GetTruePosition()

EndClass

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(nHeight, nWidth) Class Collider
    ::nHeight := nHeight
    ::nWidth := nWidth
Return Self

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method GetTruePosition(aDimensions) Class Collider

    Local nMarginX as numeric
    Local nMarginY as numeric

    nMarginX := (aDimensions[WIDTH] - ::nWidth) / 2
    nMarginY := (aDimensions[HEIGHT] - ::nHeight) / 2

Return {aDimensions[X_POS] + nMarginX, aDimensions[Y_POS] + nMarginY, aDimensions[HEIGHT] - nMarginY, aDimensions[WIDTH] - nMarginX}



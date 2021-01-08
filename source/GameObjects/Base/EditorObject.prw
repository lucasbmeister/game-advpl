#include "totvs.ch"

/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Class EditorObject From LongNameClass

    Data oObject
    Data nOriginalTop
    Data nOriginalLeft
    Data nOriginalHeight
    Data nOriginalWidth

    Data nCurrentTop
    Data nCurrentLeft
    Data nCurrentHeight
    Data nCurrentWidth

    Method New() Constructor
    Method MoveObjectUp()
    Method MoveObjectLeft()
    Method MoveObjectDown()
    Method MoveObjectRight()

EndClass
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method New(oObject) Class EditorObject
    ::oObject := oObject
Return Self
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveObjectUp() Class EditorObject
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveObjectLeft() Class EditorObject
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveObjectDown() Class EditorObject
Return
/*
{Protheus.doc} function
description
@author  author
@since   date
@version version
*/
Method MoveObjectRight() Class EditorObject
Return

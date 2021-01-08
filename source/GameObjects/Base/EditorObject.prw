#include "totvs.ch"

/*
{Protheus.doc} Class EditorObject
Classe para ser utilizada somente no editor e é utilizada para
serializar e deserializar arquivos de configuração de cenas salvos
em disco no formato JSON.
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
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
{Protheus.doc} Method New(oObject)
Instância classe EditorObject
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method New(oObject) Class EditorObject
    ::oObject := oObject
Return Self

/*
{Protheus.doc} Method MoveObjectUp()
Move objeto para cima
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveObjectUp() Class EditorObject
Return

/*
{Protheus.doc} Method MoveObjectLeft()
Move objeto para esquerda
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveObjectLeft() Class EditorObject
Return

/*
{Protheus.doc} Method MoveObjectDown()
Move objeto para baixo
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveObjectDown() Class EditorObject
Return

/*
{Protheus.doc} Method MoveObjectRight()
Move objeto para direita
@author  Lucas Briesemeister
@since   01/2021
@version 12.1.27
*/
Method MoveObjectRight() Class EditorObject
Return

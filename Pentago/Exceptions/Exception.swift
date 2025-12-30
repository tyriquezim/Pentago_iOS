//
//  Error.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//

enum GeneralException: Error
{
    case IllegalArgument(message: String)
    case IllegalState(message: String)
}

enum GameBoardException: Error
{
    case GameGridFull(message: String)
    case CellOccupied(message: String)
}

//
//  Error.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//

enum Exception: Error
{
    case IllegalArgument(message: String)
    case IllegalState(message: String)
}

//
//  CombineFormErrorStrategy.swift
//  
//
//  Created by Josseh Blanco on 10/2/22.
//

import Foundation

public enum CombineFormErrorStrategy {
    case append
    case highestPriority
    case override(message: String)
}

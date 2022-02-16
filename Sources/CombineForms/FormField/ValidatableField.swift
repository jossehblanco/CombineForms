//
//  ValidatableField.swift
//
//
//  Created by Josseh Blanco on 10/2/22.
//

import Foundation

public protocol ValidatableField {
    var configuration: CombineFormFieldConfiguration { get set }
    var error: String { get set }
    var type: CombineFormFieldType { get set }
    func validate()
}

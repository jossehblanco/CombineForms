//
//  CombineForm.swift
//  
//
//  Created by Josseh Blanco on 9/2/22.
//

import Combine
import Foundation
import SwiftUI

public protocol CombineFormValidating: AnyObservableObject {
    var formValid: Bool { get set }
    var formErrors: String { get set }
    var fields: [CombineFormField] { get set }
    var cancellables: Set<AnyCancellable> { get set }
    func activateForm()
    func generateErrorMessage()
    func validate()
}

extension CombineFormValidating {
    public func activateForm() {
        fields.forEach { field in
            field.form = self
            field.objectWillChange
                .sink { [weak self] in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    }
    
    public func validate() {
        formValid = fields.map { $0.isValid }.allSatisfy { $0 }
        if !formValid {
            generateErrorMessage()
        } else {
            formErrors = ""
        }
    }
    
    public func generateErrorMessage() {
        let errors: [String] = fields.compactMap { field in
            let fieldErrors = field.errors.joined(separator: ", ")
            if !fieldErrors.isEmpty {
                return "\(field.label) - " + fieldErrors
            } else {
                return nil
            }
        }
        var errorMessage = ""
        errors.forEach {
            errorMessage.append(contentsOf: "\($0)\n")
        }
        formErrors = errorMessage
    }
}

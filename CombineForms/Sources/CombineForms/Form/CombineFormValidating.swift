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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.formValid = self.fields.map { $0.isValid }.allSatisfy { $0 }
            if !self.formValid {
                self.generateErrorMessage()
            } else {
                self.formErrors = ""
            }
        }
    }
    
    public func generateErrorMessage() {
        let errors: [String] = fields.compactMap { field in
            let fieldErrors = field.error
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

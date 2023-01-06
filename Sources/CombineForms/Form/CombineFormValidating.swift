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
    /// Property that determines if a form is valid or not
    var formValid: Bool { get set }
    /// A formatted list of all the errors found in the form's fields
    var formErrors: String { get set }
    /// Separator string for the form errors string. Format: <Field label> <Separator> <field error message>
    var separatorString: String { get }
    /// Array of CombineFormField objects.
    var fields: [CombineFormField] { get set }
    var cancellables: Set<AnyCancellable> { get set }
    /// Used for activating the form by making sure each of the fields contained in this array trigger the parent object's objectWillChange event.
    /// You should not change the function's default implementation.
    /// The fields array must contain all of the form fields for the validation to work.
    func activateForm()
    /// Generates a formatted string that contains all the error messages found in each of the form's fields.
    func generateErrorMessage()
    /// Validates if the form is valid
    func validate()
    /// Validates fields that come pre-filled before the first validation
    func validatePrePopulatedFields()
}

// MARK: - Default Implementations
extension CombineFormValidating {
    
    public var separatorString: String {
        return ": "
    }
    
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
                return "\(field.fieldName)\(separatorString)" + fieldErrors
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
    
    public func validatePrePopulatedFields() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.fields.forEach { field in
                if !field.isValid {
                    field.firstTimeEmpty = false
                    field.validate()
                }
            }
        }
    }
}

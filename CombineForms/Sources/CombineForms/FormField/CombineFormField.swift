//
//  CombineFormField.swift
//  
//
//  Created by Josseh Blanco on 10/2/22.
//

import Combine
import Foundation
import SwiftUI

@propertyWrapper
public class CombineFormField: ValidatableField, ObservableObject, Hashable {

    @Published public var value: String
    @Published public var isValid = false
    @Published public var error: String = ""
    @Published public var brokenRules: [CombineFormFieldRule] = []
    @Published public var firstTimeEmpty = true
    
    lazy public var binding: Binding<String> = .init(get: { [weak self] in
        self?.value ?? ""
    }, set: { [weak self] text in
        guard let self = self else { return }
        self.value = text
    })
    
    public var publisher: Published<String>.Publisher {
        $value
    }
    
    public var projectedValue: CombineFormField {
        self
    }
    
    public var wrappedValue: String {
        get {
            value
        }
        set {
            value = newValue
        }
    }
    
    public var requirementText: String {
        configuration.placeholder
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var validator: FieldValidating
    public var configuration: CombineFormFieldConfiguration
    public var type: CombineFormFieldType
    public var form: CombineFormValidating?
    public var label: String
    
    // MARK: - Initializer
    public init(wrappedValue value: String, configuration: CombineFormFieldConfiguration, label: String, type: CombineFormFieldType = .text, validator: FieldValidating = .defaultValidator()) {
        self.value = value
        self.configuration = configuration
        self.label = label
        self.type = type
        self.validator = validator
        configure()
    }
    
    public init(initialValue value: String, configuration: CombineFormFieldConfiguration, label: String, type: CombineFormFieldType = .text, validator: FieldValidating = .defaultValidator()) {
        self.value = value
        self.configuration = configuration
        self.label = label
        self.type = type
        self.validator = validator
        configure()
    }
    
    // MARK: - Hashable Implementation
    public static func == (lhs: CombineFormField, rhs: CombineFormField) -> Bool {
        lhs.label == rhs.label
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(label)
    }
    
    // MARK: - Public Methods    
    public func validate() {
        error = ""
        if firstTimeEmpty && !value.isEmpty {
            firstTimeEmpty = false
        }
        let validationResults = validator.validate(rules: configuration.rules, text: value)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.brokenRules = validationResults.brokenRules
            self.isValid = validationResults.isValid
            if !self.firstTimeEmpty, !self.isValid {
                self.error = self.validator.generateError(brokenRules: validationResults.brokenRules)
            }
        }
        form?.validate()
    }
    
    // MARK: - Private Methods
    private func configure() {
        $value
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.validate()
                self.value = self.configuration.transform(text: self.value)
            }
            .store(in: &cancellables)
    }
}

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
    @Published public var errors: [String] = []
    @Published public var options: [String] = []
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
    private var errorStrategy: CombineFormErrorStrategy
    public var configuration: CombineFormFieldConfiguration
    public var type: CombineFormFieldType
    public var form: CombineFormValidating?
    public var pickerConfiguration: ValidatableTextPickerConfiguration?
    public var label: String
    
    // MARK: - Initializer
    public init(wrappedValue value: String, configuration: CombineFormFieldConfiguration, label: String, type: CombineFormFieldType = .text, options: [String] = [], pickerConfiguration: ValidatableTextPickerConfiguration? = nil, errorStrategy: CombineFormErrorStrategy = .append) {
        self.value = value
        self.configuration = configuration
        self.label = label
        self.type = type
        self.pickerConfiguration = pickerConfiguration
        self.options = options
        self.errorStrategy = errorStrategy
        configure()
    }
    
    public init(initialValue value: String, configuration: CombineFormFieldConfiguration, label: String, type: CombineFormFieldType = .text, options: [String] = [], pickerConfiguration: ValidatableTextPickerConfiguration? = nil, errorStrategy: CombineFormErrorStrategy = .append) {
        self.value = value
        self.configuration = configuration
        self.label = label
        self.type = type
        self.pickerConfiguration = pickerConfiguration
        self.options = options
        self.errorStrategy = errorStrategy
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
        if firstTimeEmpty && !value.isEmpty {
            firstTimeEmpty = false
        }
        var results: [Bool] = []
        errors = []
        configuration
            .rules.forEach { rule in
                let ruleSatisfied = rule.validate(text: value)
                results.append(ruleSatisfied)
                if !ruleSatisfied && !firstTimeEmpty {
                    errors.append(rule.notValidMessage)
                }
            }
        isValid = results.allSatisfy { $0 }
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

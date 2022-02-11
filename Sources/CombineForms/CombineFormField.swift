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

    @Published var value: String
    @Published var isValid = false
    @Published var errors: [String] = []
    @Published var options: [String] = []
    @Published var firstTimeEmpty = true
    
    lazy var binding: Binding<String> = .init(get: { [weak self] in
        self?.value ?? ""
    }, set: { [weak self] text in
        guard let self = self else { return }
        self.value = text
    })
    
    var publisher: Published<String>.Publisher {
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
    
    var requirementText: String {
        configuration.placeholder
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    internal var configuration: CombineFormFieldConfiguration
    var type: CombineFormFieldType
    var form: CombineFormValidating?
    var pickerConfiguration: ValidatableTextPickerConfiguration?
    var label: String
    
    // MARK: - Initializer
    init(wrappedValue value: String, configuration: CombineFormFieldConfiguration, label: String, type: CombineFormFieldType = .text, options: [String] = [], pickerConfiguration: ValidatableTextPickerConfiguration? = nil) {
        self.value = value
        self.configuration = configuration
        self.label = label
        self.type = type
        self.pickerConfiguration = pickerConfiguration
        self.options = options
        configure()
    }
    
    init(initialValue value: String, configuration: CombineFormFieldConfiguration, label: String, type: CombineFormFieldType = .text, options: [String] = [], pickerConfiguration: ValidatableTextPickerConfiguration? = nil) {
        self.value = value
        self.configuration = configuration
        self.label = label
        self.type = type
        self.pickerConfiguration = pickerConfiguration
        self.options = options
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
    func validate() {
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

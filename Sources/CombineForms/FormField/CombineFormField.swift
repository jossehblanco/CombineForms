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
    
    /// The field's string value
    @Published public var value: String
    /// Defines if a field is valid or not
    @Published public var isValid = false
    /// The field's current error message
    @Published public var error: String = ""
    /// The list of the rules that are currently broken
    @Published public var brokenRules: [CombineFormFieldRule] = []
    /// Defines if the error message should be empty the first time the field is validated
    @Published public var firstTimeEmpty = true
    /// The field's name
    @Published public var fieldName: String
    
    // MARK: - Property Wrapper implementation
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
    
    /// A sring that identifies the requirements for the field. Examples: Optional, Required, etc.
    public var requirementText: String {
        configuration.requirementLabel
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    /// The field's validator
    private var validator: FieldValidating
    /// The field's current label. It can be changed by setting the label property to another string.
    private var currentLabel: String = ""
    /// Defines if the field's requirementText property should be added to the field's label
    private var showRequirement: Bool
    /// Specifies a debounce time to be used each time the field's value property emits a new string
    private var debounceTime: RunLoop.SchedulerTimeType.Stride
    /// The field's configuration parameters
    public var configuration: CombineFormFieldConfiguration
    /// The field's type. Possible values: text, picker and datePicker
    public var type: CombineFormFieldType
    /// A weak reference to the field's form
    public var form: CombineFormValidating?
    /// Computed property that returns the field's formatted label
    public var label: String {
        set {
            currentLabel = showRequirement ? "\(newValue) (\(configuration.requirementLabel.lowercased()))" :  newValue
        }
        get {
            currentLabel
        }
    }
    
    // MARK: - Initializer
    public init(wrappedValue value: String, configuration: CombineFormFieldConfiguration, label: String, type: CombineFormFieldType = .text, validator: FieldValidating = .defaultValidator(), showRequirement: Bool = false, debounceTime: RunLoop.SchedulerTimeType.Stride = 0.00) {
        self.value = value
        self.configuration = configuration
        self.type = type
        self.validator = validator
        self.showRequirement = showRequirement
        self.debounceTime = debounceTime
        self.fieldName = label
        self.label = label
        configure()
    }
    
    public init(initialValue value: String, configuration: CombineFormFieldConfiguration, label: String, type: CombineFormFieldType = .text, validator: FieldValidating = .defaultValidator(), showRequirement: Bool = false, debounceTime: RunLoop.SchedulerTimeType.Stride = 0.00) {
        self.value = value
        self.configuration = configuration
        self.type = type
        self.validator = validator
        self.showRequirement = showRequirement
        self.debounceTime = debounceTime
        self.fieldName = label
        self.label = label
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.error = ""
            let validationResults = self.validator.validate(rules: self.configuration.rules, text: self.value)
            self.isValid = validationResults.isValid
            if self.firstTimeEmpty && !self.value.isEmpty {
                self.firstTimeEmpty = false
            }
            self.brokenRules = validationResults.brokenRules
            if !self.firstTimeEmpty, !self.isValid {
                self.error = self.validator.generateError(brokenRules: validationResults.brokenRules)
            }
            self.form?.validate()
        }
    }
    
    /// Replaces the field's current configuration, and re-validates it according to its new rules
    public func replaceCurrentConfiguration(with newConfiguration: CombineFormFieldConfiguration) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        self.configuration = newConfiguration
        configure()
    }
    
    // MARK: - Private Methods
    private func configure() {
        $value
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .debounce(for: debounceTime, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.validate()
                self.value = self.configuration.transform(text: self.value)
            }
            .store(in: &cancellables)
    }
}

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
        configuration.requirementLabel
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var validator: FieldValidating
    private var currentLabel: String = ""
    private var showRequirement: Bool
    private var debounceTime: RunLoop.SchedulerTimeType.Stride
    public var configuration: CombineFormFieldConfiguration
    public var type: CombineFormFieldType
    public var form: CombineFormValidating?
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

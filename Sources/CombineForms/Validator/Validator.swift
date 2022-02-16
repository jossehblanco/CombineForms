//
//  File.swift
//  
//
//  Created by Josseh Blanco on 14/2/22.
//

import Foundation

public typealias ValidationResult = (isValid: Bool, brokenRules: [CombineFormFieldRule])

public protocol FieldValidating {
    var errorStrategy: CombineFormErrorStrategy { get set }
    func validate(rules: [CombineFormFieldRule], text: String) -> ValidationResult
    func generateError(brokenRules: [CombineFormFieldRule]) -> String
}

public struct DefaultValidator: FieldValidating {
    
    public var errorStrategy: CombineFormErrorStrategy
    
    public init(errorStrategy: CombineFormErrorStrategy) {
        self.errorStrategy = errorStrategy
    }
    
    public func validate(rules: [CombineFormFieldRule], text: String) -> ValidationResult {
        var brokenRules: [CombineFormFieldRule] = []
        rules.forEach { rule in
            if !rule.validate(text: text) {
                brokenRules.append(rule)
            }
        }
        let isValid = brokenRules.isEmpty
        return (isValid, brokenRules)
    }
    
    public func generateError(brokenRules: [CombineFormFieldRule]) -> String {
        switch errorStrategy {
        case .append:
            return getAllErrorMessages(brokenRules: brokenRules)
        case .highestPriority:
            return getHighestPriorityError(brokenRules: brokenRules)
        case .override(let message):
            return message
        }
    }
    
    private func getAllErrorMessages(brokenRules: [CombineFormFieldRule]) -> String {
        brokenRules
            .map { $0.notValidMessage }.joined(separator: ", ")
    }
    
    private func getHighestPriorityError(brokenRules: [CombineFormFieldRule]) -> String {
        let sorted = brokenRules.sorted { $0.priority > $1.priority }
        return sorted.first?.notValidMessage ?? ""
    }
}

public extension FieldValidating where Self == DefaultValidator {
    static func defaultValidator(errorStrategy: CombineFormErrorStrategy = .append) -> FieldValidating {
        DefaultValidator(errorStrategy: errorStrategy)
    }
}

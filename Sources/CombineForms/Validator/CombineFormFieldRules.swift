//
//  CombineFormFieldRules.swift
//  
//
//  Created by Josseh Blanco on 10/2/22.
//

import Foundation
import PostalCodeValidator

public protocol CombineFormFieldRule {
    var notValidMessage: String { get }
    var priority: Int { get }
    func validate(text: String) -> Bool
}

struct RequiredRule: CombineFormFieldRule {
    
    var notValidMessage: String {
        "Required"
    }
    var priority: Int {
        10
    }
    
    func validate(text: String) -> Bool {
        !text.isEmpty
    }
}

struct EmailRule: CombineFormFieldRule {
    
    var notValidMessage: String {
        "Must be valid."
    }
    var priority: Int {
        5
    }
    
    func validate(text: String) -> Bool {
        text.isValidEmail()
    }
}

struct DateRule: CombineFormFieldRule {
    
    var notValidMessage: String {
        "The age must be between 21 and 155 years old."
    }
    var priority: Int {
        5
    }
    
    func validate(text: String) -> Bool {
        guard let date = text.toDate() else { return false }
        return date.age >= 21 && date.age <= 115
    }
}

struct PostalCodeRule: CombineFormFieldRule {
    
    var notValidMessage: String {
        "Must be valid."
    }
    var priority: Int {
        5
    }
    
    func validate(text: String) -> Bool {
        guard let usa = PostalCodeValidator(regionCode: "US"), let canada = PostalCodeValidator(regionCode: "CA") else { return false }
        return usa.validate(postalCode: text) || canada.validate(postalCode: text)
    }
}

struct OptionalRule: CombineFormFieldRule {
    
    var notValidMessage: String {
        ""
    }
    var priority: Int {
        0
    }
    
    func validate(text: String) -> Bool {
        true
    }
}

struct PhoneNumberRule: CombineFormFieldRule {
    
    var notValidMessage: String {
        "Must be valid."
    }
    var priority: Int {
        5
    }
    
    func validate(text: String) -> Bool {
        text.isValidPhoneNumber()
    }
}

extension CombineFormFieldRule where Self == RequiredRule {
    static var required:  some CombineFormFieldRule {
        RequiredRule()
    }
}

extension CombineFormFieldRule where Self == EmailRule {
    static var email:  some CombineFormFieldRule {
        EmailRule()
    }
}

extension CombineFormFieldRule where Self == DateRule {
    static var customerAge:  some CombineFormFieldRule {
        DateRule()
    }
}

extension CombineFormFieldRule where Self == PostalCodeRule {
    static var postalcode:  some CombineFormFieldRule {
        PostalCodeRule()
    }
}

extension CombineFormFieldRule where Self == OptionalRule {
    static var optional:  some CombineFormFieldRule {
        OptionalRule()
    }
}

extension CombineFormFieldRule where Self == PhoneNumberRule {
    static var phoneNumber: some CombineFormFieldRule {
        PhoneNumberRule()
    }
}

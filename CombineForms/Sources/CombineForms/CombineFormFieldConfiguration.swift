//
//  CombineFormFieldConfiguration.swift
//  
//
//  Created by Josseh Blanco on 9/2/22.
//

import Foundation
import UIKit

public protocol CombineFormFieldConfiguration {
    var rules: [CombineFormFieldRule] { get }
    var keyboardType: UIKeyboardType { get }
    var placeholder: String { get }
    func transform(text: String) -> String
}

public struct DateField: CombineFormFieldConfiguration {
    
    let required: CombineFormFieldRule = .required
    let customerAge: CombineFormFieldRule = .customerAge
    
    public var rules: [CombineFormFieldRule] {
        [required, customerAge]
    }
    
    public var keyboardType: UIKeyboardType {
        .default
    }
}

public struct PhoneField: CombineFormFieldConfiguration {
    
    let required: CombineFormFieldRule = .required
    let phoneNumber: CombineFormFieldRule = .phoneNumber
    
    public var rules: [CombineFormFieldRule] {
        [required, phoneNumber]
    }
    
    public var keyboardType: UIKeyboardType {
        .numberPad
    }
    
    public func transform(text: String) -> String {
        text.toPhoneNumber()
    }
}

public struct NonEmptyField: CombineFormFieldConfiguration {
    
    public var rules: [CombineFormFieldRule] {
        [.required]
    }
    
    public var keyboardType: UIKeyboardType {
        .default
    }
}

public struct OptionalField: CombineFormFieldConfiguration {
    
    public var rules: [CombineFormFieldRule] {
        [.optional]
    }
    
    public var keyboardType: UIKeyboardType {
        .default
    }
    
    public var placeholder: String {
        "Optional"
    }
}

public struct EmailField: CombineFormFieldConfiguration {
    
    let required: CombineFormFieldRule = .required
    let email: CombineFormFieldRule = .email
    public var rules: [CombineFormFieldRule] {
        [required, email]
    }
    
    public var keyboardType: UIKeyboardType {
        .emailAddress
    }
}

public struct PostalCodeField: CombineFormFieldConfiguration {
    
    let required: CombineFormFieldRule = .required
    let postalCode: CombineFormFieldRule = .postalcode
    
    public var rules: [CombineFormFieldRule] {
        [required, postalCode]
    }
    
    public var keyboardType: UIKeyboardType {
        .namePhonePad
    }
}

public extension CombineFormFieldConfiguration {
    var placeholder: String {
        "Required"
    }
    
    func transform(text: String) -> String {
        text
    }
}

public extension CombineFormFieldConfiguration where Self == DateField {
    static var date: some CombineFormFieldConfiguration {
        DateField()
    }
}

public extension CombineFormFieldConfiguration where Self == PhoneField {
    static var phoneNumber: some CombineFormFieldConfiguration {
        PhoneField()
    }
}

public extension CombineFormFieldConfiguration where Self == NonEmptyField {
    static var nonEmpty: some CombineFormFieldConfiguration {
        NonEmptyField()
    }
}

public extension CombineFormFieldConfiguration where Self == OptionalField {
    static var optional: some CombineFormFieldConfiguration {
        OptionalField()
    }
}

public extension CombineFormFieldConfiguration where Self == EmailField {
    static var email: some CombineFormFieldConfiguration {
        EmailField()
    }
}

public extension CombineFormFieldConfiguration where Self == PostalCodeField {
    static var postalCode: some CombineFormFieldConfiguration {
        PostalCodeField()
    }
}

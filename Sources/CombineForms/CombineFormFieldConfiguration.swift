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

struct DateField: CombineFormFieldConfiguration {
    
    let required: CombineFormFieldRule = .required
    let customerAge: CombineFormFieldRule = .customerAge
    
     var rules: [CombineFormFieldRule] {
        [required, customerAge]
    }
    
     var keyboardType: UIKeyboardType {
        .default
    }
}

struct PhoneField: CombineFormFieldConfiguration {
    
    let required: CombineFormFieldRule = .required
    let phoneNumber: CombineFormFieldRule = .phoneNumber
    
     var rules: [CombineFormFieldRule] {
        [required, phoneNumber]
    }
    
     var keyboardType: UIKeyboardType {
        .numberPad
    }
    
     func transform(text: String) -> String {
        text.toPhoneNumber()
    }
}

struct NonEmptyField: CombineFormFieldConfiguration {
    
     var rules: [CombineFormFieldRule] {
        [.required]
    }
    
     var keyboardType: UIKeyboardType {
        .default
    }
}

struct OptionalField: CombineFormFieldConfiguration {
    
     var rules: [CombineFormFieldRule] {
        [.optional]
    }
    
     var keyboardType: UIKeyboardType {
        .default
    }
    
    var placeholder: String {
        "Optional"
    }
}

struct EmailField: CombineFormFieldConfiguration {
    
    let required: CombineFormFieldRule = .required
    let email: CombineFormFieldRule = .email
     var rules: [CombineFormFieldRule] {
        [required, email]
    }
    
     var keyboardType: UIKeyboardType {
        .emailAddress
    }
}

struct PostalCodeField: CombineFormFieldConfiguration {
    
    let required: CombineFormFieldRule = .required
    let postalCode: CombineFormFieldRule = .postalcode
    
     var rules: [CombineFormFieldRule] {
        [required, postalCode]
    }
    
     var keyboardType: UIKeyboardType {
        .namePhonePad
    }
}

extension CombineFormFieldConfiguration {
    var placeholder: String {
        "Required"
    }
    func transform(text: String) -> String {
        text
    }
}

extension CombineFormFieldConfiguration where Self == DateField {
    static var date: some CombineFormFieldConfiguration {
        DateField()
    }
}

extension CombineFormFieldConfiguration where Self == PhoneField {
    static var phoneNumber: some CombineFormFieldConfiguration {
        PhoneField()
    }
}

extension CombineFormFieldConfiguration where Self == NonEmptyField {
    static var nonEmpty: some CombineFormFieldConfiguration {
        NonEmptyField()
    }
}

extension CombineFormFieldConfiguration where Self == OptionalField {
    static var optional: some CombineFormFieldConfiguration {
        OptionalField()
    }
}

extension CombineFormFieldConfiguration where Self == EmailField {
    static var email: some CombineFormFieldConfiguration {
        EmailField()
    }
}

extension CombineFormFieldConfiguration where Self == PostalCodeField {
    static var postalCode: some CombineFormFieldConfiguration {
        PostalCodeField()
    }
}

//
//  ValidatableTextPickerConfiguration.swift
//  
//
//  Created by Josseh Blanco on 10/2/22.
//

import Foundation

protocol ValidatableTextPickerConfiguration {
    var allowsCustomListObjects: Bool { get }
    
    var allowsListSearch: Bool { get }
}

struct DefaultPicker: ValidatableTextPickerConfiguration {
    var allowsCustomListObjects: Bool {
        false
    }
    
    var allowsListSearch: Bool {
        false
    }
}

struct SearchablePicker: ValidatableTextPickerConfiguration {
    var allowsCustomListObjects: Bool {
        false
    }
    
    var allowsListSearch: Bool {
        true
    }
}

struct CustomizablePicker: ValidatableTextPickerConfiguration {
    var allowsCustomListObjects: Bool {
        true
    }
    
    var allowsListSearch: Bool {
        true
    }
}

struct CompletePicker: ValidatableTextPickerConfiguration {
    var allowsCustomListObjects: Bool {
        true
    }
    
    var allowsListSearch: Bool {
        true
    }
}

extension ValidatableTextPickerConfiguration where Self == DefaultPicker {
    static var standard: DefaultPicker {
        DefaultPicker()
    }
}

extension ValidatableTextPickerConfiguration where Self == SearchablePicker {
    static var searchable: SearchablePicker {
        SearchablePicker()
    }
}

extension ValidatableTextPickerConfiguration where Self == CustomizablePicker {
    static var customizable: CustomizablePicker {
        CustomizablePicker()
    }
}

extension ValidatableTextPickerConfiguration where Self == CompletePicker {
    static var complete: CompletePicker {
        CompletePicker()
    }
}


//
//  ValidatableTextPickerConfiguration.swift
//  
//
//  Created by Josseh Blanco on 10/2/22.
//

import Foundation

public protocol ValidatableTextPickerConfiguration {
    var allowsCustomListObjects: Bool { get }
    
    var allowsListSearch: Bool { get }
}

public struct DefaultPicker: ValidatableTextPickerConfiguration {
    public var allowsCustomListObjects: Bool {
        false
    }
    
    public var allowsListSearch: Bool {
        false
    }
}

public struct SearchablePicker: ValidatableTextPickerConfiguration {
    public var allowsCustomListObjects: Bool {
        false
    }
    
    public var allowsListSearch: Bool {
        true
    }
}

public struct CustomizablePicker: ValidatableTextPickerConfiguration {
    public var allowsCustomListObjects: Bool {
        true
    }
    
    public var allowsListSearch: Bool {
        true
    }
}

public struct CompletePicker: ValidatableTextPickerConfiguration {
    public var allowsCustomListObjects: Bool {
        true
    }
    
    public var allowsListSearch: Bool {
        true
    }
}

public extension ValidatableTextPickerConfiguration where Self == DefaultPicker {
    static var standard: DefaultPicker {
        DefaultPicker()
    }
}

public extension ValidatableTextPickerConfiguration where Self == SearchablePicker {
    static var searchable: SearchablePicker {
        SearchablePicker()
    }
}

public extension ValidatableTextPickerConfiguration where Self == CustomizablePicker {
    static var customizable: CustomizablePicker {
        CustomizablePicker()
    }
}

public extension ValidatableTextPickerConfiguration where Self == CompletePicker {
    static var complete: CompletePicker {
        CompletePicker()
    }
}


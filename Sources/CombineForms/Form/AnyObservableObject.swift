//
//  AnyObservableObject.swift
//  
//
//  Created by Josseh Blanco on 10/2/22.
//

import Combine
import Foundation

public protocol AnyObservableObject: AnyObject {
    var objectWillChange: ObservableObjectPublisher { get }
}

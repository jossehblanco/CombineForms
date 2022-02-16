//
//  File.swift
//  
//
//  Created by Josseh Blanco on 11/2/22.
//

import Foundation

extension Date {
    var age: Int {
        Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}

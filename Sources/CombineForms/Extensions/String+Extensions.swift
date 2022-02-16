//
//  String+Extensions.swift
//  
//
//  Created by Josseh Blanco on 11/2/22.
//
import Foundation
import PhoneNumberKit

extension String {
    
    var digitString: String { filter { ("0"..."9").contains($0) } }
    var firstCharacterCapitalized: String { prefix(1).capitalized + dropFirst() }
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        Data(self.utf8).base64EncodedString()
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
    
    func isValidZIP() -> Bool {
        let postalcodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
        let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
        return pinPredicate.evaluate(with: self)
    }
    
    public func toPhoneNumber() -> String {
        let value = self.filter { "1234567890".contains($0) }
        if value.count >= 10 {
            let parseValue = String(value.prefix(10))
            guard let phoneNumberParse = try? Constant.shared.phoneNumberKit.parse(parseValue, withRegion: "US", ignoreType: true) else {
                guard let phoneNumberParse = try? Constant.shared.phoneNumberKit.parse(value, withRegion: "US", ignoreType: true) else {
                    return value
                }
                return Constant.shared.phoneNumberKit.format(phoneNumberParse, toType: .national)
            }
            return Constant.shared.phoneNumberKit.format(phoneNumberParse, toType: .national)
        } else {
            return value
        }
    }
    
    func isValidPhoneNumber() -> Bool {
        let value = self
        let phoneNumberParse = try? Constant.shared.phoneNumberKit.parse(value, withRegion: "US", ignoreType: true)
        return phoneNumberParse != nil
    }
    
    func toDate(format: String = "MM/dd/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func iso8601ToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)
    }
}

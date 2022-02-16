//
//  FormViewModel.swift
//  CombineFormsExample
//
//  Created by Josseh Blanco on 14/2/22.
//

import Foundation
import Combine
import CombineForms

class FormViewModel: ObservableObject, CombineFormValidating {
    
    @Published var formValid: Bool = true
    @Published var formErrors: String = ""
    
    @CombineFormField(configuration: .nonEmpty, label: "Username", type: .text)
    var username = ""
    
    @CombineFormField(configuration: .email, label: "Email", type: .text, validator: DefaultValidator(errorStrategy: .highestPriority))
    var email = ""
    
    @CombineFormField(configuration: .nonEmpty, label: "Full Name", type: .text, validator: DefaultValidator(errorStrategy: .override(message: "This error message has been overriden.")))
    
    var fullName = ""
    
    lazy var fields: [CombineFormField] = [$username, $email, $fullName]
    
    var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        activateForm()
    }
}

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
    
    @CombineFormField(
        configuration: .nonEmpty,
        label: "Username",
        type: .text
    )
    var username = "asdsada"
    
    @CombineFormField(
        configuration: .email,
        label: "Email",
        type: .text,
        validator: DefaultValidator(errorStrategy: .highestPriority)
    )
    var email = ""
    
    @CombineFormField(
        configuration: .nonEmpty,
        label: "Full Name",
        type: .text,
        validator: DefaultValidator(errorStrategy: .highestPriority),
        showRequirement: true,
        debounceTime: 0.5
    )
    var fullName = ""
    
    var storedConfiguration: CombineFormFieldConfiguration = .email
    
    lazy var fields: [CombineFormField] = [$username, $email, $fullName]
    
    var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        activateForm()
        validatePrePopulatedFields()
    }
    
    func testConfigurationChange() {
        $fullName.replaceCurrentConfiguration(with: .email)
    }
}

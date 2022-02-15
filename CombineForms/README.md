# CombineForms

A Form Validation library for iOS 15 and SwiftUI.

# How to Use

- Create an observable object that conforms to Combine form validating

```swift
class ViewModel: ObservableObject, CombineFormValidating {

}
```

- Add the required formValid, formErrors, fields, and cancellables properties. You can ignore the rest as there is a default implementation for those. 

```swift
class ViewModel: ObservableObject, CombineFormValidating {

    @Published var formValid: Bool = false
    @Published var formErrors: String = ""
    
    lazy var fields: [CombineFormField] = []
    
    internal var cancellables: Set<AnyCancellable> = .init()
}
```

- Use the @CombineFormField property wrapper to define any amount of fields for your form. Then, add those fields to the fields array.

```swift
class ViewModel: ObservableObject, CombineFormValidating {

    @CombineFormField(configuration: .email, label: "email")
    var email = ""
    @Published var formValid: Bool = false
    @Published var formErrors: String = ""
    
    lazy var fields: [CombineFormField] = [$email]
    
    internal var cancellables: Set<AnyCancellable> = .init()
}
```

- Call activateForm to start the form validation

```swift
class ViewModel: ObservableObject, CombineFormValidating {

    @CombineFormField(configuration: .email, label: "email")
    var email = ""
    @Published var formValid: Bool = false
    @Published var formErrors: String = ""
    
    lazy var fields: [CombineFormField] = [$email]
    
    internal var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        activateForm()
    }
}
```

- Use the field in any view you wish. You can check if the form is valid using the formValid property.
```swift
struct ContentView: View {
   @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        TextField(viewModel.$email.label, text: $viewModel.email)
            .foregroundColor(!viewModel.$name.isValid ? .red : .green)
        
        Button(action: {
            
        }, label: {
            Text("Continue!")
        })
            .disabled(!viewModel.formValid)
    }
}
```

//
//  ContentView.swift
//  CombineFormsExample
//
//  Created by Josseh Blanco on 14/2/22.
//

import SwiftUI
import CombineForms

struct ContentView: View {
    @ObservedObject var viewModel = FormViewModel()
    
    var body: some View {
        
        VStack {
            makeField(field: viewModel.$username, text: $viewModel.username)
            makeField(field: viewModel.$email, text: $viewModel.email)
            makeField(field: viewModel.$fullName, text: $viewModel.fullName)
        }
        
        Button {
            viewModel.testConfigurationChange()
        } label: {
            Text("Change full name to email")
        }
        
        Button(action: {
            
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(!viewModel.formValid ? .gray : .blue)
                    .frame(width: 120, height: 40)
                Text("Submit")
                    .foregroundColor(!viewModel.formValid ? .black : .white)
            }
        })
            .disabled(!viewModel.formValid)
        
        VStack {
            Text(viewModel.formErrors)
                .foregroundColor(.red)
        }
        .padding()
    }
    
    @ViewBuilder func makeField(field: CombineFormField, text: Binding<String>) -> some View {
        HStack(spacing: 4) {

            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(field.isValid ? .green : .red)
            
            TextField(field.label, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.all, 20)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

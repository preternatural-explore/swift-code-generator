//
//  ContentView.swift
//  SwiftCodeGenerator
//
//  Created by Natasha Murashev on 8/22/24.
//

import SwiftUI
import HighlightSwift
import SwiftUIX

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var isValidQuestion: Bool = false
    @State private var isChecking: Bool = false
    @State private var showStatus: Bool = false
    @State private var errorMessage: String? = nil
    
    @State public var highlight = Highlight()
    @State private var generatedCode: String? = nil
    @State public var codeText: AttributedString? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerView
                instructionsView
                userInputView
                generateCodeButton
                showStatusView
                errorView
                generatedCodeView
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        Text("Swift Code Generator")
            .font(.title)
            .fontWeight(.bold)
    }
    
    @ViewBuilder
    private var instructionsView: some View {
        Text("Enter the type of Swift code you want to generate:")
            .font(.subheadline)
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private var userInputView: some View {
        TextField("e.g., Create a button that changes color when tapped", text: $userInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
    
    @ViewBuilder
    private var generateCodeButton: some View {
        Button(action: {
            isChecking = true
            showStatus = false
            errorMessage = nil
            generatedCode = nil
            Task {
                do {
                    isValidQuestion = try await LLMManager.isValidCodeQuestion(userInput)
                    showStatus = true
                    if isValidQuestion {
                        generatedCode = try await LLMManager.generateCode(for: userInput)
                    }
                } catch {
                    errorMessage = "Error: \(String(describing: error))"
                }
                isChecking = false
            }
        }) {
            if isChecking {
                ProgressView()
            } else {
                Text("Generate Code")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .disabled(userInput.isEmpty || isChecking)
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var generatedCodeView: some View {
        if generatedCode != nil {
            VStack(alignment: .leading) {
                Text("Generated code for: \(userInput)")
                    .font(.headline)
                    codeView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
            .task {
                self.showStatus = false
            }
        }
    }
    
    @ViewBuilder
    private var codeView: some View {
        let code: String? = generatedCode
        
        TextView(codeText ?? AttributedString(code ?? ""))
            .isSelectable(true)
            .editable(false)
            .font(.custom("Menlo-Regular", size: 12, relativeTo: .body))
            .foregroundColor(.secondary)
            .scrollDisabled(true)
            .padding()
            .background(Rectangle().fill(.quinary))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .task {
                self.codeText = await syntaxHighlightedString(for: code)
            }
    }
    
    @ViewBuilder
    private var showStatusView: some View {
        if showStatus {
            Text(isValidQuestion ? "Generating code..." : "Please enter a valid Swift code generation request")
                .foregroundColor(isValidQuestion ? .green : .red)
        }
    }
    
    @ViewBuilder
    private var errorView: some View {
        if let error = errorMessage {
            Text(error)
                .foregroundColor(.red)
                .font(.footnote)
        }
    }
    
    @MainActor
    private func syntaxHighlightedString(
        for code: String?
    ) async -> AttributedString? {
        guard let code = code else {
            return nil
        }
        
        return try? await highlight.attributedText(
            code,
            language: .swift,
            colors: .dark(.stackoverflow)
        )
    }
}

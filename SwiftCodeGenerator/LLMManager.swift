//
//  LLMManager.swift
//  SwiftCodeGenerator
//
//  Created by Natasha Murashev on 8/22/24.
//

import Anthropic

struct LLMManager {
    static let client = Anthropic.Client(apiKey: "YOUR API KEY")
    static let model: Anthropic.Model = .claude_3_5_sonnet_20240620
    
    static func isValidCodeQuestion(_ question: String) async throws -> Bool {
        let systemPrompt: PromptLiteral = """
        You are an AI assistant specializing in Swift programming and iOS/macOS development. Your task is to analyze user queries and determine if they can be reasonably addressed by generating Swift code. Consider the following criteria:

        1. The query may be explicitly about Swift programming or iOS/macOS development, or it may imply these contexts without mentioning them directly.
        2. It should request the creation of code that can be implemented in Swift.
        3. The task should be specific enough to generate meaningful code.
        4. It should not ask for complete, complex applications or frameworks.
        5. The query should be relevant to mobile or desktop app development tasks that Swift can handle.
        6. If the query is ambiguous but could be interpreted as a Swift-related task, lean towards a 'true' response.

        Examples of implied Swift tasks:
        - "Create a green button" (implies SwiftUI)
        - "How do I save data locally on an iPhone?" (implies SwiftData or UserDefaults in Swift)
        - "Calculate the average of an array of numbers" (can be done in Swift)

        Respond with 'true' if the query meets these criteria and Swift code can be generated, or 'false' if it does not or cannot.
        """
        
        let userPrompt: PromptLiteral = """
        Analyze the following query, keeping in mind that Swift might be implied even if not explicitly mentioned:

        "\(question)"

        Can Swift code be generated to address this query? Respond with only 'true' or 'false'.
        """
        
        let messages: [AbstractLLM.ChatMessage] = [
            .system(systemPrompt),
            .user(userPrompt)
        ]
        
        
        let isValidCodeQuestion: String = try await client.complete(
            messages,
            parameters: nil,
            model: model,
            as: .string)
        
        switch isValidCodeQuestion.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
        case "true":
            return true
        case "false":
            return false
        default:
            print("Unexpected response: \(isValidCodeQuestion)")
            return false
        }
        
    }
    
    static func generateCode(for question: String) async throws -> String {
        
        let systemPrompt: PromptLiteral = """
        You are a Swift code generation AI. Your sole purpose is to produce Swift code in response to user requests. Adhere to these guidelines:
        1. Generate only Swift code.
        2. Ensure the code is complete, correct, and follows Swift best practices.
        3. Include necessary import statements.
        4. Use the latest Swift syntax and idioms.
        5. Optimize for clarity and efficiency.
        """
        
        let userPrompt: PromptLiteral = """
        Generate Swift code for the following task:

        \(question)
        """
        
        let assistantStart: PromptLiteral = """
        ```swift
        """
        
        let messages: [AbstractLLM.ChatMessage] = [
            .system(systemPrompt),
            .user(userPrompt),
            .assistant(assistantStart)
        ]
        
        let parameters = AbstractLLM.ChatCompletionParameters(
            tokenLimit: nil,
            temperature: nil,
            stops: ["```"],
            functions: nil)
        
        let code: String = try await client.complete(
            messages,
            parameters: parameters,
            model: model,
            as: .string)
        
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        let processedCode = trimmedCode.replacingOccurrences(of: "```swift\n", with: "")
        
        return processedCode
    }
}

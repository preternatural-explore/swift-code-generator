> [!IMPORTANT]
> Created by [Preternatural AI](https://preternatural.ai/), an exhaustive client-side AI infrastructure for Swift.<br/>
> This project and the frameworks used are presently in alpha stage of development.

# Swift Code Generator: Generate Sample Code on Demand
The Swift Code Generator is a demo app that allows users to input natural language descriptions of desired Swift functionality and receive corresponding Swift code snippets. The app demonstrates the use of a clever prompting technique: leveraging the Claude 3.5 Sonnet model, it initiates the assistant's response with a code block marker and employs a stop sequence to ensure only the relevant code is returned. This method effectively filters out explanatory text, focusing solely on the generated Swift code - a technique which can be further applied to other use-cases.
<br/><br/>
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/PreternaturalAI/AI/blob/main/LICENSE)

## Table of Contents
- [Usage](#usage)
- [Key Concepts](#key-concepts)
- [Preternatural Frameworks](#preternatural-frameworks)
- [Technical Specifications](#technical-specifications)
- [Acknowledgements](#acknowledgements)
- [License](#license)

## Usage
#### Supported Platforms
<!-- choose only the relevant platforms-->
<!-- macOS-->
<p align="left">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos-active.svg">
  <img alt="macos" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos-active.svg" height="24">
</picture>&nbsp;

<!--iPhone-->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ios.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ios-active.svg">
  <img alt="ios" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ios-active.svg" height="24">
</picture>&nbsp;

<!-- iPad-->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ipados.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ipados-active.svg">
  <img alt="ipados" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ipados-active.svg" height="24">
</picture>&nbsp;

</p>

To install and run the SwiftCodeGenerator app:
1. Download and open the project in Xcode
2. Enter your Anthropic API Key in `LLMManager`
```swift
// LLMManager.swift
static let client = Anthropic.Client(apiKey: "YOUR API KEY")
```
You can get the Anthropic key on the [Anthropic developer website](https://docs.anthropic.com/en/api/getting-started). Note that you have to set up billing and add a small amount of money for the API calls to work (this will cost you less than 1 dollar).

3. Run the project on the Mac, iPad, or iPhone
4. Type in which Swift code you would like generated. For example, here is the response of "make a green button"
   
<img width="426" alt="smartcode" src="https://github.com/user-attachments/assets/b00443cf-eaa1-4e31-924f-20b4805ca4cb">

## Key Concepts
The Swift Code Generator app is developed to demonstrate how to work with Anthropic's LLM completions API to include the start and end of the desired result output. 

## Preternatural Frameworks
The following Preternatural Frameworks were used in this project: 
- [AI](https://github.com/PreternaturalAI/AI): The definitive, open-source Swift framework for interfacing with generative AI.

## Technical Specifications
Large Language Models (LLMs) in their current form are notorious for being too verbose… For example, when Claude is asked a direct question - such as “Who was the first US president”, it gives this full response instead of the simple “George Washington” answer as expected. 

<img width="799" alt="Screenshot 2024-08-24 at 11 50 43 AM" src="https://github.com/user-attachments/assets/8247d4b0-b10d-475c-aa76-e33b4c6d28d4">

This presents a problem for us as developers. We might want to use an LLM for direct responses such as “George Washington” but instead have to work around these big long verbose responses. The Swift Code Generator is a demonstration using one strategy for generating Swift code in response to a user request.  

As seen in the screenshot - the goal is to generating ONLY SWIFT CODE and none of the verbosity around it that is usually present in Claude as seen in this response for the same query: 

<img width="1425" alt="Screenshot 2024-08-24 at 11 56 59 AM" src="https://github.com/user-attachments/assets/6aebea34-223b-4bf4-a6d3-926a82bc2173">


So how do we approach this? 

The first step is to write the system and user prompt with the basic instructions. You can check the `LLMManager` file for the full implementation: 

```swift
// LLMManager.swift

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

\(userInput)
"""
```

Although not explicitly seen in this specific Claude answer, the LLM is trained on many Markdown files. So we can image that it will easily know Markdown syntax for swift code as: 

<pre>
```swift
SWIFT CODE
```
</pre>

Some LLMs, including Claude, allow to provide the start of the assistant reply. In this case, we can prompt Claude to start the response to our user prompt with the markdown: 

```swift
let assistantStart: PromptLiteral = """
```swift
"""

let messages: [AbstractLLM.ChatMessage] = [
    .system(systemPrompt),
    .user(userPrompt),
    .assistant(assistantStart)
]
```

Now, instead of answering the user query with something like “Certainly, I can help you create a purple button in Swift. Here's a simple implementation using SwiftUI:”, it will directly start by completing the markdown, which forces Claude to write Swift code right away.

However, Claude can still keep writing explanations of the code after it finishes the Swift code. In this case, we can use a “stop sequence” “```” to tell Claude when to STOP generating anything further: 

```swift
let parameters = AbstractLLM.ChatCompletionParameters(
        tokenLimit: nil,
        temperature: nil,
        stops: ["```"], // the stop sequence is the end of the markdown "```"
        functions: nil)
```

Now Claude is forced to start its Assistant Reply with “```swift” and end generating anything after “```” - this ensures that only Swift code is generated an no verbosity around it! Note that the stop sequence itself is NOT included in the Claude reply - it is automatically stripped out. So the final response will only be: 

<pre>
```swift
SWIFT CODE
</pre>

We therefore still do have to remove the “```swift” part of the code: 

```swift
let code: String = try await client.complete(
    messages,
    parameters: parameters,
    model: model,
    as: .string)

let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
let processedCode = trimmedCode.replacingOccurrences(of: "```swift\n", with: "")
```

We can now successfully process the Swift code string as an Attributed String and display it in our app. The same technique can be used for other use-cases where the start and end point of the desired generated LLM response is known.

## Acknowledgements

ExgternalFrameworkName
- **Link**: [HighlightSwift](https://link-to-framework](https://github.com/appstefan/HighlightSwift)
- **License**: [MIT License](https://github.com/link-to-mit-license-in-project)
- **Authors**: [Stefan](https://github.com/appstefan)

## License

This package is licensed under the [MIT License](https://github.com/PreternaturalAI/AI/blob/main/LICENSE).

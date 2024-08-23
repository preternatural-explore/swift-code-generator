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
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Acknowledgements

ExgternalFrameworkName
- **Link**: [HighlightSwift](https://link-to-framework](https://github.com/appstefan/HighlightSwift)
- **License**: [MIT License](https://github.com/link-to-mit-license-in-project)
- **Authors**: [Stefan](https://github.com/appstefan)

## License

This package is licensed under the [MIT License](https://github.com/PreternaturalAI/AI/blob/main/LICENSE).

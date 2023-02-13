//
//  ChatGPT.swift
//  iFruitsRecipe
//
//  Created by Huy Ong on 2/10/23.
//

import Foundation

struct ChatGPTResponse: Decodable {
  let choices: [Choice]
  
  struct Choice: Decodable {
    let text: String
  }
}

class ChatGPT {
  static let shared = ChatGPT()
  static private let api = "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"
  private var headers: [String: String] {
    [
      "Content-Type" : "application/json",
      "Authorization" : "Bearer \(Self.api)"
    ]
  }
  private var urlRequest: URLRequest {
    let url = URL(string: "https://api.openai.com/v1/completions")!
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0)}
    return urlRequest
  }
  private let decoder = JSONDecoder()
  private let session = URLSession.shared
  
  
  init() {
    
  }
  
  func sendCompletion(_ prompt: String) async throws -> String {
    var request = urlRequest
    request.httpBody = try jsonBody(prompt)
    let (data, _) = try await session.data(for: request)
    
    do {
      let response = try decoder.decode(ChatGPTResponse.self, from: data)
      return response.choices.first?.text ?? ""
    } catch {
      throw error
    }
    
  }
  
  private func jsonBody(_ prompt: String) throws -> Data {
    let jsonBody: [String: Any] = [
      "model": "text-davinci-003",
      "temperature": 0.5,
      "max_tokens": 1024,
      "prompt": prompt
//      "stop": [
//        "\n\n\n",
//        "<|im_end|>"
//      ],
//      "stream": false
    ]
    return try JSONSerialization.data(withJSONObject: jsonBody)
  }
}

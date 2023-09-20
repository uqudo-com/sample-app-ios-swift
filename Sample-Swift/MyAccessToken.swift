//
//  MyAccessToken.swift
//  Sample-Swift
//
//  Created by NooN on 19/9/23.
//

import Foundation

let kMyAccessTokenRequestURL    = "https://auth.uqudo.io/api/oauth/token"
let kMyAccessTokenRequesMethod  = "POST"


class MyAccessToken: NSObject {
    
    
    public func requestAccessToken(completion: @escaping (String?, Error?) -> Void) {
        // Create a URL for your request
        guard let url = URL(string: kMyAccessTokenRequestURL) else {
            completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil))
            return
        }
        
        // Create an URLRequest with the URL
        var request = URLRequest(url: url)
        
        // Set the HTTP request method to POST
        request.httpMethod = kMyAccessTokenRequesMethod
        
        // Create request parameters
        let parameters: [String: String] = [
            "grant_type": "client_credentials",
            "client_id": "Provide your client ID",
            "client_secret": "Provide your client secret"
        ]
        
        // Convert the dictionary to a query string
        let queryString = parameters.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        // Set the HTTP body with the query string
        request.httpBody = queryString.data(using: .utf8)
        
        // Optionally, set HTTP headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer YourAccessToken", forHTTPHeaderField: "Authorization")
        
        // Optionally, set a timeout interval (in seconds)
        request.timeoutInterval = 70.0 // 70 seconds
        
        // Create a URLSession and data task to send the request and handle the response
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            } else if let data = data {
                if let accessToken = self.deserializeAccessTokenData(data) {
                    completion(accessToken, nil)
                } else {
                    let customError = NSError(domain: "AccessTokenDeserialization", code: 0, userInfo: nil)
                    completion(nil, customError)
                }
            }
        }
        dataTask.resume()
    }
    
    func deserializeAccessTokenData(_ data: Data) -> String? {
        // Deserialize Data to Dictionary
        do {
            if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let accessToken =  jsonDictionary["access_token"] as? String
                return accessToken;
            } else {
                print("Error deserializing JSON data")
            }
        } catch {
            print("Error deserializing JSON data: \(error)")
        }
        return nil
    }
}

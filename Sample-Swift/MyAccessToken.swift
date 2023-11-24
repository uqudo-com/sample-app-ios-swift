//
//  MyAccessToken.swift
//  Sample-Swift
//
//  Created by NooN on 19/9/23.
//

import Foundation
import Alamofire

let kMyAccessTokenRequestURL    = "https://auth.uqudo.io/api/oauth/token"


class MyAccessToken: NSObject {
    
    struct AccessTokenResponse: Decodable {
        let access_token: String
    }
    func requestAccessToken(completion: @escaping (String?, Error?) -> Void) {
        let parameters: [String: String] = ["grant_type": "client_credentials", "client_id": "Your client ID", "client_secret": "Your secreat key"]
        AF.request(kMyAccessTokenRequestURL, method: .post, parameters: parameters)
            .responseDecodable(of: AccessTokenResponse.self) { response in
                switch response.result {
                case .success(let accessTokenResponse):
                    completion(accessTokenResponse.access_token, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}

//
//  APIClient.swift
//  Rubyfull
//
//  Created by 伏貫祐樹 on 2019/12/26.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import Alamofire
import Foundation

enum APIClientError: Swift.Error {
    case responseError(Swift.Error)
    case requestError(Swift.Error)
    case unknownError
}

final class APIClient {

    func getHiraganaData(
        inputtedText: String,
        requestURI: String,
        completion: @escaping((Swift.Result<ResponseDataModel, APIClientError>) -> Void)
    ) {

        Alamofire.request(
            requestURI, // リクエスト先のURL
            method: .post,
            parameters: [
                "app_id": Constants.shared.APP_ID,
                "sentence": inputtedText,
                "output_type": "hiragana"
            ]
        ).responseData { response in

            switch response.result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(ResponseDataModel.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(.responseError(error)))
                }
            case .failure(let error):
                completion(.failure(.requestError(error)))
            }
        }
    }
}

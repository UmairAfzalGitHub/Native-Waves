//
// Copyright (c) 2021, NativeWaves
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

typealias CompletionHandler =  (Data?, NSError?) -> Void

class BaseService {

    func getRequest(_ url: String, parameters: [String: String]?, completion: @escaping CompletionHandler) {

        var components = URLComponents(string: url)

        components?.queryItems = parameters?.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let percentEncodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        components?.percentEncodedQuery = percentEncodedQuery

        guard let requestURL = components?.url else {
            DispatchQueue.main.async {
                completion(nil, NSError.createError(Strings.Error.somethingWentWrong))
            }
            return
        }

        var request = URLRequest(url: requestURL)

        // sepcifying http method
        request.httpMethod = "GET"

        // addding auth headers
        request.setValue("Bearer \(AppConfig.authToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {data, response, error in

            if let validData = data, let response = response as? HTTPURLResponse, error == nil {

                var userData :Data?
                var compliedError :NSError?

                if (200 ..< 300) ~= response.statusCode { // is statusCode 2XX
                    userData = validData

                } else {
                    let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any]

                    if let error = json?["error"] as? [String: AnyObject], let info = error["info"] as? String {
                        compliedError = NSError.createError(info)
                    }
                }

                // Main thread
                
                DispatchQueue.main.async {
                    completion(userData, compliedError)
                }

            } else {

                DispatchQueue.main.async {
                    completion(nil, error as NSError?)
                }
            }
        }.resume()
    }
}

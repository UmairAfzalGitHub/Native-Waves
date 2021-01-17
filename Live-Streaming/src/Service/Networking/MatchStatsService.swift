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

typealias MatchDataCompletionHandler =  (MatchStats?, NSError?) -> Void

class MatchStatsService: BaseService {

    // fetch match stats from api
    func getMatchStats(completion: @escaping MatchDataCompletionHandler) {
        var url = ConfigurationManager.getValue(for: Strings.Keys.baseUrl, on: "env").orEmpty
        url.append(Strings.ApiPath.getMatchStats)

        self.getRequest(url, parameters: [:]) { (data, error) in

            self.parseResponse(data: data, error: error) { (data, error) in
                completion(data, error)
            }
        }
    }

    // parse returned JSON data to specified model
    
    private func parseResponse(data: Data?, error: NSError?, completion: @escaping MatchDataCompletionHandler) {

        do {

            if let data = data {
                let decodeData = try JSONDecoder().decode(MatchStats.self, from: data)
                completion(decodeData, nil)

            } else {
                completion(nil, error)
            }
            
        } catch let error {
            completion(nil, error as NSError)
        }
    }
}

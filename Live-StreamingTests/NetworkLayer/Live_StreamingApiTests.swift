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

import XCTest
@testable import Live_Streaming

class Live_StreamingApiTests: XCTestCase {

    func testCanFetchDataFromApiWithSuccess() throws {
        // Arrange
        let errorExpectation = self.expectation(description: "Match Data")
        var matchResponse: MatchStats?
        var errorResponse: NSError?

        // Act
        var url = ConfigurationManager.getValue(for: "base-url", on: "env").orEmpty
        url.append(Strings.ApiPath.getMatchStats)
        BaseService().getRequest(url, parameters: [:]) { (data, error) in
            let decodeData = try! JSONDecoder().decode(MatchStats.self, from: data!)
            matchResponse = decodeData
            errorResponse = error
            errorExpectation.fulfill()
        }

        // Assert
        waitForExpectations(timeout: 10)
        XCTAssertNil(errorResponse)
        XCTAssertNotNil(matchResponse)
    }
}

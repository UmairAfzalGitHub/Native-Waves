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

class Live_StreamingMatchInfoModelTests: XCTestCase {

    func testCanParseMatchInfo() throws {
        // Arrange
        let json = """
        {
        "matchInfo": {

        "id": "7y6vur8eogk0fhuz9okoa54yy",
        "coverageLevel": "13",
        "date": "2020-02-17Z",
        "time": "20:00:00Z",
        "week": "26",
        "lastUpdated": "2021-01-13T17:47:28Z",
        "description": "Chelsea vs Manchester United",
        "competition": {
        "id": "2kwbbcootiqqgmrzs6o5inle5",
        "name": "Premier League",
        "competitionCode": "EPL",
        "competitionFormat": "Domestic league",
        "country": {
        "id": "1fk5l4hkqk12i7zske6mcqju6",
        "name": "England"
        }
        },
        "contestant": [
        {
        "id": "9q0arba2kbnywth8bkxlhgmdr",
        "name": "Chelsea",
        "shortName": "Chelsea",
        "officialName": "Chelsea FC",
        "code": "CHE",
        "position": "home",
        "country": {
          "id": "1fk5l4hkqk12i7zske6mcqju6",
          "name": "England"
        }
        },
        {
        "id": "6eqit8ye8aomdsrrq0hk3v7gh",
        "name": "Manchester United",
        "shortName": "Man Utd",
        "officialName": "Manchester United FC",
        "code": "MUN",
        "position": "away",
        "country": {
          "id": "1fk5l4hkqk12i7zske6mcqju6",
          "name": "England"
        }
        }
        ],
        "venue": {
        "id": "3lnmxkrbtsvdffns96nqkggeg",
        "neutral": "no",
        "longName": "Stamford Bridge",
        "shortName": "Stamford Bridge"
        }
        },
        "liveData": {
        "matchDetails": {
        "periodId": 14,
        "matchStatus": "Played",
        "winner": "away",
        "matchLengthMin": 99,
        "matchLengthSec": 17,

        },
        "goal": [
        {
        "contestantId": "6eqit8ye8aomdsrrq0hk3v7gh",
        "periodId": 1,
        "timeMin": 45,
        "timeMinSec": "44:17",
        "lastUpdated": "2020-10-12T18:51:39Z",
        "timestamp": "2020-02-17T20:44:31Z",
        "type": "G",
        "scorerId": "3ikhefktnj44ys7rqjzr5q09h",
        "scorerName": "A. Martial",
        "assistPlayerId": "e1t5rgvs2hwnldts6vn8agzc9",
        "assistPlayerName": "A. Wan-Bissaka",
        "optaEventId": "2184727223",
        "homeScore": 0,
        "awayScore": 1
        },
        {
        "contestantId": "6eqit8ye8aomdsrrq0hk3v7gh",
        "periodId": 2,
        "timeMin": 66,
        "timeMinSec": "65:10",
        "lastUpdated": "2020-04-17T10:13:32Z",
        "timestamp": "2020-02-17T21:24:36Z",
        "type": "G",
        "scorerId": "1vz038uyzmq8saskeeo0qhm8l",
        "scorerName": "H. Maguire",
        "assistPlayerId": "3vtjjrqof5z2tjj84ehadqc45",
        "assistPlayerName": "Bruno Fernandes",
        "optaEventId": "2184736297",
        "homeScore": 0,
        "awayScore": 2
        }
        ],
        "card": [
        {
        "contestantId": "9q0arba2kbnywth8bkxlhgmdr",
        "periodId": 1,
        "timeMin": 35,
        "timeMinSec": "34:53",
        "lastUpdated": "2020-02-17T20:35:14Z",
        "timestamp": "2020-02-17T20:35:07Z",
        "type": "YC",
        "playerId": "afcwu800ox2u5zx6xaiygg1qt",
        "playerName": "Willian",
        "optaEventId": "2184724949",
        "cardReason": "Simulation"
        }
        ],
        "substitute": [
        {
        "contestantId": "6eqit8ye8aomdsrrq0hk3v7gh",
        "periodId": 2,
        "timeMin": 91,
        "timeMinSec": "90:16",
        "lastUpdated": "2020-02-17T21:49:45Z",
        "timestamp": "2020-02-17T21:49:42Z",
        "playerOnId": "6wjktx17kp8g29h9gw27lwez9",
        "playerOnName": "O. Ighalo",
        "playerOffId": "3ikhefktnj44ys7rqjzr5q09h",
        "playerOffName": "A. Martial",
        "subReason": "Tactical"
        },
        {
        "contestantId": "6eqit8ye8aomdsrrq0hk3v7gh",
        "periodId": 2,
        "timeMin": 92,
        "timeMinSec": "91:30",
        "lastUpdated": "2020-05-27T02:29:19Z",
        "timestamp": "2020-02-17T21:50:56Z",
        "playerOnId": "3f3jcsa7gk6in9fskp9w5a5t5",
        "playerOnName": "Diogo Dalot",
        "playerOffId": "3vtjjrqof5z2tjj84ehadqc45",
        "playerOffName": "Bruno Fernandes",
        "subReason": "Tactical"
        }
        ]
        }
        }
        """
        // Act
        // Using bang operator intentionally, so that we can verify that we can use each object
        let jsonData = json.data(using: .utf8)!
        let sut = try! JSONDecoder().decode(MatchStats.self, from: jsonData) //sut: system under test

        // Assert
        XCTAssertNotNil(sut.matchInfo)
        XCTAssertNotNil(sut.matchInfo!.venue!.id)
        XCTAssertNotNil(sut.matchInfo!.description)
        XCTAssertNotNil(sut.matchInfo!.venue!.shortName)
        XCTAssertNotNil(sut.matchInfo!.competition!.country!.name)

        XCTAssertNotNil(sut.liveData)
        XCTAssertTrue(sut.liveData!.cards!.count > 0)
        XCTAssertTrue(sut.matchInfo!.contestants!.count > 0)
        XCTAssertTrue(sut.liveData!.substitutes!.count > 0)
    }
}

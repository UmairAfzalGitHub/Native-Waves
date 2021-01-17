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

struct Strings {

    struct Common {
        static let success = "Success"
        static let error = "Error"
        static let okay = "Ok"
    }

    struct Error {
        static let somethingWentWrong = "Something went wrong. Please try again."
        static let internetNotWorking = "Internet Connection Not Working!"
    }

    struct Keys {
        static let baseUrl = "base-url"
        static let sreamingVideoUrl = "streaming-video-url"
    }

    struct ApiPath {
        static let getMatchStats = "perform/soccerdata/fixtures/7y6vur8eogk0fhuz9okoa54yy/matchstats"
        static let videoStreaming = "https://public-content-cdn.dev.nativewaves.com/showcases-content-3f282711c78bca361531ce24d158aed4/nw_ibc_2019_490282e9e1a7d3a575eff1e9e7b8ee94/pgm/master.m3u8"
    }

    struct AVPlayer {
        static let timeControlStatus = "timeControlStatus"
    }
}

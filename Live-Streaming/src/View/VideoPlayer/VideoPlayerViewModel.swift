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

protocol VideoPlayerViewModelDelegate: BaseViewModelDelegate {
    func didLoadMatchStats()
}

enum MenuOptions: String {
    case substitutions
    case cards
}

class VideoPlayerViewModel: BaseViewModel {

    var matchStats: MatchStats?
    var selectedMenu: MenuOptions?

    weak var delegate: VideoPlayerViewModelDelegate? {
        didSet {
            super.baseDelegate = delegate
        }
    }

    func getMatchData() {
        // check network connection
        if !Reachability.isConnectedToNetwork() {
            self.delegate?.showErrorAlert(message: Strings.Error.internetNotWorking)
            return
        }

        MatchStatsService().getMatchStats { [weak self] (data, error) in
            guard let self = self else { return }

            if error != nil {
                self.delegate?.showErrorAlert(message: Strings.Error.somethingWentWrong)

            } else {
                self.matchStats = data
                self.mapTeamName()
                self.delegate?.didLoadMatchStats()
            }
        }
    }

    func mapTeamName() {
        // we are not getting team name directly in each object, so getting team name based on id and assigning values to desired objects
        matchStats?.matchInfo?.contestants?.forEach({ (contestant) in

            matchStats?.liveData?.cards?.forEach({ (card) in
                if contestant.id.orEmpty == card.contestantId.orEmpty {
                    card.teamName = contestant.officialName
                }
            })

            matchStats?.liveData?.substitutes?.forEach({ (substitute) in
                if contestant.id.orEmpty == substitute.contestantId.orEmpty {
                    substitute.teamName = contestant.officialName
                }
            })
        })
    }
}

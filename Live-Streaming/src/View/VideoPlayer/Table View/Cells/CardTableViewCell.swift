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


import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var timeAndTeamLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var playerName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(data: Card) {
        timeAndTeamLabel.text = "\(data.timeMin.orZero) \(data.teamName.orEmpty.capitalized)"
        playerName.text = data.playerName.orEmpty.capitalized
        cardView.backgroundColor = data.type.orEmpty == "YC" ? .yellow : .red
    }
}

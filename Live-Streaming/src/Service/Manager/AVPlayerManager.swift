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
import UIKit
import AVFoundation

protocol AVPlayerManagerDelegate {
    func didChangeTimeControlStatus(status: AVPlayer.TimeControlStatus?)
    func didUpdatePlayerState(progressValue: Float, duration: String)
}

class AVPlayerManager: NSObject {

    static let shared = AVPlayerManager()
    private override init() {} // so no other instance can be created of this class

    var delegate: AVPlayerManagerDelegate?
    var playerLayer = AVPlayerLayer()

    /**
     A method that configures a new AVPlayer object
     - parameter urlString: Represents the url of the video
     - parameter playerView: View that will display the player layer
     - Returns: A tuple containing error and configured AVplayer object
     */

    func configurePlayer(urlString: String, playerView: UIView) -> (error: String?, player: AVPlayer?) {

        guard let url = URL(string: urlString) else {
            return (Strings.Error.somethingWentWrong, nil)
        }
        let player = AVPlayer(url: url)

        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerView.layer.addSublayer(playerLayer)
        player.play()
        // Add observer for loading
        player.addObserver(self, forKeyPath: Strings.AVPlayer.timeControlStatus, options: [.old, .new], context: nil)

        return (nil, player)
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == Strings.AVPlayer.timeControlStatus, let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)

            if newStatus != oldStatus {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didChangeTimeControlStatus(status: newStatus)
                }
            }
        }
    }

    /**
     A method that calculates the remaining time of the video and vlue of the seekbar
     - parameter player: AVPlayer for calculation
     - Returns: A tuple containing error and configured AVplayer object
     */

    func updatePlayerState(player: AVPlayer) {
        var progressValue: Float = 0.0
        let currentTime = player.currentTime()
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        progressValue = Float(currentTimeInSeconds)

        if let currentItem = player.currentItem {
            let duration = currentItem.duration

            if (CMTIME_IS_INVALID(duration)) {
                return
            }
            let currentTime = currentItem.currentTime()
            progressValue = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))

            // Update time remaining label
            let totalTimeInSeconds = CMTimeGetSeconds(duration)
            let remainingTimeInSeconds = totalTimeInSeconds - currentTimeInSeconds

            let mins = remainingTimeInSeconds / 60
            let secs = remainingTimeInSeconds.truncatingRemainder(dividingBy: 60)
            let timeformatter = NumberFormatter()
            timeformatter.minimumIntegerDigits = 2
            timeformatter.minimumFractionDigits = 0
            timeformatter.roundingMode = .down

            guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
                return
            }

            let durationValue =  "\(minsStr):\(secsStr)"
            self.delegate?.didUpdatePlayerState(progressValue: progressValue, duration: durationValue)
        }
    }
}

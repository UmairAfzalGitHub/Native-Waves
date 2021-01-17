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
import AVFoundation

class VideoPlayerViewController: BaseViewController {

    // MARK: - IBOutlets & variables

    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightMenuStackView: UIStackView!
    @IBOutlet weak var matchInfoStackView: UIStackView!
    @IBOutlet weak var subsitutionButton: UIButton!
    @IBOutlet weak var cardsButton: UIButton!
    @IBOutlet weak var toggleMenuHeadingLabel: UILabel!
    @IBOutlet weak var toggleMenuView: UIView!
    @IBOutlet weak var matchInfoLabel: UILabel!
    @IBOutlet weak var venueInfoLabel: UILabel!

    var player: AVPlayer?
    var timeObserver: Any?

    var timer: DispatchSourceTimer?
    var viewModel = VideoPlayerViewModel()

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCustomPropertiesOnView()
        setupVideoPlayer()
        populateViewWithData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.cancel()
    }

    override func setupCustomPropertiesOnView() {
        self.setScreenOrientation(orientation: .landscapeRight)

        AVPlayerManager.shared.delegate = self

        setupTapGestures()
        viewModel.delegate = self

        // Register tableView cells
        tableView.registerCell(class: SubstituteTableViewCell.self)
        tableView.registerCell(class: CardTableViewCell.self)

        // show loader on the screen until video is loaded
        showProgress()
    }

    override func populateViewWithData() {
        // fetch data
        viewModel.getMatchData()
        fetchDataAfter(seconds: 60)
    }

    // MARK: - IBActions

    @IBAction func subsitutionButtonTapped(_ sender: Any) {
        toggleMenu(selectedMenu: .substitutions)
    }

    @IBAction func cardsButtonTapped(_ sender: Any) {
        toggleMenu(selectedMenu: .cards)
    }

    @IBAction func playPauseButtonTapped(_ sender: Any) {
        guard let player = player else { return }
        player.isPlaying ? pause(player: player) : play(player: player)
    }

    @IBAction func progressSliderValueChanged(_ sender: Any) {
        // update slider value according to time elapsed
        guard let duration = player?.currentItem?.duration else { return }
        let value = Float64(progressSlider.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        player?.seek(to: seekTime )
    }

    @IBAction func jumpForward(_ sender: UIButton) {
        // play video 10 second forward
        guard let currentTime = player?.currentTime() else { return }
        let currentTimeInSecondsPlus10 =  CMTimeGetSeconds(currentTime).advanced(by: 10)
        let seekTime = CMTime(value: CMTimeValue(currentTimeInSecondsPlus10), timescale: 1)
        player?.seek(to: seekTime)
    }

    @IBAction func jumpBackward(_ sender: UIButton) {
        // play video 10 second backwards
        guard let currentTime = player?.currentTime() else { return }
        let currentTimeInSecondsMinus10 =  CMTimeGetSeconds(currentTime).advanced(by: -10)
        let seekTime = CMTime(value: CMTimeValue(currentTimeInSecondsMinus10), timescale: 1)
        player?.seek(to: seekTime)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        player?.pause()
        player = nil
        coordinator?.pop()
    }

    // MARK; - Selectors

    @objc func didTapPlayerView() {

        if overlayView.isHidden {
            toggleControls(shouldHide: false)

            // hide overlay after 5 secods
            hideOverlayView()

        } else {
            overlayView.hide()
            toggleControls(shouldHide: true)
        }
    }

    // MARK: - Private Methods

    private func setupTapGestures() {
        // setup tap gesture
        let playerViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPlayerView))
        playerView.addGestureRecognizer(playerViewTapGesture)

        let overlayViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPlayerView))
        overlayView.addGestureRecognizer(overlayViewTapGesture)
    }

    private func fetchDataAfter(seconds: Int) {
        // Calling api after 60 seconds to get updated data
        let queue = DispatchQueue.global(qos: .background)
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: .seconds(seconds))

        timer?.setEventHandler(handler: { [weak self] in
            self?.viewModel.getMatchData()
        })
        timer?.resume()
    }

    /**
     Hides the overlay view after 5 seconds
     */
    private func hideOverlayView() {

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) { [weak self] in
            self?.toggleControls(shouldHide: true)
        }
    }

    /**
     A method that toggle between substitution and cards menu
     - parameter selectedMenu: selected menu option.
     */

    private func toggleMenu(selectedMenu: MenuOptions) {
        viewModel.selectedMenu = selectedMenu
        toggleMenuView.isHidden.toggle()
        cardsButton.isHidden = selectedMenu == .substitutions
        subsitutionButton.isHidden = selectedMenu == .cards
        toggleMenuHeadingLabel.text = selectedMenu == .substitutions ? MenuOptions.substitutions.rawValue.capitalized : MenuOptions.cards.rawValue.capitalized

        // display both buttons
        if toggleMenuView.isHidden {
            cardsButton.show()
            subsitutionButton.show()
        }

        tableView.reloadData()
    }

    /**
     Plays the AVPlayer, Updates the image of play/pause button and hides the overlay view
     - parameter player: AVPlayer to play.
     */
    private func play(player: AVPlayer) {
        player.play()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        hideOverlayView()
    }

    /**
     Pauses the AVPlayer, Updates the image of play/pause button and hides the overlay view
     - parameter player: AVPlayer to pause.
     */
    private func pause(player: AVPlayer) {
        player.pause()
        playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        hideOverlayView()
    }

    private func toggleControls(shouldHide: Bool) {
        cardsButton.show()
        toggleMenuView.hide()
        subsitutionButton.show()

        overlayView.isHidden = shouldHide
        rightMenuStackView.isHidden = !shouldHide
        matchInfoStackView.isHidden = !shouldHide
    }

    private func setupVideoPlayer() {
        let data = AVPlayerManager.shared.configurePlayer(urlString: Strings.ApiPath.videoStreaming, playerView: playerView)

        if let error = data.error {
            self.showErrorAlert(message: error)
            return
        }

        player = data.player
        let interval = CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        // updating player on main thread
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] elapsedTime in

            if let player = self?.player {
                AVPlayerManager.shared.updatePlayerState(player: player)
            }
        })
    }
}

// MARK: - UITableViewDataSource

extension VideoPlayerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if viewModel.selectedMenu == MenuOptions.cards {
            return viewModel.matchStats?.liveData?.cards?.count ?? 0
        }

        return viewModel.matchStats?.liveData?.substitutes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if viewModel.selectedMenu == MenuOptions.cards {
            let cell: CardTableViewCell = tableView.dequeReusableCell(for: indexPath)

            if let data = viewModel.matchStats?.liveData?.cards?[indexPath.row] {
                cell.configureCell(data: data)
            }
            return cell
        }

        let cell: SubstituteTableViewCell = tableView.dequeReusableCell(for: indexPath)

        if let data = viewModel.matchStats?.liveData?.substitutes?[indexPath.row] {
            cell.configureCell(data: data)
        }
        return cell
    }
}

// MARK: - VideoPlayerViewModelDelegate

extension VideoPlayerViewController: VideoPlayerViewModelDelegate {

    func didLoadMatchStats() {
        homeTeamNameLabel.text = viewModel.matchStats?.matchInfo?.contestants?.first?.code ?? "-"
        awayTeamNameLabel.text = viewModel.matchStats?.matchInfo?.contestants?.last?.code ?? "-"
        scoreLabel.text = "\(viewModel.matchStats?.liveData?.goals?.first?.homeScore ?? 0) : \(viewModel.matchStats?.liveData?.goals?.first?.awayScore ?? 0)"
        matchInfoLabel.text = "\(viewModel.matchStats?.matchInfo?.competition?.country?.name ?? "-") \(viewModel.matchStats?.matchInfo?.competition?.name ?? "-")"
        venueInfoLabel.text = "\(viewModel.matchStats?.matchInfo?.venue?.longName ?? "-") \n \(viewModel.matchStats?.matchInfo?.description ?? "")"
        tableView.reloadData()
    }
}

// MARK: - AVPlayerManagerDelegate

extension VideoPlayerViewController: AVPlayerManagerDelegate {

    func didChangeTimeControlStatus(status: AVPlayer.TimeControlStatus?) {
        (status == .playing || status == .paused) ? hideProgress() : showProgress()
    }

    func didUpdatePlayerState(progressValue: Float, duration: String) {
        progressSlider.value = progressValue
        durationLabel.text = duration
    }
}

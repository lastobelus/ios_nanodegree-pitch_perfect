//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Johnston on 13.07.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit
import AVFoundation
class PlaySoundsViewController: UIViewController {

  var audioPlayer: AVAudioPlayer!
  var receivedAudio: RecordedAudio!
  
  var restartAudio: Bool = true
  
  @IBOutlet weak var stopAudioButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    stopAudioButton.hidden = true
    
    audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error:nil)
    audioPlayer.enableRate = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  @IBAction func playSlow(sender: UIButton) {
    println("playSlow action")
    playAudioAtRate(0.5)
  }

  @IBAction func playFast(sender: UIButton) {
    println("playFast action")
    playAudioAtRate(2.0)
  }

  @IBAction func stopAudio(sender: UIButton) {
    stopAudioButton.hidden = true
    audioPlayer.stop()
  }

  private func playAudioAtRate(rate: Float) {
    audioPlayer.stop()
    audioPlayer.rate = rate
    if restartAudio {
      audioPlayer.currentTime = 0.0
    }
    audioPlayer.play()
    stopAudioButton.hidden = false
  }

}

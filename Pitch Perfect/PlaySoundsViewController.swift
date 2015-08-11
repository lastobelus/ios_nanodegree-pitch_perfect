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
  var audioEngine: AVAudioEngine!
  var audioFile: AVAudioFile!

  var receivedAudio: RecordedAudio!
  
  var restartAudio: Bool = true
  
  @IBOutlet weak var stopAudioButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    var error: NSError?

    stopAudioButton.hidden = true
    
    audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error:nil)
    audioPlayer.enableRate = true

    audioEngine = AVAudioEngine()
    audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: &error)

    if let e = error {
      println("could not load receivedAudio: \(receivedAudio.filePathURL)")
      println(e.localizedDescription)
    }

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
    println("stopAudio action")
    stopAudioButton.hidden = true
    audioPlayer.stop()
    audioEngine.stop()
  }

  @IBAction func playChipmunkAudio(sender: UIButton) {
    println("playChipmunk action")
    playAudioWithVariablePitch(1000)
  }
  
  @IBAction func playDarthVaderAudio(sender: UIButton) {
    println("playDarthVaderAudio action")
    playAudioWithVariablePitch(-1000)
  }
  
  private func playAudioWithVariablePitch(pitch: Float) {
    var error: NSError?

    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()
    
    let audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)

    let changePitchEffect = AVAudioUnitTimePitch()
    changePitchEffect.pitch = pitch // In cents. The default value is 1.0. The range of values is -2400 to 2400
    audioEngine.attachNode(changePitchEffect)

    audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
    audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    audioEngine.startAndReturnError(&error)
    if let e = error {
      println("Error starting audioEngine:")
      println(e)
    } else {
      audioPlayerNode.play()
    }
  }
  
  private func playAudioAtRate(rate: Float) {
    audioPlayer.stop()
    audioEngine.stop()
    audioPlayer.rate = rate
    if restartAudio {
      audioPlayer.currentTime = 0.0
    }
    audioPlayer.play()
    stopAudioButton.hidden = false
  }

}

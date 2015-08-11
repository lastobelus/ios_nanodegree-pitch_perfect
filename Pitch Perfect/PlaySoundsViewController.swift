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
  var audioPlayerNode: AVAudioPlayerNode!
  lazy var audioEngine: AVAudioEngine = AVAudioEngine()

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
    playAudioAtRate(0.5)
  }

  @IBAction func playFast(sender: UIButton) {
    playAudioAtRate(2.0)
  }

  @IBAction func playChipmunkAudio(sender: UIButton) {
    playAudioWithVariablePitch(1000)
  }
  
  @IBAction func playDarthVaderAudio(sender: UIButton) {
    playAudioWithVariablePitch(-1000)
  }
  
  @IBAction func playAlien(sender: UIButton) {
    let distortionEffect = AVAudioUnitDistortion()
    let reverbEffect = AVAudioUnitReverb()
    
    distortionEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechAlienChatter)
    reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
    playAudioWithFilters([distortionEffect, reverbEffect])
  }

  @IBAction func stopAudio(sender: UIButton) {
    println("stopAudio action")
    stopAudioButton.enabled = false
    stopAllAudioPlayers()
  }
  
  private func playAudioWithVariablePitch(pitch: Float) {
    let changePitchEffect = AVAudioUnitTimePitch()
    changePitchEffect.pitch = pitch // In cents. The default value is 1.0. The range of values is -2400 to 2400

    playAudioWithFilters([changePitchEffect])
    
  }

  private func playAudioWithFilters(filters: [AVAudioNode]) {
    var error: NSError?
    
    stopAllAudioPlayers()
    enableStopButton()

    audioEngine.reset()

    audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)

//    connect the player and all filters in a chain
    var currentFilter: AVAudioNode = audioPlayerNode
    for filter in filters {
      audioEngine.attachNode(filter)
      audioEngine.connect(currentFilter, to: filter, format: nil)
      currentFilter = filter
    }

//    connect the final filter to the output
    audioEngine.connect(currentFilter, to: audioEngine.outputNode, format: nil)

    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    audioEngine.startAndReturnError(&error)
    if let e = error {
      println("Error starting audioEngine:")
      println(e)
    } else {
      stopAudioButton.hidden = false
      audioPlayerNode.play()
    }
}
  
  private func stopAllAudioPlayers() {
    audioPlayer.stop()
    audioEngine.stop()
  }

  private func playAudioAtRate(rate: Float) {
    stopAllAudioPlayers()
    enableStopButton()

    audioPlayer.rate = rate
    if restartAudio {
      audioPlayer.currentTime = 0.0
    }
    audioPlayer.play()
  }
  
  private func enableStopButton() {
    stopAudioButton.hidden = false
    stopAudioButton.enabled = true
  }

}

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
  var restartAudio: Bool = true
  
  @IBOutlet weak var stopAudioButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    stopAudioButton.hidden = true
    if let path = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
      let movieQuoteUrl = NSURL.fileURLWithPath(path)
      audioPlayer = AVAudioPlayer(contentsOfURL: movieQuoteUrl, error:nil)
      audioPlayer.enableRate = true
    } else {
      println("could not find movie_quote.mp3 in the application")
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
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

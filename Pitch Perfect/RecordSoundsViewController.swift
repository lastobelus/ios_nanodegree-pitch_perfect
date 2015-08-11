//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Johnston on 12.07.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var stopRecordingButton: UIButton!
  @IBOutlet weak var recordTimeLabel: UILabel!
  @IBOutlet weak var pauseOrResumeButton: UIButton!

  var audioRecorder:AVAudioRecorder!
  var recordedAudio: RecordedAudio!
  
  var elapsedTimeUpdateTimer: NSTimer!

  lazy var currentRecordingFileURL: NSURL = self.initializeCurrentRecordingFileURL()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewWillAppear(animated: Bool) {
    recordingLabel.text = "Tap to Record"
    hideRecordingControls()
    recordingLabel.hidden = false
  }

  @IBAction func recordAudio(sender: UIButton) {
    showRecordingControls()
    
    var session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    
    audioRecorder = AVAudioRecorder(URL: currentRecordingFileURL, settings: nil, error: nil)
    audioRecorder.delegate = self
    audioRecorder.prepareToRecord()
    audioRecorder.record()
    beginUpdatingRecordTimeLabel()
  }

  @IBAction func pauseOrResumeRecording(sender: UIButton) {
    if audioRecorder.recording {
      setPauseOrResumeButtonToResumeMode()
      audioRecorder.pause()
    } else {
      setPauseOrResumeButtonToPauseMode()
      audioRecorder.record()
    }
  }
  
  @IBAction func stopRecording(sender: UIButton) {
    stopAudioRecorder()
    hideRecordingControls()
    setPauseOrResumeButtonToPauseMode()
    stopUpdatingRecordTimeLabel()
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    if flag {
      recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!);
      performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    } else {
      println("Recording was not successful!")
      hideRecordingControls()
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "stopRecording") {
      let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      let data = sender as! RecordedAudio
      playSoundsVC.receivedAudio = data
    }
  }
  
  func updateRecordTimeLabel() {
    recordTimeLabel.text = formatTimeInterval(audioRecorder.currentTime)
  }

  private func initializeCurrentRecordingFileURL () -> NSURL {
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    let recordingName = "current_recording.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    return filePath!
  }
  
  private func showRecordingControls() {
    recordingLabel.text = "recording"
    stopRecordingButton.hidden = false
    pauseOrResumeButton.hidden = false
    recordTimeLabel.hidden = false
    
    recordButton.enabled = false
  }
  
  private func hideRecordingControls() {
    stopRecordingButton.hidden = true
    pauseOrResumeButton.hidden = true
    recordTimeLabel.hidden = true

    recordButton.enabled = true
  }
  
  private func beginUpdatingRecordTimeLabel() {
    recordTimeLabel.textColor = UIColor.redColor();
    elapsedTimeUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target:self, selector: Selector("updateRecordTimeLabel"), userInfo: nil, repeats: true)
  }

  private func stopUpdatingRecordTimeLabel() {
    recordTimeLabel.textColor = UIColors.Blue
    elapsedTimeUpdateTimer.invalidate()
  }

  private func formatTimeInterval(timeInterval: NSTimeInterval) -> String {
    let seconds = Int(timeInterval) % 60
    let ms = Int((timeInterval - Double(seconds)) * 10.0)
    let minutes = Int(timeInterval / 60) % 60
     return String(format: "%02i:%02i.%01i",minutes,seconds,ms)
  }

  private func setPauseOrResumeButtonToPauseMode() {
    pauseOrResumeButton.setImage(UIImage (named: "pause"), forState: .Normal)
  }

  private func setPauseOrResumeButtonToResumeMode() {
    pauseOrResumeButton.setImage(UIImage (named: "resume"), forState: .Normal)
  }

  private func stopAudioRecorder() {
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    audioSession.setActive(false, error: nil)
  }
}


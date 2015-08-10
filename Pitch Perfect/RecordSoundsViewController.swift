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

  var audioRecorder:AVAudioRecorder!
  var recordedAudio: RecordedAudio!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewWillAppear(animated: Bool) {
    stopRecordingButton.hidden = true
    recordButton.enabled = true
  }

  @IBAction func recordAudio(sender: UIButton) {
    self.recordingLabel.hidden = false
    self.stopRecordingButton.hidden = false
    self.recordButton.enabled = false
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
      
    let recordingName = "current_recording.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    println(filePath)
      
    var session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    
    audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
    audioRecorder.delegate = self
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
      
  }

  @IBAction func stopRecording(sender: UIButton) {
    self.recordingLabel.hidden = true;
    self.stopRecordingButton.hidden = true;
    self.recordButton.enabled = true
    audioRecorder.stop()
    var audioSession = AVAudioSession.sharedInstance()
    audioSession.setActive(false, error: nil)
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    if flag {
      println("done recording!")
      recordedAudio = RecordedAudio();
      recordedAudio.filePathURL = recorder.url
      recordedAudio.title = recorder.url.lastPathComponent
      self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    } else {
      println("Recording was not successful!")
      self.recordButton.enabled = true
      self.stopRecordingButton.hidden = true;
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "stopRecording") {
      let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      let data = sender as! RecordedAudio
      playSoundsVC.receivedAudio = data
    }
  }
}


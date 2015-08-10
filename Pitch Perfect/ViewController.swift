//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Michael Johnston on 12.07.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var stopRecordingButton: UIButton!

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
    
  }

  @IBAction func stopRecording(sender: UIButton) {
    self.recordingLabel.hidden = true;
    self.stopRecordingButton.hidden = true;
    self.recordButton.enabled = true
  }
}


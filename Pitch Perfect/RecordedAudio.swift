//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Michael Johnston on 10.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
  var filePathURL: NSURL!
  var title: String!
  
  init(filePathURL: NSURL, title: String) {
    self.filePathURL = filePathURL
    self.title = title
  }
}
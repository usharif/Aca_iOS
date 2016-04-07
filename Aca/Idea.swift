//
//  Idea.swift
//  Aca
//
//  Created by Umair Sharif on 3/26/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.
//

import Foundation

class Idea: RecordedAudio {
    var name: String
    //var parentSong: Song
    //var isEnabled: Bool
    //var isRepeat: Bool
    //var volume: Double
    //var assocText: String
    var recordedAudio : RecordedAudio
    
    init(name: String, recordedAudio: RecordedAudio){
        self.name = name
        self.recordedAudio = recordedAudio
    }
    
}

//
//  Song.swift
//  Aca
//
//  Created by Umair Sharif on 3/23/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.
//
//
import Foundation

class Song: RecordedAudio {
    var name: String
    //var arrayOfIdeas: Array<Idea>
    //var assocText: String
    var recordedAudio: RecordedAudio
    
    init (name: String, recordedAudio: RecordedAudio) {
        self.name = name
        self.recordedAudio = recordedAudio
    }
}

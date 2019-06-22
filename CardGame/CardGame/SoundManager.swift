//
//  SoundManager.swift
//  CardGame
//
//  Created by Tung on 6/22/19.
//  Copyright © 2019 Tung. All rights reserved.
//

import Foundation
import  AVFoundation

class SoundManager {
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    func playSound(_ effect: SoundEffect){
        var soundFilename = ""
        //Xác định xem soung nào muốn dùng
        //set file
        switch effect {
        case .flip:
            soundFilename = "cardflip"
        case .shuffle:
            soundFilename = "shuffle"
        case .match:
            soundFilename = "dingcorrect"
        case .nomatch:
            soundFilename = "dingwrong"

        }
       let bundlePath =  Bundle.main.path(forResource: soundFilename, ofType: "wav")
        guard bundlePath != nil else {
            print("ko tim thay file sound \(soundFilename)in the bundle")
            return
        }
        
        //create a url object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        //create audio player object
        do{
            audioPlayer = try AVAudioPlayer(contentsOf:soundURL)
            audioPlayer?.play()
        }
        catch{
            //log the error
            print("ko the tao player sound")
        }
    }
}

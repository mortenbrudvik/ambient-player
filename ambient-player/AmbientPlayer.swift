//
//  AmbientPlayer.swift
//  ambient-player
//
//  Created by Morten Brudvik on 24/08/2018.
//  Copyright © 2018 Morten Brudvik. All rights reserved.
//

import Foundation
import AVFoundation

class AmbientPlayer {
    var audioPlayer: AVQueuePlayer!
    var observerToken: Any?
    var minutes: Int
    var soundName: String
    
    var onPlaying: ((_ playItem: AmbientPlayItem)->())?
    
    init(minutes: Int, soundName: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print(error)
        }
        
        self.minutes = minutes
        self.soundName = soundName
        createPlayer(minutes)
    }
    
    func dispose() {
        if audioPlayer != nil {
            audioPlayer.pause()
            audioPlayer.seek(to: kCMTimeZero)
            removePlayer()
        }
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    func play() {
        audioPlayer.play()
    }
    
    func createPlayer(_ minutes: Int){
        audioPlayer = AVQueuePlayer(items: createPlayList(minutes))
        audioPlayer.actionAtItemEnd = .advance
        observerToken = audioPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.audioPlayer!.currentItem?.status == .readyToPlay {
                
                let seconds : Int = Int(CMTimeGetSeconds(self.audioPlayer!.currentTime()));
                let item = AmbientPlayItem(self.audioPlayer!.currentItem!, seconds)
                self.onPlaying?(item)
            }
        }
    }
    
    func removePlayer() {
        
        if let ob = observerToken {
            audioPlayer.removeTimeObserver(ob)
        }
        audioPlayer.removeAllItems()
        audioPlayer = nil
    }
    
    private func createPlayList(_ minutes: Int) -> [AVPlayerItem] {
        print(soundName)
        let url = Bundle.main.url(forResource: soundName, withExtension: "aac")
        let asset = AVAsset(url: url!)
        let seconds = floor(CMTimeGetSeconds(asset.duration))
        let totalSeconds = minutes*60
        let repeatCount = Int(ceil(Double(totalSeconds)/Double(seconds)))
        
        let songNames = [String](repeating: soundName, count: repeatCount)
        
        return songNames.map {
            let url = Bundle.main.url(forResource: $0, withExtension: "aac")!
            return AVPlayerItem(url: url)
        }
    }
}

class AmbientPlayItem {
    init(_ item: AVPlayerItem, _ seconds: Int) {
        playTimeInSeconds = seconds
        let assetURL = item.asset as! AVURLAsset
        name = assetURL.url.lastPathComponent
    }
    let playTimeInSeconds: Int
    let name: String
}

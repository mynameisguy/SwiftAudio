//
//  AudioController.swift
//  SwiftAudio_Example
//
//  Created by Jørgen Henrichsen on 25/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftAudio


class AudioController : AudioPlayerDelegate {
    
    static let shared = AudioController()
    let player: QueuedAudioPlayer
    let audioSessionController = AudioSessionController.shared
    
    let sources: [AudioItem] = [
        DefaultAudioItem(audioUrl: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", artist: "Bon Iver", title: "33 \"GOD\"", albumTitle: "22, A Million", sourceType: .stream, artwork: #imageLiteral(resourceName: "22AMI")),
        
        // This track has a problem on purpose. It has problematic image metadata.
        // It causes the AVPlayerItem and AVPlayer to change to a status of `.failed`.
        // After this happens, the AVPlayer must be recreated, 
        // and the AVAudioSession category reset before playing other tracks.
        DefaultAudioItem(audioUrl: "https://livestage.curiousmedia.com/public/pin/audio/problem-track-with-image-metadata.mp3", artist: "Fail", title: "Bad Image Metadata Failure", albumTitle: "Fail", sourceType: .stream, artwork: #imageLiteral(resourceName: "22AMI")),
        
        DefaultAudioItem(audioUrl: "https://p.scdn.co/mp3-preview/6f9999d909b017eabef97234dd7a206355720d9d?cid=d8a5ed958d274c2e8ee717e6a4b0971d", artist: "Bon Iver", title: "715 - CRΣΣKS", albumTitle: "22, A Million", sourceType: .stream, artwork: #imageLiteral(resourceName: "22AMI")),
        DefaultAudioItem(audioUrl: "https://p.scdn.co/mp3-preview/bf9bdd403c67fdbe06a582e7b292487c8cfd1f7e?cid=d8a5ed958d274c2e8ee717e6a4b0971d", artist: "Bon Iver", title: "____45_____", albumTitle: "22, A Million", sourceType: .stream, artwork: #imageLiteral(resourceName: "22AMI"))
    ]
    
    init() {
        let controller = RemoteCommandController()
        player = QueuedAudioPlayer(remoteCommandController: controller)
        player.remoteCommands = [
            .stop,
            .play,
            .pause,
            .togglePlayPause,
            .next,
            .previous,
            .changePlaybackPosition
        ]

        player.delegate = self

        try? audioSessionController.set(category: .playback)
        try? player.add(items: sources, playWhenReady: false)
    }
    
    // MARK: - AudioPlayerDelegate

    func audioPlayer(playerDidChangeState state: AudioPlayerState) {}
    
    func audioPlayer(itemPlaybackEndedWithReason reason: PlaybackEndedReason) {}
    
    func audioPlayer(secondsElapsed seconds: Double) {}
    
    func audioPlayer(failedWithError error: Error?) {
        print("AudioController failedWithError: ", error)
    }
    
    func audioPlayer(seekTo seconds: Int, didFinish: Bool) {}
    
    func audioPlayer(didUpdateDuration duration: Double) {}

    func audioPlayerResetAudioSession() {
        // Reset the audio session category because there was a failure to play a track.
        // If the category is not reset, it seems to behave like the default category
        try? audioSessionController.set(category: .playback)
    }
}

//
//  ViewController.swift
//  ambient-player
//
//  Created by Morten Brudvik on 24/08/2018.
//  Copyright © 2018 Morten Brudvik. All rights reserved.
//

import UIKit
import SnapKit

enum TimerState {
    case notPlaying, playing, paused
}

class ViewController: UIViewController {

    var timerState: TimerState = .notPlaying
    
    var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatWhite
        return view
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .flatMintDark
        button.setTitle("Start", for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(7,22,7,22)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textColor = .flatWhite
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mainView)
        mainView.snp.makeConstraints {(make) in
            make.edges.equalTo(self.view)
        }
        
        // Start, Pause, Continue Button
        mainView.addSubview(startButton)
        startButton.snp.makeConstraints {(make) in
            make.centerX.equalTo(self.mainView)
            make.bottom.equalTo(self.mainView.snp.bottom).offset(-110)
        }
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        switch self.timerState {
        case .notPlaying:
            print("Start player")
            startPlayer()
            break
        case .playing:
            print("Pause player")
            pausePlayer()
            break
        case .paused:
            print("Continue player")
            unPausePlayer()
            break
        }
    }
    
    func startPlayer() {
        self.timerState = .playing
        startButton.setTitle("Pause", for: .normal)
    }
    
    func pausePlayer() {
        self.timerState = .paused
        startButton.setTitle("Continue", for: .normal)
    }
    
    func unPausePlayer() {
        self.timerState = .playing
        startButton.setTitle("Pause", for: .normal)
    }
    
}


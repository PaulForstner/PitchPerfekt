//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Paul Forstner on 27.04.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func startRecording(_ sender: UIButton) {
        
        self.startRecordingButton.isEnabled = false
        self.stopRecordingButton.isEnabled = true
        self.recordingLabel.text = "Recording in Progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
//        let session = AVAudioSession.sharedInstance()
//        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        
        self.startRecordingButton.isEnabled = true
        self.stopRecordingButton.isEnabled = false
        self.recordingLabel.text = "Tap to Record.."
    }
}



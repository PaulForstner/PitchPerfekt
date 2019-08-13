//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Paul Forstner on 27.04.19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController  {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var startRecordingButton: UIButton!
    @IBOutlet private weak var stopRecordingButton: UIButton!
    @IBOutlet private weak var recordingLabel: UILabel!
    
    // MARK: Properties
    
    private var audioRecorder: AVAudioRecorder!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecording" {
            let destinationVC = segue.destination as! PlaySoundsViewController
            let recordedAudioUrl = sender as! URL
            destinationVC.recordedAudioUrl = recordedAudioUrl
        }
    }
    
    // MARK: IBActions
    
    @IBAction func startRecording(_ sender: UIButton) {
        
        let session = AVAudioSession.sharedInstance()
        
        if session.recordPermission == .denied {
            showAlert(Alerts.RecordingDisabledTitle, message: Alerts.RecordingDisabledMessage)
            return
        }
        
        configureRecordingUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        } catch {
            showAlert(Alerts.AudioRecorderError, message: String(describing: error))
            return
        }
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        
        configureRecordingUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            showAlert(Alerts.AudioSessionError, message: String(describing: error))
        }
    }
    
    // MARK: Configure
    
    private func configureUI() {
        
        stopRecordingButton.isEnabled = false
        startRecordingButton.imageView?.contentMode = .scaleAspectFit
        stopRecordingButton.imageView?.contentMode = .scaleAspectFit
        recordingLabel.contentMode = .scaleAspectFit
    }
    
    private func configureRecordingUI(isRecording: Bool) {
        
        startRecordingButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record.."
    }
}

// MARK: - Audio Recorder Delegate

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            showAlert(Alerts.RecordingFailedTitle, message: Alerts.RecordingFailedMessage)
        }
    }
}

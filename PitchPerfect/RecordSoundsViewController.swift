//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by James Whitney on 10/29/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: RecordSoundsViewController
// Add AVAudioRecorderDelegate protocol to class to access audio methods for recording and stopping audio playback
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Initialize AVAudioRecorder and store in audioRecorder variable
    var audioRecorder: AVAudioRecorder!
    
    // Create outlets for UI elements to be used in recording logic
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    // Once view is loaded into memory display UI and code from Record Sounds View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    // MARK: recordAudio
    
    // Function and logic for setting up audio for recording, recording audio, and updating UI elements
    @IBAction func recordAudio(_ sender: Any) {
        configRecordingButtons(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: stopRecording
    
    // Logic for stopping recording
    @IBAction func stopRecording(_ sender: Any) {
        configRecordingButtons(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // If audio recording stopped properly display text in recordingLabel
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let alert = UIAlertController(title: "Recording Alert", message: "Recording was no successful", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")}))
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            let alert = UIAlertController(title: "Recording Alert", message: "Recording was no successful", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Function used to move to PlaySoundsViewController when stopButton is pressed/enabled
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: configRecordingButtons
    // Implementation found on Udacity forum.
    func configRecordingButtons(isRecording: Bool) {
        // Use ternary operator to display custom messages base isRecording bool value.
        recordingLabel.text = isRecording ? "Recording in progress" : "Tap to Record"
        
        // Set button isEnabled state based on isRecording bool value
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
        }
}


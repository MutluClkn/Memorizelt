//
//  AddAudioVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 11.08.2024.
//

import UIKit
import AVFoundation
import SnapKit

final class AddAudioVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIDocumentPickerDelegate {
    
    // UI Elements
    private let uploadStackView = MZStackView(axis: .horizontal, distribution: .fillProportionally , spacing: 1)
    private let uploadLabel = MZLabel(text: "Upload an audio file saved on your phone to your flashcard.", textAlignment: .left, numberOfLines: 0, fontName: Fonts.interRegular, fontSize: 17, textColor: Colors.mainTextColor)
    private let addAudioButton = MZButton(title: "Click Here", backgroundColor: Colors.clear, titleColor: Colors.accent)
    private let separatorLine = MZContainerView(cornerRadius: 0, bgColor: Colors.secondary)
    private let startButton = MZImageButton(systemImage: "circle.fill", tintColor: Colors.background, backgrounColor: Colors.primary)
    private let stopButton = MZImageButton(systemImage: "stop.circle", tintColor: Colors.background, backgrounColor: Colors.primary)
    private let soundWaveView = SoundWaveView() // Custom view for sound wave animation
    private let recordingTimeLabel = MZLabel(text: "00:00:00", textAlignment: .center, numberOfLines: 1, fontName: Fonts.interRegular, fontSize: 17, textColor: Colors.mainTextColor)

    //private let recordButton = MZImageButton(systemImage: "record.circle", tintColor: Colors.background, backgrounColor: Colors.primary)
    private let audioNameTextField = MZTextField(returnKeyType: .done)
    private let saveButton = MZButton(title: "Save", backgroundColor: Colors.primary)
    
    // Audio Properties
    private var audioRecorder: AVAudioRecorder?
    private var recordedAudioURL: URL?
    private var selectedAudioURL: URL?
    var audioTitle: String?
    
    private var recordingTimer: Timer?
    private var recordingTime: TimeInterval = 0
    
    // Delegate
    weak var delegate: AddNewCardVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        
        audioNameTextField.text = audioTitle
        
        setupConstraints()
        configureButtons()
    }
    
    // Button Configurations
    private func configureButtons() {
        addAudioButton.addTarget(self, action: #selector(addAudioButtonTapped), for: .touchUpInside)
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
            
        
        //recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addAudioButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @objc private func startButtonTapped() {
        startRecording()
        startButton.isHidden = true
        stopButton.isHidden = false
        soundWaveView.startAnimating() // Start the sound wave animation
        startRecordingTimer()
    }

    @objc private func stopButtonTapped() {
        finishRecording(success: true)
        startButton.isHidden = false
        stopButton.isHidden = true
        soundWaveView.stopAnimating() // Stop the sound wave animation
        stopRecordingTimer()
    }
    
    @objc private func recordButtonTapped() {
        func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
            let audioSession = AVAudioSession.sharedInstance()
            audioSession.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        print("Microphone access granted")
                        if self.audioRecorder == nil {
                            self.startRecording()
                        } else {
                            self.finishRecording(success: true)
                        }
                    } else {
                        print("Microphone access denied")
                        self.multiOptAlertMessage(alertTitle: "Microphone Access Required", alertMessage: "Please enable microphone access in Settings to use this feature.", firstActionTitle: "Go to Settings", secondActionTitle: "Cancel", secondActionStyle: .cancel) {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    completion(granted)
                }
            }
        }
        
    }
    
    private func startRecordingTimer() {
        recordingTime = 0
        recordingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRecordingTime), userInfo: nil, repeats: true)
    }

    @objc private func updateRecordingTime() {
        recordingTime += 1
        let minutes = Int(recordingTime) / 60
        let seconds = Int(recordingTime) % 60
        recordingTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    private func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recordedVoice.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            //recordButton.setTitle("Stop Recording", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    private func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        //recordButton.setTitle("Record Voice", for: .normal)
        
        if success {
            recordedAudioURL = getDocumentsDirectory().appendingPathComponent("recordedVoice.m4a")
        } else {
            // Handle recording failure
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /// MARK: - Permission To Access Mic
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Microphone access granted")
                } else {
                    print("Microphone access denied")
                }
                completion(granted)
            }
        }
    }
    
    @objc private func saveButtonTapped() {
        if let recordedURL = recordedAudioURL {
            selectedAudioURL = recordedURL
        }
        delegate?.selectedAudioURL = selectedAudioURL
        //delegate?.audioNameLabel.text = selectedAudioURL?.lastPathComponent
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedAudioURL = urls.first
        audioNameTextField.text = selectedAudioURL?.lastPathComponent
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        view.addSubview(uploadStackView)
        uploadStackView.addArrangedSubview(uploadLabel)
        uploadStackView.addArrangedSubview(addAudioButton)
        view.addSubview(separatorLine)
        //view.addSubview(recordButton)
        view.addSubview(startButton)
            view.addSubview(stopButton)
            view.addSubview(soundWaveView)
            view.addSubview(recordingTimeLabel)
        view.addSubview(audioNameTextField)
        view.addSubview(saveButton)
        
        
        
        uploadStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(uploadStackView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(1)
        }
        
        startButton.snp.makeConstraints { make in
                make.top.equalTo(separatorLine.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.height.width.equalTo(60)
            }
            
            stopButton.snp.makeConstraints { make in
                make.edges.equalTo(startButton)
                stopButton.isHidden = true
            }
            
            soundWaveView.snp.makeConstraints { make in
                make.top.equalTo(startButton.snp.bottom).offset(20)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(100)
            }
            
            recordingTimeLabel.snp.makeConstraints { make in
                make.top.equalTo(soundWaveView.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
            
            audioNameTextField.snp.makeConstraints { make in
                make.top.equalTo(soundWaveView.snp.bottom).offset(30)
                make.left.equalTo(40)
                make.right.equalTo(-40)
                make.height.equalTo(37)
            }
            
            saveButton.snp.makeConstraints { make in
                make.top.equalTo(audioNameTextField.snp.bottom).offset(30)
                make.centerX.equalTo(view)
                make.width.equalTo(150)
                make.height.equalTo(37)
            }
        
        /*
        recordButton.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(60)
        }
        
        audioNameTextField.snp.makeConstraints { make in
            make.top.equalTo(recordButton.snp.bottom).offset(30)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(37)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(audioNameTextField.snp.bottom).offset(30)
            make.centerX.equalTo(view)
            make.width.equalTo(150)
            make.height.equalTo(37)
        }*/
    }
}


//
//  CameraViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    //Capture session
    var captureSession = AVCaptureSession()
    
    //Capture Device
    var videoCaptureDevice: AVCaptureDevice?
    
    //Capture Output
    var captureOutput = AVCaptureMovieFileOutput()
    
    //Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let cameraView : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private let receordButton = RecordButton()
    private var previewLayer: AVPlayerLayer?
    private var recordedVideoURL: URL?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.addSubview(receordButton)
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        receordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 70
        receordButton.frame = CGRect(x: (view.width - size) / 2, y: view.height - view.safeAreaInsets.bottom - size, width: size, height: size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func didTapRecord() {
        if captureOutput.isRecording {
            captureOutput.stopRecording()
            receordButton.toggle(for: .notRecording)
        } else {
            guard var url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else { return }
            receordButton.toggle(for: .recording)
            url.appendPathComponent("video.mov")
            try? FileManager.default.removeItem(at: url)
            captureOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
    
    @objc func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        receordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }
    
    func setUpCamera() {
        //add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            if let audioInput = try? AVCaptureDeviceInput(device: audioDevice) {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
        }
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        // update session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        //configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        
        //enable camera start
        captureSession.startRunning()
    }
    
}

extension CameraViewController : AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            let alert = UIAlertController(title: "Opps", message: "Something went wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        recordedVideoURL = outputFileURL
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        guard let previewLayer = previewLayer else {
            return
        }
        receordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }
    
    @objc func didTapNext() {
        guard let url = recordedVideoURL else {
            return
        }
        let vc = CaptionViewController(videoURL: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}

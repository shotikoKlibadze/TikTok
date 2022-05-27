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
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
       
    }
    
    @objc func didTapClose() {
        captureSession.stopRunning()
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
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
        guard error == nil else { return }
        
        print("FiniShed recording to url : \(outputFileURL.absoluteString)" )
    }
}

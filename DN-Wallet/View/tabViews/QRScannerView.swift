//
//  QRScannerView.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/20/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

//Delegate callback for QRCode ScannerView
protocol QRScannerViewDelegate: class {
    func qrScanningDidFail()
    func qrScanningSucceededWithCode(_ str: String?)
    func qrScanningDidStop()
}

class QRScannerView: UIView {
    weak var delegate: QRScannerViewDelegate?
    
    /// object that manages capture activity and coordinates the flow of data from input devices to capture outputs.
    var captureSession: AVCaptureSession?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // It’s important to let the user see input from the camera before choosing to snap a photo or start video recording.
    
    // provide such a preview by connecting an AVCaptureVideoPreviewLayer to your capture session,
    // which displays a live video feed from the camera whenever the session is running.
    
    // AVCaptureVideoPreviewLayer is a Core Animation layer, so you can display and style it in your interface
    // as you would any other CALayer subclass. The simplest way to add a preview layer to a UIKit app
    // is to define a UIView subclass whose layerClass is AVCaptureVideoPreviewLayer, as shown below.
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
    
}

extension QRScannerView {
    
    var isRunning: Bool {
        // Indicates whether the receiver is running.
        return captureSession?.isRunning ?? false
    }
    
    func startScanning() {
        // Tells the receiver to start running.
        captureSession?.startRunning()
    }
    
    func stopScanning() {
        // Tells the receiver to stop running.
        captureSession?.stopRunning()
        delegate?.qrScanningDidStop()
    }
    
    ///Does the initial setup for captureSession
    private func doInitialSetup() {
        clipsToBounds = true
        captureSession = AVCaptureSession()
        
        // start configure the capture session, select a propirate capture device input and capture device output
        captureSession?.beginConfiguration()
        
        // Find the default video device.
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            // Wrap videoCaptureDevice in a capture device input.
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            // if the input can be added, add it to the session.
            // canAddInput: Returns a Boolean value that indicates whether a given input can be added to the session.
            if (captureSession?.canAddInput(videoInput) ?? false) {
                captureSession?.addInput(videoInput)
            }else {
                // configuration faild. handle error.
                scanningDidFail()
                return
            }
        } catch let error {
            print(error)
            return
        }
        
        // Next, add outputs for the kinds of media you plan to capture from the camera you’ve selected.
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        } else {
            scanningDidFail()
            return
        }
        captureSession?.commitConfiguration()
        
        self.layer.session = captureSession
        self.layer.videoGravity = .resizeAspectFill
        
        captureSession?.startRunning()
    }
    
    func scanningDidFail() {
        delegate?.qrScanningDidFail()
        captureSession = nil
    }
    
    func found(code: String) {
        delegate?.qrScanningSucceededWithCode(code)
    }
    
}

extension QRScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        stopScanning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else {return}
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
}

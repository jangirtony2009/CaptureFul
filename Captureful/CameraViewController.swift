//
//  CameraViewController.swift
//  Captureful
//
//  Created by vikas.jangir on 10/07/20.
//  Copyright © 2020 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var capturedButton: UIButton!
    
    let captureSession = AVCaptureSession()
    let movieOutPut = AVCaptureMovieFileOutput()
    var activeInput : AVCaptureDeviceInput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    var isSessionSetUp = false
    var recordedVideoUTL : URL?
    
    var outputURL : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        capturedButton.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        capturedButton.layer.cornerRadius = capturedButton.frame.width/2
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isSessionSetUp {
            if setUpSession() {
                setUpPreviewLayer()
                startSession()
            } else {
                
            }
        } else {
            if !captureSession.isRunning {
                startSession()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            stopSession()
        }
    }
    
    func setUpPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.bounds = camPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreview.layer.addSublayer(previewLayer)
    }
    
    func startSession() {
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.main.async {
            self.captureSession.stopRunning()
        }
    }
    
    func setUpSession() -> Bool {
        
        captureSession.beginConfiguration()
        
        
        let camera = AVCaptureDevice.default(for: .video)!
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            } else {
                print("Error in setup")
                captureSession.commitConfiguration()
                return false;
            }
            
        } catch  {
            print("Error in setup")
            captureSession.commitConfiguration()
            return false;
        }
        
        
        
        let microPhone = AVCaptureDevice.default(for: .audio)!
        
        do {
            let input = try AVCaptureDeviceInput(device: microPhone)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                
            } else {
                print("Error in setup")
                captureSession.commitConfiguration()
                return false;
            }
            
        } catch  {
            print("Error in setup")
            captureSession.commitConfiguration()
            return false;
        }
        
        
        if captureSession.canAddOutput(movieOutPut) {
            captureSession.addOutput(movieOutPut)
        } else {
            print("Error in setup")
            captureSession.commitConfiguration()
            return false;
        }
        	
        captureSession.commitConfiguration()
        isSessionSetUp = true
        return true
    }
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    func startRecording() {
        if !movieOutPut.isRecording {
            outputURL = tempURL()
            movieOutPut.startRecording(to: outputURL, recordingDelegate: self)
            capturedButton.backgroundColor = UIColor.blue
        } else {
            stopSession()
        }
    }
    
    func stopRecording() {
        if movieOutPut.isRecording {
            movieOutPut.stopRecording()
            capturedButton.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func thumnailButtonDidTouch(_ sender: Any) {
        guard recordedVideoUTL != nil else {
            return
        }
        performSegue(withIdentifier: "ShowViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowViewController" {
            let destinationVC = segue.destination as! VideoViewController
            destinationVC.videoURL = recordedVideoUTL
        }
    }
    
    @IBAction func capturedButtonDidTouch(_ sender: Any) {
        startRecording()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CameraViewController : AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording \(error.localizedDescription)")
            return
        } else {
            let videoRecord = outputURL as URL
            if let thumbnail = videoRecord.makeThumbnail() {
                thumbnailButton.setBackgroundImage(thumbnail, for: .normal)
            }
            self.recordedVideoUTL = videoRecord
        }
    }
    
    
}

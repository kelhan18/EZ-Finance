//
//  CameraViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

//    var captureSession = AVCaptureSession
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        setupCaptureSession()
//        setupDevice()
//        setupInputOutput()
//        setupPreviewLayer()
//        startRunningCaptureSession()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "Show Photo", sender: nil)
    }
    
    
//    func setupCaptureSession(){
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//    }
//
//    func setupDevice(){
//        let deviceDiscroverySession = AVCaptureSession.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: )
//    }
//
//    func setupInputOutput(){
//
//    }
//
//    func setupPreviewLayer(){
//
//    }
//
//    func startRunningCaptureSession(){
//
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

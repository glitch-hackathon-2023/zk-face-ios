//
//  FaceCameraViewController.swift
//  ZKFace
//
//  Created by Danna Lee on 2023/05/20.
//

import UIKit
import AVFoundation

class FaceCameraViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCamera()
    }
    
    @IBAction func onClickShot(_ sender: Any) {
        photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self as AVCapturePhotoCaptureDelegate)
    }
}

extension FaceCameraViewController {
    private func setCamera() {
        captureSession = AVCaptureSession()
        captureSession?.beginConfiguration()
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: captureDevice)
            
            photoOutput = AVCapturePhotoOutput()
            
            captureSession?.addInput(cameraInput)
            captureSession?.sessionPreset = .photo
            captureSession?.addOutput(photoOutput!)
            captureSession?.commitConfiguration()
        } catch {
            print(error)
        }
        
        //preview
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        DispatchQueue.main.async {
            self.videoPreviewLayer?.frame = self.view.bounds
        }
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        self.view.layer.insertSublayer(videoPreviewLayer!, at: 0)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }
    
    private func moveToNextVC() {
        let vc = EmbeddedWebViewController(webUrl: "https://byof-web-view-z1q9.vercel.app/main", isNavigationBarHidden: false)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FaceCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        
        captureSession?.stopRunning()
        
        guard let imageArray = FaceInferenceManager.convertUIImageToMLMultiArray(image: image) else { return }
        
        _ = try? FaceInferenceManager.predict(imageArray)
        
        moveToNextVC()
    }
}

//
//  CameraViewController.swift
//  LSDPush-upsPlan
//
//  Created by LSD on 2017/1/16.
//  Copyright © 2017年 LSD. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var callBack :((_ face: UIImage) ->())?
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var pickUIImager : UIImageView = UIImageView(image: UIImage(named: "pick_bg"))
    var line : UIImageView = UIImageView(image: UIImage(named: "line"))
    var timer : Timer!
    var upOrdown = true
    var isStart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                if ((device as AnyObject).position == AVCaptureDevicePosition.front) {
                    captureDevice = device as?AVCaptureDevice
                    if captureDevice != nil {
                        print("Capture Device found")
                        beginSession()
                    }
                }
            }
        }
        pickUIImager.frame = CGRect(x: self.view.bounds.width / 2 - 100, y: self.view.bounds.height / 2 - 100,width: 200,height: 200)
        line.frame = CGRect(x: self.view.bounds.width / 2 - 100, y: self.view.bounds.height / 2 - 100, width: 200, height: 2)
        self.view.addSubview(pickUIImager)
        self.view.addSubview(line)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CameraViewController.animationSate), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(CameraViewController.isStartTrue), userInfo: nil, repeats: false)
    }
    func isStartTrue(){
        self.isStart = true
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        captureSession.stopRunning()
    }
    
    func animationSate(){
        if upOrdown {
            if (line.frame.origin.y >= pickUIImager.frame.origin.y + 200)
            {
                upOrdown = false
            }
            else
            {
                line.frame.origin.y += 2
            }
        } else {
            if (line.frame.origin.y <= pickUIImager.frame.origin.y)
            {
                upOrdown = true
            }
            else
            {
                line.frame.origin.y -= 2
            }
        }
    }
    func beginSession() {
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        let output = AVCaptureVideoDataOutput()
        let cameraQueue = dispatch_queue_create("cameraQueue", DISPATCH_QUEUE_SERIAL)
        output.setSampleBufferDelegate(self, queue: cameraQueue)
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: kCVPixelFormatType_32BGRA]
        captureSession.addOutput(output)
        if err != nil {
            print("error: \(err?.localizedDescription)")
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = "AVLayerVideoGravityResizeAspect"
        previewLayer?.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
    }
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        if(self.isStart)
        {
            let resultImage = sampleBufferToImage(sampleBuffer: sampleBuffer)
            let context = CIContext(options:[kCIContextUseSoftwareRenderer:true])
            let detecotr = CIDetector(ofType:CIDetectorTypeFace,  context:context, options:[CIDetectorAccuracy: CIDetectorAccuracyHigh])
            let ciImage = CIImage(image: resultImage)
            let results:NSArray = detecotr!.featuresInImage(ciImage,options: ["CIDetectorImageOrientation" : 6])
            for r in results {
                let face:CIFaceFeature = r as! CIFaceFeature;
                let faceImage = UIImage(cgImage: context.createCGImage(ciImage!, from: face.bounds)!,scale: 1.0, orientation: .right)
                NSLog("Face found at (%f,%f) of dimensions %fx%f", face.bounds.origin.x, face.bounds.origin.y,pickUIImager.frame.origin.x, pickUIImager.frame.origin.y)
                dispatch_async(DispatchQueue.main) {
                    if (self.isStart)
                    {
                        self.dismiss(animated: true, completion: nil)
                        self.didReceiveMemoryWarning()
                        self.callBack!(face: faceImage!)
                    }
                    self.isStart = false
                }
            }
        }
    }
    private func sampleBufferToImage(sampleBuffer: CMSampleBuffer!) -> UIImage {
        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerCompornent = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) as UInt32)
        let newContext = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: bitsPerCompornent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)! as CGContext
        let imageRef: CGImage = newContext.makeImage()!
        let resultImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImageOrientation.right)
        return resultImage
    }
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        let hasAlpha = false
        let scale: CGFloat = 0.0 
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.draw(in: CGRect(origin: CGPointZero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

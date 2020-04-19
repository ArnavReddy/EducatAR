//
//  ViewController.swift
//  camera
//
//  Created by Gavin Hung on 11/16/19.
//  Copyright © 2019 Gavin Hung. All rights reserved.
//

import UIKit
import AVKit
import Vision
import AVFoundation

@available(iOS 13.0, *)
class TranslateViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var textView: UILabel!
    
    @IBOutlet weak var translatedTextView: UILabel!
    var effect: UIVisualEffect!
    
    @IBOutlet weak var doneButton: UIButton!
    var text: String = "Predictions"
    var ciimage : CIImage = CIImage()
    let generator = UINotificationFeedbackGenerator()
    let letters = CharacterSet.letters

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // getting camera access
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        captureSession.startRunning()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        // analyzing image
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        effect = effectView.effect
        effectView.effect = nil
        errorView.layer.cornerRadius = 5
        self.modalTransitionStyle = .flipHorizontal
        self.modalPresentationStyle = .overFullScreen
        self.view.bringSubviewToFront(translateButton)
    }
    
    // called every frame
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // image recognition
        /*
        // using model
        guard let model = try? VNCoreMLModel(for: RealSignLangauge1().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            // check err
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            self.text = firstObservation.identifier
            print(self.text)
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        */
        // image recognitions
        
        
        // text to image
        ciimage = CIImage(cvPixelBuffer: pixelBuffer)
        // text to image
    }
    
    // text to image
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
    func handleDetectedText(request: VNRequest?, error: Error?) {
        if let error = error {
            print("ERROR: \(error)")
            return
        }
        guard let results = request?.results, results.count > 0 else {
            self.text = "No Text Detected"
            return
        }
        self.text = ""
        for result in results {
            if let observation = result as? VNRecognizedTextObservation {
                for text in observation.topCandidates(1) {
                    self.text += text.string + ""
                }
            }
        }
        DispatchQueue.main.async {
            self.textView.text = "Original Text: " + self.text
        }
        
        let selected_language = "en"
        let target_language = "es"
        let YourString = "Original Text: " + self.text
        let encodedStr = "&dt=t&dt=t&q=" + YourString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let finUrl = "https://translate.googleapis.com/translate_a/single?client=gtx&sl="+selected_language+"&tl="+target_language+encodedStr
        
        
        let session = URLSession(configuration: .default)
        let url = URL(string: finUrl)!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil {
                print(error)
                return
            }
            let decodedData = Data(base64Encoded: data!.base64EncodedString())!
            let decodedString = String(data: decodedData, encoding: .utf8)!
            
            print("str:",decodedString, "sub:", decodedString[decodedString.firstIndex(of: "\"")!.utf16Offset(in: decodedString)+1..<decodedString.firstIndex(of: ",")!.utf16Offset(in: decodedString)-1])
            DispatchQueue.main.async {
                self.translatedTextView.text = decodedString[decodedString.firstIndex(of: "\"")!.utf16Offset(in: decodedString)+1..<decodedString.firstIndex(of: ",")!.utf16Offset(in: decodedString)-1]
            }
        })
        task.resume()
    }
    // text to images
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        print("ayo")
        let cgImage: CGImage = convertCIImageToCGImage(inputImage: ciimage)
        let requestText = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        requestText.recognitionLevel = .accurate
        requestText.recognitionLanguages = ["en_GB"]
        let requests = [requestText]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .right, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(requests)
            } catch let error {
                print("Error: \(error)")
            }
        }
        generator.notificationOccurred(.error)
        
        animateIn()
        
        let utterance = AVSpeechUtterance(string: self.translatedTextView.text ?? "")
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        utterance.rate = 0.3

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        
        //print(self.text)
    }
    
    func animateIn()
    {
        self.view.addSubview(errorView)
        self.view.bringSubviewToFront(errorView)
        errorView.center = self.view.center
        errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        errorView.alpha = 0
        UIView.animate(withDuration: 0.5)
        {
            self.view.bringSubviewToFront(self.errorView)
            self.effectView.effect = self.effect
            self.errorView.alpha = 1
            self.errorView.transform = CGAffineTransform.identity
        }
    }
    @IBAction func donePressed(_ sender: Any) {
        animateOut()
    }
    func animateOut()
    {
            UIView.animate(withDuration: 0.3, animations: {
                self.errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.errorView.alpha = 0
                self.effectView.effect = nil
            }){ ( success:Bool) in
                self.errorView.removeFromSuperview()
            }
    }
    
}
import Foundation

class Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }

    init(userID: Int, id: Int, title: String, body: String) {
        self.userID = userID
        self.id = id
        self.title = title
        self.body = body
    }
}
extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

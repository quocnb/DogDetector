//
//  ViewController.swift
//  DogDetector
//
//  Created by Quoc Nguyen on 2018/04/24.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    let dogsLabel = Resnet50DogLabels.dogsLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func preClassifier(_ cgImage: CGImage) {
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            print("can't load Places ML model")
            return
        }
        let request = VNCoreMLRequest(model: model) { [weak self](request, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            guard let result = (request.results as? [VNClassificationObservation])?.first else {
                print("can not detect")
                return
            }
            if self?.dogsLabel.contains(result.identifier) == true {
                self?.classifierDog(cgImage)
            } else {
                DispatchQueue.main.async {
                    self?.resultLabel.text = "Are you fucking kidding me?"
                }
            }
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }

    func classifierDog(_ cgImage: CGImage) {
        guard let model = try? VNCoreMLModel(for: StudentDogModel().model) else {
            print("can't load Places ML model")
            return
        }
        let request = VNCoreMLRequest(model: model) { [weak self](request, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            guard let result = (request.results as? [VNClassificationObservation])?.first else {
                print("can not detect")
                return
            }
            DispatchQueue.main.async {
                self?.resultLabel.text = "Detected: " + result.identifier
            }
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }

    @IBAction func didSelectDetectButton(_ sender: UIButton) {
        guard let cgImage = self.imageView.image?.cgImage else {
            print("No image?")
            return
        }
        preClassifier(cgImage)
    }
    
    @IBAction func didSelectChooseImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        self.dismiss(animated: true) {
            self.resultLabel.text = ""
            self.imageView.image = image
        }
    }
}

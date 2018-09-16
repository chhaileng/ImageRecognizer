//
//  ViewController.swift
//  ImageRecognizer
//
//  Created by Chhaileng Peng on 9/16/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func detectImage(_ sender: UIButton) {
        resultLabel.isHidden = false
        resultLabel.text = "Detecting..."
        
        let model = try? VNCoreMLModel(for: MobileNet().model)
        
        let request = VNCoreMLRequest(model: model!) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            guard let firstResult = results.first else { return }
            
            self.resultLabel.text = "\(firstResult.confidence * 100)% is \(firstResult.identifier)"
        }
        
        let ciImage = CIImage(image: imageView.image!)
        
        try? VNImageRequestHandler(ciImage: ciImage!, options: [:]).perform([request])
        
    }
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        imagePicker.delegate = self
        
    }
    
    @objc func pickImage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        
    }

}









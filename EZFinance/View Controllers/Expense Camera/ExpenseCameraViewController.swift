//
//  ExpenseCameraViewController.swift
//  EZFinance
//
//  Created by CS3714 on 12/4/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit
import AVFoundation

class ExpenseCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var createNewExpenseButton: UIButton!
    @IBOutlet var takePictureButton: UIButton!
    @IBOutlet var pictureImageView: UIImageView!
    
    //    @IBOutlet var imageSelectButton: UIButton!
    
    
    //    @IBOutlet var pictureImageView: UIImageView!
    
    var selectedImaged = UIImage(named: "photo.jpg")
    var imagePathName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewExpenseButton.isHidden = true
        pictureImageView.image = selectedImaged
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func selectPictureTapped(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            showAlertMessage(messageHeader: "No Camera Found", messageBody: "Please use a device with a camera")
            return
        }
        
        createNewExpenseButton.isHidden = false
    }
    
    @IBAction func newExpenseTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "New Expense", sender: self)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pictureImageView.contentMode = .scaleToFill
            pictureImageView.image = image
            
            imagePathName = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("photo2.png")
            print(imagePathName)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "New Expense" {
            
            let newExpenseViewController: NewExpenseViewController = segue.destination as! NewExpenseViewController
            
            newExpenseViewController.expensePhotoPath = imagePathName
        }
        
    }
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
        
    }
    
    
}




//func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//        pictureImageView.image = image
//    }
//
//    self.dismiss(animated: true, completion: nil)
//}




//    @IBAction func selectPictureTapped(_ sender: UIButton) {
//
//
//    }

//    @IBAction func imageSelectTapped(_ sender: UIButton) {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerController.SourceType.camera
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
//
//
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let pickedImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
//
//            imageSelectButton.contentMode = .scaleToFill
//
//            imageSelectButton.setImage(pickedImage, for: UIControl.State.normal)
//
//            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
//
//            let fileManager = FileManager.default
//
//            var tempString: String = "photo"
//
//            imagePathName = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(tempString).png")
//
//            let data = pickedImage.pngData()
//
//            fileManager.createFile(atPath: imagePathName, contents: data, attributes: nil)
//
//        }
//
//
//
//        picker.dismiss(animated: true, completion: nil)
//
//    }
//
//}
//



//


//    @IBAction func takePicture(_ sender: UIButton) {
//
//        let ac = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
//        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) -> Void in self.showPicker(source: .camera)
//
//        }))
//
//        ac.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) -> Void in self.showPicker(source: .photoLibrary)
//
//        }))
//
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(ac, animated: true, completion: nil)
////        performSegue(withIdentifier: "Take Picture", sender: self)
//    }
//
//    func showPicker(source: UIImagePickerController.SourceType) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = source
//        self.present(picker, animated: true, completion: nil)
//
//    }
//
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
//    {
//        dismiss(animated: true, completion: nil)
//        selectedImaged = image
//
//    }



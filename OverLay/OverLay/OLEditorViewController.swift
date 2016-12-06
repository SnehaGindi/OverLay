//
//  OLEditorViewController.swift
//  OverLay
//
//  Created by Sneha gindi on 30/11/16.
//  Copyright © 2016 Sneha gindi. All rights reserved.
//

import UIKit

class OLEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var olTextfield: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    @IBAction func shareButton(_ sender: Any) {
        let image = generateOLImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = { (activity, success, items, error) in
            if(success){
                self.save()
            }
        }
    }
    
    @IBAction func didTapOutside(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfield(textField: olTextfield)
    }

    func setupTextfield(textField: UITextField!) {
        
        textField.delegate = self
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.black,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 25
                )!,
            NSStrokeWidthAttributeName : -3
        ] as [String : Any]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }

    func presentImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        presentImagePickerController(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.imageView.endEditing(true)
        return true
        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Hey! It actually works")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.dismiss(animated: true, completion: nil)
        } else {
            print("Something went wrong")
        }
    }

    func generateOLImage() -> UIImage {
    
    // TODO: Hide toolbar
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
    
        // Render view to an image
        UIGraphicsBeginImageContext(imageView.frame.size)
        view.drawHierarchy(in: imageView.frame, afterScreenUpdates: true)
        let olImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    
    // TODO:  Show toolbar
        bottomToolBar.isHidden = false
        topToolBar.isHidden = false
        return olImage
    }
    
    func save() {
        let ovly = OverLay( typedText: olTextfield.text!, image:
            imageView.image, olImage: generateOLImage())
    
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.ovlys.append(ovly)
        //Alert to settings
        let alertController = UIAlertController (title: "Wallpaper ready!", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Later!", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


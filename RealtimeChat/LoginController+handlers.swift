//
//  LoginController+handlers.swift
//  RealtimeChat
//
//  Created by Hyeongjin Um on 22/07/2017.
//  Copyright © 2017 Hyeongjin Um. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func handleSelectProfileImageView() {
        print(123)
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        if let editiedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            print(editiedImage.size)
            selectedImage = editiedImage
        }
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print(originalImage.size)
            selectedImage = originalImage
        }
        profileImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleLoginRegisterChanged() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of the container input
        inputRegisterContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of the inputTextFields
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            nameTextFieldHeightAnchor?.isActive = false
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0)
            nameTextField.text = ""
            nameTextField.placeholder = ""
            nameTextFieldHeightAnchor?.isActive = true
        } else {
            nameTextFieldHeightAnchor?.isActive = false
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
            nameTextField.placeholder = "Name"
            nameTextFieldHeightAnchor?.isActive = true
        }
        
        //chagne height of the email,password field.
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func handleLoginOrRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    // existing user
    func handleLogin() {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { (user, error) in
            if error != nil {
                print(error)
                return
            }
            //successfully logged in
            self.dismiss(animated: true)
            print("user logged in: ", Auth.auth().currentUser?.uid)
        }
        
        
    }
    
    // new user
    func handleRegister() {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text, let nameText = nameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { (user, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            //succesfully registered
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let uniqueID = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(uniqueID).jpg")
            guard let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1) else { return }
        
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let imageURL = metadata?.downloadURL()?.absoluteString else { return }
                let values = ["name": nameText, "email": emailText, "imageURL": imageURL]
                self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
            })
        }
    }

    
    // To after store our image data to Storage , Save data with imageDownladURL to Database (correct way)
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.updateChildValues(values, withCompletionBlock: { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            //succesfully saved data to data base
            
            
            
            self.dismiss(animated: true)
        })

    }
    
    
}

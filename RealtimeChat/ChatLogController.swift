//
//  ChatLogController.swift
//  RealtimeChat
//
//  Created by Hyeongjin Um on 22/07/2017.
//  Copyright © 2017 Hyeongjin Um. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Chat Log"
        collectionView?.backgroundColor = .white
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView = UIView()
//        containerView.backgroundColor = .red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
//        let inputTextField = UITextField()
//        inputTextField.placeholder = "Enter message..."
//        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextField)
        containerView.addSubview(separatorLineView)

        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

    }
    
    func handleSend() {
        let ref = Database.database().reference().child("messages").childByAutoId()
        
//        let toId = 
        let values = ["text": inputTextField.text]
        ref.updateChildValues(values)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}

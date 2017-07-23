//
//  ViewController.swift
//  RealtimeChat
//
//  Created by Hyeongjin Um on 22/07/2017.
//  Copyright © 2017 Hyeongjin Um. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class MessageController: UITableViewController {

    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        observeMessages()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "messageCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserLogged()
        
        
    }
    
    
    //fetch message *************************
    func observeMessages() {
        Database.database().reference().child("messages").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                guard let message = Message(dictionary: dictionary) else { return }
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        cell.textLabel?.text = message.text
        
        if let toId = message.toID {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                ////
                
                if let dictionary = snapshot.value as? [String: Any] {
                    cell.textLabel?.text = dictionary["name"] as? String
                }
                
            })
        }
        
        return cell
    }
    
   
    
    
    func checkIfUserLogged() {
        // if user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        } else {
            if let uid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: Any] {
//                        self.navigationItem.title = dictionary["name"] as? String
                        
                        let user = User(dictionary: dictionary)
                        self.setupNavBarWithUser(user: user)
                        
                        
                    }
                    
                })
            }
        }
    }
    
    func setupNavBarWithUser(user: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        titleView.backgroundColor = .red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true

        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageURL {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = user.name
        
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true

        self.navigationItem.titleView = titleView
        
//        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    
    }
    
    func showChatController(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messageController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true)
    }
    
    
    func handleLogout() {
        
        //LOG OUT
        do {
            try Auth.auth().signOut()
            print("user logged out")
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        present(loginController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


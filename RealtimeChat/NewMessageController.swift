//
//  NewMessageController.swift
//  RealtimeChat
//
//  Created by Hyeongjin Um on 22/07/2017.
//  Copyright © 2017 Hyeongjin Um. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class NewMessageController: UITableViewController {
    
    let cellID = "cellID"
    var users = [User]()
    var messageController: MessageController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                //user.setValuesForKeys(dictionary) // dangerous setter (crush possibilities if user props are nil or not match with firebase)
                // initialzie user property with value like dictionary["name"] is a safe way
                let user = User(dictionary: dictionary)
                self.users.append(user)
                print(self.users.count)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        })
    }
    
    func handleCancel() {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

      //load image using static func
        if let imageUrlString = user.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: imageUrlString)
        }
      
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("dismiss completed")
            let user = self.users[indexPath.row]
            //
            self.messageController?.showChatController(user: user)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    
}

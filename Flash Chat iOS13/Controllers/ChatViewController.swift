

import UIKit
import AVFoundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    var player: AVAudioPlayer!
    
    
    var message: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.title
        //hides back button
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        //Coling method loadMessege to retrive all data from the FireStore
        loadMesseges()
        
    }
    
    //After button pressed, user sighn out and navigate to the log in screen
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            //If sighnout secsesfull, navigating to welcome screen
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    // Adding data to fireStore with needed information : message body and message sender and time
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messegeSender = Auth.auth().currentUser?.email {
            self.db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messegeSender, K.FStore.bodyField: messageBody, K.FStore.dateField: Date().timeIntervalSince1970]) { error in
                if let e = error {
                    print("It is an issue to daving your data to data base, \(e)")
                } else {
                    print("Succsesfully saved to the fireStore, \(self.db)")
                    
                    //Updating messege text field to cleat the text every time when we finish and send message
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                        self.messageTextfield.placeholder = "Write a message..."
                    }
                }
            }
        }
        
        
    }
//Creating a method to retrive all messeges and data from FireStore
    func loadMesseges(){
       
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { querySnaphot, error in
            
            self.message = [] // after new messege added, we cleared massege array and adding new(avoiding dups)
            if let e = error{
                print("We have an issue to retrieve your data from firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnaphot?.documents {
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        //print(data)
                        if let sender = data[K.FStore.senderField] as? String, let messegeBody = data[K.FStore.bodyField] as? String {
                            
                            let newMessege = Message(sender: sender, body: messegeBody)
                            self.message.append(newMessege)
                            
                            DispatchQueue.main.async {
                                //Updating table View
                                self.tableView.reloadData()
                                
                                //Play sound after new messege teceived
                                
                            
                                //Scroling to the button automatecly
                                let indexPath = IndexPath(row: self.message.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                
                                if self.message[indexPath.row].sender != Auth.auth().currentUser?.email {
                                DispatchQueue.main.async {
                                    self.playSound(soundName: "D" )}
                                    
                                    }
                            }
                            
                            
                        }
                    }
                }
            }
       
        }
    }
    
//    Play sound
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    }

    

//MARK: - UITableViewDataSource
// responsable for population table view
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message[indexPath.row].body
        
        //This is message from current user.
        if message[indexPath.row].sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightimageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
          
            
           
        }
        //This is from anther user
        else{
            cell.leftImageView.isHidden = false
            cell.rightimageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            
            
        }
        return cell
    }
    
    
}


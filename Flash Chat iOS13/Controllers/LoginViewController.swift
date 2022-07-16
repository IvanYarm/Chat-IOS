

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if let e = error {
                    print(e.localizedDescription)
                    self?.emailTextfield.text = ""
                    self?.emailTextfield.placeholder = "Email"
                    self?.passwordTextfield.text = ""
                    self?.passwordTextfield.placeholder = "Password"
                    self?.errorLabel.text = e.localizedDescription
                } else{
                    // Navigate to ChatViewController
                    self?.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
            
        }
    }
}


import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error{
                print(e.localizedDescription)
                self.emailTextfield.text = ""
                self.emailTextfield.placeholder = "Email"
                self.passwordTextfield.text = ""
                self.passwordTextfield.placeholder = "Password"
                self.errorLabel.text = ""
                self.errorLabel.text = e.localizedDescription
            } else {
                // Navigate to ChatViewController
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
            
           }
        }
    
    }
    
}

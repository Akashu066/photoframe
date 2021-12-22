//
//  newpasswordvc.swift
//  photoframe
//
//  Created by Bhavi Tech on 24/11/21.
//

import UIKit
import Alamofire
import PKHUD

class resetpassword: UIViewController {

    @IBOutlet weak var txtnewpassword: UITextField!
    @IBOutlet weak var txtverifypassword: UITextField!
    @IBOutlet weak var imglogo: UIImageView!
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var uiview: UIView!
    @IBOutlet weak var passwordview: UIView!
    
    var passwordcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imglogo.layer.cornerRadius = imglogo.frame.height/2
        imglogo.clipsToBounds = true

        self.uiview.roundCorners(corners: [.topLeft, .topRight], radius: 55)
        
        self.emailview.layer.cornerRadius = 25
        self.emailview.layer.borderWidth = 1
        self.emailview.layer.borderColor = UIColor.black.cgColor
        self.emailview.clipsToBounds = true
        
        self.passwordview.layer.cornerRadius = 25
        self.passwordview.layer.borderWidth = 1
        self.passwordview.layer.borderColor = UIColor.black.cgColor
        self.passwordview.clipsToBounds = true
       
    }
    
    @IBAction func btnupdate(_ sender: Any)
    {
        
        if txtnewpassword.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "New password filed cannot be empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtverifypassword.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Verify password filed cannot be empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtverifypassword.text != txtnewpassword.text
        {
            let alert = UIAlertController(title: "Alert", message: "Password not matched", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if !(txtnewpassword.text!.isValidPassword())
        {
            let alert = UIAlertController(title: "Alert", message: "Your password must contain at least one lower case, one upper case and a number. The password must be between 8 characters and 30 characters.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            apicalling()
            DispatchQueue.main.async
            {HUD.show(.progress)}
        }
    }
    
    func apicalling()
    {
        let urlParams = [
            
            "code": passwordcode,
            "new_password": txtverifypassword.text!
        ]
        
        print(urlParams)
        
        Alamofire.request(Constants.API.newpassword,  method: .post, parameters: urlParams, encoding:
            JSONEncoding.default, headers: nil).responseJSON
            { (response:DataResponse) in
                
                let responseJSON = response.result.value as! NSDictionary
                print("API Response",responseJSON)
                let JsonData = responseJSON["data"] as! NSDictionary
                let message = responseJSON["message"] as! String
                let Status = responseJSON["status"] as! Bool
                
                if Status == true
                {
                    print("Api password Successfull")
                   
                        
                        DispatchQueue.main.async
                            {HUD.hide()}
    
                    let alert = UIAlertController(title: "Success!", message: "Password Changed Successfully", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        print("Action")
                       
                        let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "loginvc") as!
                        loginvc
                        self.navigationController?.pushViewController(btnSkip,animated:true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                   
                }
                else
                {
                    print("Api password Failed")
                 
                    DispatchQueue.main.async
                        {HUD.hide()}
                    
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
        }
    }

}

extension String {
    func isValidPassword() -> Bool {
        //let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,30}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}

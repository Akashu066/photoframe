//
//  forgotpassvc.swift
//  photoframe
//
//  Created by Bhavi Tech on 23/11/21.
//

import UIKit
import PKHUD
import Alamofire

class forgotpassvc: UIViewController {

    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var uiview: UIView!
    @IBOutlet weak var txtemail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiview.roundCorners(corners: [.topLeft, .topRight], radius: 55)
        
        self.emailview.layer.cornerRadius = 25
        self.emailview.layer.borderWidth = 1
        self.emailview.layer.borderColor = UIColor.black.cgColor
        self.emailview.clipsToBounds = true
    }
    
    
    
    @IBAction func btnsendcode(_ sender: Any)
    {
        if txtemail.text == ""
        {
            let alert = UIAlertController(title: "Alert", message: "Please Fill Email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            forgotapicalling(email: txtemail.text ?? "")
            DispatchQueue.main.async
                {HUD.show(.progress)}
        }
    }
    
    func forgotapicalling(email: String)
    {
        let urlParams = [
            
            "email": email
        ]
        
        print(urlParams)
        
        Alamofire.request(Constants.API.forgot,  method: .post, parameters: urlParams, encoding:
            JSONEncoding.default, headers: nil).responseJSON
            { (response:DataResponse) in
                
                let responseJSON = response.result.value as! NSDictionary
                print("API Response",responseJSON)
                let JsonData = responseJSON["data"] as! NSDictionary
                let message = responseJSON["message"] as! String
                let Status = responseJSON["status"] as! Bool
                
                if Status == true
                {
                    print("Login Successfull")
                   
                    self.showToast(message: message , font: .systemFont(ofSize: 10.0))
                    
                    let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "verifyemailvc") as!
                    verifyemailvc
                    btnSkip.comefrom = "forgot"
                    btnSkip.email = email
                    self.navigationController?.pushViewController(btnSkip,animated:true)
                    
                }
                
                else
                {
                    print("Login Failed")
                 
                    DispatchQueue.main.async
                        {HUD.hide()}
                    
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
        }
    }
    

}

//
//  loginvc.swift
//  photoframe
//
//  Created by Bhavi Tech on 23/11/21.
//

import UIKit
import Alamofire
import PKHUD

class loginvc: UIViewController {
    
    var verified = Bool()
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var uiview: UIView!
    @IBOutlet weak var passwordview: UIView!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func btnforgot(_ sender: Any)
    {
        let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "forgotpassvc") as!
        forgotpassvc
        self.navigationController?.pushViewController(btnSkip,animated:true)
    }
    
    
    @IBAction func btnlogin(_ sender: Any)
    {
        
        DispatchQueue.main.async
            {HUD.show(.progress)}
        
        if txtemail.text == ""
        {
            DispatchQueue.main.async
                {HUD.hide()}
            
            let alert = UIAlertController(title: "Alert", message: "Please Fill Your Email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if txtpassword.text == ""
        {
            DispatchQueue.main.async
                {HUD.hide()}
            
            let alert = UIAlertController(title: "Alert", message: "Please Fill Your Password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            ApiCalling()
        }
    }
    
    func ApiCalling()
    {
        
//        let headers = [
//          "content-type": "application/x-www-form-urlencoded",
//          "cache-control": "no-cache",
//          "postman-token": "960e8c53-4aa8-e818-a4ef-6c5e533b8479"
//        ]
      
        let urlParams = [
            
            "email": txtemail.text!,
            "password": txtpassword.text!
        ]
        
        print(urlParams)
        
        Alamofire.request(Constants.API.loginURL,  method: .post, parameters: urlParams, encoding:
            JSONEncoding.default, headers: nil).responseJSON
            { (response:DataResponse) in
                
                let responseJSON = response.result.value as! NSDictionary
                print("API Response",responseJSON)
                let JsonData = responseJSON["data"] as! NSDictionary
                let message = responseJSON["message"] as! String
                let Status = responseJSON["status"] as! Bool
                
                if Status == true
                {
                    self.verified = responseJSON["isVerify"] as! Bool
                    print("status",self.verified)
                }
                else
                {
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                if self.verified == false
                {
                    DispatchQueue.main.async
                        {HUD.hide()}
                    UserDefaults.standard.set(self.txtemail.text, forKey: Constants.SESSION.remembermeemail)
                    let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "verifyemailvc") as!
                    verifyemailvc
                    btnSkip.email = self.txtemail.text ?? ""
                    self.navigationController?.pushViewController(btnSkip,animated:true)
                }
                else
                {
                    if Status == true
                    {
                        print("Login Successfull")
                       
                        DispatchQueue.main.async
                            {HUD.hide()}
                        
                        self.showToast(message: message , font: .systemFont(ofSize: 10.0))
                        let token = JsonData["token"] as! String
                        UserDefaults.standard.set(token, forKey: Constants.SESSION.token)
                        
                        print(token)
                        
                        let hasvalue = JsonData["has_slides"] as! Bool
                        UserDefaults.standard.set(self.txtemail.text, forKey: Constants.SESSION.remembermeemail)
                        UserDefaults.standard.set(hasvalue, forKey: Constants.SESSION.hasvalue)
                        if hasvalue == true
                        {
                            let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "Albumvc") as!
                            Albumvc
                            btnSkip.hasslides = "true"
                            self.navigationController?.pushViewController(btnSkip,animated:true)
                        }
                        else
                        {
                            let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "uploadvc") as!
                            uploadvc
                            self.navigationController?.pushViewController(btnSkip,animated:true)
                        }
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
    
}

extension UIView {

    func roundCorners(corners:UIRectCorner, radius: CGFloat) {

        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }


//
//  ViewController.swift
//  photoframe
//
//  Created by Bhavi Tech on 23/11/21.
//

import UIKit
import Alamofire
import PKHUD

class homevc: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var logincodeview: UIView!
    @IBOutlet weak var btnlogin: UIButton!
    @IBOutlet weak var loginwithview: UIView!
    @IBOutlet weak var loginwithcodeview: UIView!
    @IBOutlet weak var loginwithemailview: UIView!
    @IBOutlet weak var otpvie: UIView!
    @IBOutlet weak var otpvi1: UIView!
    @IBOutlet weak var otpvie2: UIView!
    @IBOutlet weak var otpvie3: UIView!
    @IBOutlet weak var otpvie4: UIView!
    @IBOutlet weak var otpvie5: UIView!
    @IBOutlet weak var txtotp1: UITextField!
    @IBOutlet weak var txtotp2: UITextField!
    @IBOutlet weak var txtotp3: UITextField!
    @IBOutlet weak var txtotp4: UITextField!
    @IBOutlet weak var txtotp5: UITextField!
    @IBOutlet weak var txtotp6: UITextField!
    
    
    var verified = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.logincodeview.isHidden = true
        btnlogin.isHidden = true
        loginwithview.isHidden = true
        
        self.loginwithview.roundCorners(corners: [.topLeft, .topRight], radius: 55)
        
        self.loginwithcodeview.layer.cornerRadius = 25
        self.loginwithcodeview.layer.borderWidth = 1
        self.loginwithcodeview.layer.borderColor = UIColor.black.cgColor
        self.loginwithcodeview.clipsToBounds = true
        
        self.loginwithemailview.layer.cornerRadius = 25
        self.loginwithemailview.layer.borderWidth = 1
        self.loginwithemailview.layer.borderColor = UIColor.black.cgColor
        self.loginwithemailview.clipsToBounds = true
        
        print("this is value",UserDefaults.standard.string(forKey: Constants.SESSION.remembermeemail) ?? "")
        
        let value = UserDefaults.standard.string(forKey: Constants.SESSION.remembermeemail) ?? ""
        
        if value != ""
        {
            if UserDefaults.standard.bool(forKey: Constants.SESSION.hasvalue) == true
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
            self.btnlogin.isHidden = false
        }
        
    }
    
    @IBAction func btnlogin(_ sender: Any)
    {
        self.loginwithview.isHidden = false
    }
    
    @IBAction func btnlogincode(_ sender: Any)
    {
        setup()
    }
    
    @IBAction func btnloginemail(_ sender: Any)
    {
        let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "loginvc") as!
        loginvc
        self.navigationController?.pushViewController(btnSkip,animated:true)
    }
    
    @IBAction func btncodelogin(_ sender: Any)
    {
       let code = "\(self.txtotp1.text!)\(self.txtotp2.text!)\(self.txtotp3.text!)\(self.txtotp4.text!)\(self.txtotp5.text!)\(self.txtotp6.text!)"
        
        ApiCalling(code: code)
        
    }
    
    @IBAction func btnclose(_ sender: Any)
    {
        self.logincodeview.isHidden = true
    }
    
    func ApiCalling(code: String)
    {
        
//        let headers = [
//          "content-type": "application/x-www-form-urlencoded",
//          "cache-control": "no-cache",
//          "postman-token": "960e8c53-4aa8-e818-a4ef-6c5e533b8479"
//        ]
      
        let urlParams = [
            
            "code": code
        ]
        
        print(urlParams)
        
        Alamofire.request(Constants.API.codeURL,  method: .post, parameters: urlParams, encoding:
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
//                    UserDefaults.standard.set(self.txtemail.text, forKey: Constants.SESSION.remembermeemail)
                    let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "verifyemailvc") as!
                    verifyemailvc
//                    btnSkip.email = self.txtemail.text ?? ""
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
//                        UserDefaults.standard.set(self.txtemail.text, forKey: Constants.SESSION.remembermeemail)
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
    
    func setup()
    {
        self.logincodeview.isHidden = false
        self.logincodeview.roundCorners(corners: [.topLeft, .topRight], radius: 55)
        self.otpvie.layer.cornerRadius = 15
        self.otpvi1.layer.cornerRadius = 15
        self.otpvie2.layer.cornerRadius = 15
        self.otpvie3.layer.cornerRadius = 15
        self.otpvie4.layer.cornerRadius = 15
        self.otpvie5.layer.cornerRadius = 15
        
        self.txtotp1.delegate = self
        self.txtotp2.delegate = self
        self.txtotp3.delegate = self
        self.txtotp4.delegate = self
        self.txtotp5.delegate = self
        self.txtotp6.delegate = self
        
        txtotp1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtotp2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtotp3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtotp4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtotp5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtotp6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
 
    
    @objc func textFieldDidChange(textField: UITextField){
            let text = textField.text
            if  text?.count == 1 {
                switch textField{
                case txtotp1:
                    txtotp2.becomeFirstResponder()
                case txtotp2:
                    txtotp3.becomeFirstResponder()
                case txtotp3:
                    txtotp4.becomeFirstResponder()
                case txtotp4:
                    txtotp5.becomeFirstResponder()
                case txtotp5:
                    txtotp6.becomeFirstResponder()
                case txtotp6:
                    txtotp6.resignFirstResponder()
                default:
                    break
                }
            }
            if  text?.count == 0 {
                switch textField{
                case txtotp1:
                    txtotp1.becomeFirstResponder()
                case txtotp2:
                    txtotp1.becomeFirstResponder()
                case txtotp3:
                    txtotp2.becomeFirstResponder()
                case txtotp4:
                    txtotp3.becomeFirstResponder()
                case txtotp5:
                    txtotp4.becomeFirstResponder()
                case txtotp6:
                    txtotp5.becomeFirstResponder()
                default:
                    break
                }
            }
            else{

            }
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.blue.cgColor
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

}


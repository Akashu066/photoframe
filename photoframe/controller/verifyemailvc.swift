//
//  verifyemailvc.swift
//  photoframe
//
//  Created by Bhavi Tech on 23/11/21.
//

import UIKit
import Alamofire
import PKHUD

class verifyemailvc: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resendbutton: UIButton!
    @IBOutlet weak var lbltimer: UILabel!
    @IBOutlet weak var uiview: UIView!
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
    
    var comefrom = ""
    var TIMER = Timer()
    var SECONDS = 30
    var otp = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
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
    
    func setup()
    {
        self.TIMER = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verifyemailvc.Clock), userInfo: nil, repeats: true)
        self.lbltimer.text = "Resend in 00:30"
        self.resendbutton.isHidden = true
        
        self.uiview.roundCorners(corners: [.topLeft, .topRight], radius: 55)
        self.otpvie.layer.cornerRadius = 15
        self.otpvi1.layer.cornerRadius = 15
        self.otpvie2.layer.cornerRadius = 15
        self.otpvie3.layer.cornerRadius = 15
        self.otpvie4.layer.cornerRadius = 15
        self.otpvie5.layer.cornerRadius = 15
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
    
    
    @IBAction func btnresendotp(_ sender: Any)
    {
        print("btnresend clicked")
      
    }
    
    @IBAction func btncontinue(_ sender: Any)
    {
        otp = "\(self.txtotp1.text!)\(self.txtotp2.text!)\(self.txtotp3.text!)\(self.txtotp4.text!)\(self.txtotp5.text!)\(self.txtotp6.text!)"
        otpApi()
    }
    
//    let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "resetpassword") as!
//    resetpassword
//    self.navigationController?.pushViewController(btnSkip,animated:true)
    
    func otpApi()
    {
        let urlParams = [
            
            "email": email,
            "verification_code": otp
        ]
        
        print(urlParams)
        
        Alamofire.request(Constants.API.verification,  method: .post, parameters: urlParams, encoding:
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
                   
                        
                        DispatchQueue.main.async
                            {HUD.hide()}
                    
                    if self.comefrom == "forgot"
                    {
                        let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "loginvc") as!
                        loginvc
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
    
    
    @objc func Clock()
    {
        SECONDS=SECONDS-1
        self.lbltimer.text = "Resend in 00:\(String(SECONDS))"
        if (SECONDS == 0)
        {
            self.TIMER.invalidate()
            self.lbltimer.text = "Resend"
            self.resendbutton.isHidden = false
        }
    }

}

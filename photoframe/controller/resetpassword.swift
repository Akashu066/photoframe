//
//  newpasswordvc.swift
//  photoframe
//
//  Created by Bhavi Tech on 24/11/21.
//

import UIKit

class resetpassword: UIViewController {

    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var uiview: UIView!
    @IBOutlet weak var passwordview: UIView!
    
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
    
    @IBAction func btnupdate(_ sender: Any)
    {
        let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "uploadvc") as!
        uploadvc
        self.navigationController?.pushViewController(btnSkip,animated:true)
    }
    

}

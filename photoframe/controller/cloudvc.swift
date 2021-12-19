//
//  cloudvc.swift
//  photoframe
//
//  Created by Bhavi Tech on 24/11/21.
//

import UIKit

class cloudvc: UIViewController {
    
    @IBOutlet weak var linkview: UIView!
    @IBOutlet weak var handlearea: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handlearea.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        self.linkview.layer.cornerRadius = 15
        self.linkview.layer.borderWidth = 1
        self.linkview.layer.borderColor = UIColor.black.cgColor
        self.linkview.clipsToBounds = true
    }
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
}

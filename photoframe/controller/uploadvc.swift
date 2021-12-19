//
//  uploadvc.swift
//  photoframe
//
//  Created by Bhavi Tech on 24/11/21.
//

import UIKit
import YPImagePicker
import AVFoundation
import AVKit
import Photos
import Alamofire
import PKHUD

class uploadvc: UIViewController {

    @IBOutlet weak var imgpicker: UIView!
    @IBOutlet weak var drivepicker: UIView!
    @IBOutlet weak var txtlink: UITextField!
    @IBOutlet weak var linkview: UIView!
    @IBOutlet weak var btnd: UIButton!
    @IBOutlet weak var btng: UIButton!
    
    
    var selectedvalue = ""
    
    var arrTempimg:[UIImage] = []
    var arrVideoUrls:[String] = []
    var arrRecords = [getimage]()
   var btnvalue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.drivepicker.isHidden = true
        self.imgpicker.isHidden = true
        
        self.linkview.layer.cornerRadius = 5
        self.linkview.layer.borderWidth = 1
        self.linkview.layer.borderColor = UIColor.black.cgColor
        self.linkview.clipsToBounds = true
    }
    
  
    
   
    @IBAction func btnuploadimg(_ sender: Any)
    {
        self.imgpicker.isHidden = false
    }
    
    
    @IBAction func btnlogout(_ sender: Any)
    {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to logout from the app?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            print("Action")
           
           
            
        }))
        
        alert.addAction(UIAlertAction(title: "confirm", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            print("Action")
           
            UserDefaults.standard.removeObject(forKey: Constants.SESSION.emailid)
            UserDefaults.standard.removeObject(forKey: Constants.SESSION.remembermeemail)
            UserDefaults.standard.removeObject(forKey: Constants.SESSION.USERID)
            UserDefaults.standard.removeObject(forKey: Constants.SESSION.hasvalue)
            let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "loginvc") as!
            loginvc
            self.navigationController?.pushViewController(btnSkip,animated:true)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btncam(_ sender: Any)
    {
        let alert = UIAlertController(title: "Alert", message: "Would you like to upload image or video?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Image", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            print("Action")
            
           //normal camera
            self.selectedvalue = "photo"
            self.showPicker()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            print("Action")
            
            //video camera
            self.selectedvalue = "video"
            self.showPicker()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnupload(_ sender: Any)
    {
        let alert = UIAlertController(title: "Alert", message: "Would you like to upload image or video?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Image", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            print("Action")
            
           //normal camera
            self.selectedvalue = "photo"
            self.showPicker1()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            print("Action")
            
            //video camera
            self.selectedvalue = "video"
            self.showPicker1()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btncloud(_ sender: Any)
    {
        self.drivepicker.isHidden = false
        self.imgpicker.isHidden = true
    }
    
    @IBAction func btnclose(_ sender: Any)
    {
        self.imgpicker.isHidden = true
    }
    
    @IBAction func btnclose1(_ sender: Any)
    {
        self.drivepicker.isHidden = true
    }
    
    @IBAction func btngoogleupload(_ sender: Any)
    {
        if btnvalue == 1
        {
            if txtlink.text == ""
            {
                let alert = UIAlertController(title: "Alert", message: "Please Fill Your link", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                googleapi(buttonvalue: "drive", link: txtlink.text ?? "")
            }
        }
        else
        {
            if txtlink.text == ""
            {
                let alert = UIAlertController(title: "Alert", message: "Please Fill Your link", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                googleapi(buttonvalue: "dropbox", link: txtlink.text ?? "")
            }
        }
    }
    
    
    @IBAction func btngoogle(_ sender: Any)
    {
        if btnvalue == 0
        {
            btng.setImage(UIImage(named: "radio"), for: .normal)
            btnd.setImage(UIImage(named: "circle"), for: .normal)
            btnvalue = 1
        }
        else
        {
            btng.setImage(UIImage(named: "circle"), for: .normal)
            btnvalue = 0
        }
    }
    
    @IBAction func btndropbox(_ sender: Any)
    {
        if btnvalue == 1
        {
            btnd.setImage(UIImage(named: "radio"), for: .normal)
            btng.setImage(UIImage(named: "circle"), for: .normal)
            btnvalue = 0
        }
        else
        {
            btng.setImage(UIImage(named: "circle"), for: .normal)
            btnvalue = 1
        }
    }
    
    
    @objc
    func showPicker() {
        
        var config = YPImagePickerConfiguration()
        
        config.library.mediaType = .photo
        
        config.shouldSaveNewPicturesToAlbum = false
        
        /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
        config.video.compression = AVAssetExportPresetMediumQuality
        
        config.startOnScreen = .video
        
        if selectedvalue == "video"
        {
            config.screens = [.video]
        }
        else
        {
            config.screens = [.photo]
        }
        
        config.video.libraryTimeLimit = 30.0
        
        config.showsCrop = .rectangle(ratio: 500/500)
        
        if selectedvalue == "video"
        {
            config.wordings.libraryTitle = "Video"
        }
        else
        {
            config.wordings.libraryTitle = "Photo"
        }
        
        config.hidesStatusBar = false
        
        config.hidesBottomBar = false
        
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                
                let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "uploadvc") as!
                uploadvc
                self.navigationController?.pushViewController(btnSkip,animated:true)
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            //   self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    let image = photo.image
                    print("this is photo url",image)
                    self.arrTempimg.append(photo.image)
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    let assetURL = video.url
                    //let videourl = self.convertVideo(Video: video.url)
                    let pathURL = assetURL // URL
                    let pathString = pathURL.path // String
                    self.arrVideoUrls.append(pathString)
                    print("My Url",self.arrVideoUrls)
                    picker.dismiss(animated: true, completion: { [weak self] in
                        //self?.present(playerVC, animated: true, completion: nil)
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
            
            self.uploadImage()
            DispatchQueue.main.async
                {HUD.show(.progress)}
            
        }
        present(picker, animated: true, completion: nil)
    }
    
    
    @objc
    func showPicker1() {
        
        var config = YPImagePickerConfiguration()
        
        if selectedvalue == "video"
        {
            config.library.mediaType = .video
        }
        else
        {
            config.library.mediaType = .photo
        }
        
        
        config.shouldSaveNewPicturesToAlbum = false
        
        /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
        config.video.compression = AVAssetExportPresetMediumQuality
        
        config.startOnScreen = .library
        
        config.screens = [.library]
        config.video.libraryTimeLimit = 500.0
        
        config.showsCrop = .rectangle(ratio: 500/500)
        
        config.wordings.libraryTitle = "library"
        
        config.hidesStatusBar = false
        
        config.hidesBottomBar = false
        
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                
                let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "uploadvc") as!
                uploadvc
                self.navigationController?.pushViewController(btnSkip,animated:true)
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            //   self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    let image = photo.image
                    print("this is photo url",image)
                    self.arrTempimg.append(photo.image)
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    let assetURL = video.url
                    //let videourl = self.convertVideo(Video: video.url)
                    let pathURL = assetURL // URL
                    let pathString = pathURL.path // String
                    self.arrVideoUrls.append(pathString)
                    print("My Url",self.arrVideoUrls)
                    picker.dismiss(animated: true, completion: { [weak self] in
                        //self?.present(playerVC, animated: true, completion: nil)
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
            
            self.uploadImage()
            DispatchQueue.main.async
                {HUD.show(.progress)}
            
        }
        present(picker, animated: true, completion: nil)
    }
    
    
    func uploadImage(){
        
        
        if Reachability.isConnectedToNetwork() == true
        {
            DispatchQueue.main.async
                {HUD.show(.progress)}
            
            let headers = [
                "authorization": "Bearer \(UserDefaults.standard.string(forKey: Constants.SESSION.token) ?? "")",
            ]
            print(headers)
            
            let uid = UserDefaults.standard.string(forKey: Constants.SESSION.USERID)
            print(uid)
            
            
            let parameters = [String : Any]()
            
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                let userData = try? JSONSerialization.data(withJSONObject: parameters)
                
                multipartFormData.append(userData!, withName: "data[]")
                
                
                for i in 0..<self.arrTempimg.count {
                    if let dataImages = self.arrTempimg[i].jpegData(compressionQuality: 0.7)
                    {
                        multipartFormData.append(dataImages, withName: "files[]", fileName: "\(i).jpg", mimeType: "files/png")
                    }
                }
                
               for numberS in 0..<self.arrVideoUrls.count{
                    let vUrl = self.arrVideoUrls[numberS]
                    print(vUrl)
                    let filename = vUrl
                    let fileExtention = (filename as NSString).pathExtension
                    let pathPrefix = (filename as NSString).deletingPathExtension
                    print("FILE NAME -->",filename)
                    print("FILE PREFIX -->",pathPrefix)
                    print("FILE EXTENSTION -->",fileExtention)
                    let videoUrl = URL(fileURLWithPath: vUrl)
                    print("video url", videoUrl )
                    do {
                        let data = try Data(contentsOf: videoUrl, options: .mappedIfSafe)
                        print(data)
                        multipartFormData.append(data, withName: "files[]", fileName: filename, mimeType: "video/mp4")
                        print(multipartFormData)
                        
                    } catch  {
                    }
                }
            },
            to:"http://techeruditedev.xyz/projects/photo-frame-api/api/slideshow/add_slides", method:.post, headers: headers)
            { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress:", progress.fractionCompleted)
                    })
                    upload.responseJSON { response in
                        print(response.result.value!)
                        
                        let responseJSON = response.result.value as! [String:AnyObject]
                        
                        let arr = responseJSON["data"] as? Array<Dictionary<String, AnyObject>>
                        
                        self.arrRecords.removeAll()
                        for i in arr!
                        {
                                let item = i as NSDictionary
                                let data = getimage()
                            
                            data.file_name = item["file_name"] as! String
                            data.id = (item["id"] as? Int)!
                            data.file_url = item["file_url"] as! String
                            data.slideshow_id = item["slideshow_id"] as! Int
                            data.thumb_url = item["thumb_url"] as! String
                            data.user_id = item["user_id"] as! Int
                            data.type = item["type"] as! Int
                            self.arrRecords.append(data)
                            print("this is an data count",self.arrRecords.count)
                        }
                
                        
                        let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "Albumvc") as!
                        Albumvc
                        
                        btnSkip.arrdata = self.arrRecords
                        
                        self.navigationController?.pushViewController(btnSkip,animated:true)
                        
                        print("sucess")
                        
                    }
                case .failure(let encodingError):
                    DispatchQueue.main.async
                        {HUD.hide()}
                    
                    print("fail")
                }
            }
            
        }
        else
        {
            DispatchQueue.main.async
                {HUD.hide()}
            let alert = UIAlertController(title: "Alert", message: "fail", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    func googleapi(buttonvalue: String,link: String)
    {
        
        let headers = [
            "authorization": "Bearer \(UserDefaults.standard.string(forKey: Constants.SESSION.token) ?? "")",
        ]
        
        let urlParams = [
            
            "type": buttonvalue,
            "link": link
        ]
        
        print(urlParams)
        
        Alamofire.request("http://techeruditedev.xyz/projects/photo-frame-api/api/slideshow/upload_from_folder",  method: .post, parameters: urlParams, encoding:
            JSONEncoding.default, headers: headers).responseJSON
            { (response:DataResponse) in
                
                let responseJSON = response.result.value as! NSDictionary
                print("API Response",responseJSON)
                let JsonData = responseJSON["data"] as! NSDictionary
                let message = responseJSON["message"] as! String
                let Status = responseJSON["status"] as! Bool
                
                if Status == true
                {
                    print("Login Successfull")
                   
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

extension uploadvc {
    /* Gives a resolution for the video by URL */
    func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}

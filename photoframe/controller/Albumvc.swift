//
//  Albumvc.swift
//  photoframe
//
//  Created by Bhavi Tech on 25/11/21.
//

import UIKit
import SDWebImage
import YPImagePicker
import Alamofire
import PKHUD
import AVKit
import AVFoundation
import CoreMedia
import PryntTrimmerView
import CropViewController

class Albumvc: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CropViewControllerDelegate {
   
    @IBOutlet weak var collactionalbum: UICollectionView!
    @IBOutlet weak var imgpicker: UIView!
    @IBOutlet weak var drivepicker: UIView!
    @IBOutlet weak var txtlink: UITextField!
    @IBOutlet weak var linkview: UIView!
    @IBOutlet weak var btnd: UIButton!
    @IBOutlet weak var btng: UIButton!
    @IBOutlet weak var playerview: UIView!
    @IBOutlet weak var player: UIView!
    @IBOutlet weak var btnrotate: UIButton!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var viewimg: UIView!
    @IBOutlet weak var img: UIImageView!
    
  
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var selectedvalue = ""
    var selectedvalue1 = ""
    var imageviewurl = ""
    var arrTempimg:[UIImage] = []
    var arrimg:[String] = []
    var arrVideoUrls:[String] = []
    var arrTempimg1:[UIImage] = []
    var arrviewimg:[UIImage] = []
    var arrVideoUrls1:[String] = []
    var viewimag = UIImage()
    var arrdata = [getimage]()
    var videoplayurl = ""
    var btnvalue = 0
    var hasslides = ""
    var videoconfig = YPImagePickerConfiguration()
    var videoU = ""
    var play: AVPlayer!
    var slideid = Int()
    var btnrotateflag = false
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.playerview.isHidden = true
        self.drivepicker.isHidden = true
        self.imgpicker.isHidden = true
        self.viewimg.isHidden = true
        
        self.linkview.layer.cornerRadius = 5
        self.linkview.layer.borderWidth = 1
        self.linkview.layer.borderColor = UIColor.black.cgColor
        self.linkview.clipsToBounds = true
        
        self.btnrotate.layer.cornerRadius = 5
        self.btnrotate.clipsToBounds = true
        self.btncancel.layer.cornerRadius = 5
        self.btncancel.clipsToBounds = true
        self.btnsave.layer.cornerRadius = 5
        self.btnsave.clipsToBounds = true
        
        //self.img.transform = self.img.transform.rotated(by: CGFloat(Double.pi / 2))
        
        if hasslides == "true"
        {
            getlistdata(token: UserDefaults.standard.string(forKey: Constants.SESSION.token) ?? "")
            DispatchQueue.main.async
                {HUD.show(.progress)}
        }
        else
        {
            
        }
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//            let width = UIScreen.main.bounds.width
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//            layout.itemSize = CGSize(width: width / 4, height: width / 3)
//            layout.minimumInteritemSpacing = 0
//            layout.minimumLineSpacing = 0
//            collactionalbum!.collectionViewLayout = layout
        screenSize = UIScreen.main.bounds
                screenWidth = screenSize.width
                screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
                layout.itemSize = CGSize(width: screenWidth/4, height: screenWidth/3)
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                collactionalbum!.collectionViewLayout = layout
        
    }
    
    
    
    @IBAction func btnrotate(_ sender: Any)
    {
            let url = URL(string: imageviewurl)
            if let data = try? Data(contentsOf: url!)
            {
                var image: UIImage = UIImage(data: data)!
                let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
                //cropController.modalPresentationStyle = .fullScreen
                cropController.delegate = self
                
                self.image = image
                
                //picker.pushViewController(cropController, animated: true)
                btnrotateflag = true
                self.present(cropController, animated: true, completion: nil)
            }
    }
    
    @IBAction func btncancel(_ sender: Any)
    {
       self.viewimg.isHidden = true
    }
   
    
    @IBAction func btnsave(_ sender: Any)
    {
        if btnrotateflag == false
        {
            self.showToast(message: "No change in image" , font: .systemFont(ofSize: 10.0))
        }
        else
        {
            ApiCalling()
        }
    }
    
    func ApiCalling()
    {
        if Reachability.isConnectedToNetwork() == true
        {
            DispatchQueue.main.async
                {HUD.show(.progress)}
            let headers = [
                "authorization": "Bearer \(UserDefaults.standard.string(forKey: Constants.SESSION.token) ?? "")",
            ]
            print(headers)
           
            let parameters: Parameters = ["slide_id": slideid]
            print("this is parameters",parameters)
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                let userData = try? JSONSerialization.data(withJSONObject: parameters)
                
                multipartFormData.append(userData!, withName: "data[]")
                
                for i in 0..<self.arrTempimg.count {
                    if let dataImages = self.arrTempimg[i].jpegData(compressionQuality: 0.7)
                    {
                        multipartFormData.append(dataImages, withName: "files[]", fileName: "\(i).jpg", mimeType: "files/png")
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
                        
                        self.arrdata.removeAll()
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
                            self.arrdata.append(data)
                            print("this is an data count",self.arrdata.count)
                            self.collactionalbum.reloadData()
                        }
                        print("sucess")
                        let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "Albumvc") as!
                        Albumvc
                        btnSkip.hasslides = "true"
                        self.navigationController?.pushViewController(btnSkip,animated:true)
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
            let alert = UIAlertController(title: "Alert", message: "Something Went Wrong! Try Later!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnclosepic(_ sender: Any)
    {
        self.viewimg.isHidden = true
        
    }
    @IBAction func btnclose(_ sender: Any)
    {
        resetPlayer()
    }
    
    
    @IBAction func btnaddphoto(_ sender: Any)
    {
        self.imgpicker.isHidden = false
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
            self.selectedvalue1 = "photo"
            self.showPicker1()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            print("Action")
            
            //video camera
            self.selectedvalue1 = "video"
            self.showPicker1()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btncloud(_ sender: Any)
    {
        self.drivepicker.isHidden = false
        self.imgpicker.isHidden = true
    }
    
    @IBAction func btnclose1(_ sender: Any)
    {
        self.imgpicker.isHidden = true
    }
    
    @IBAction func btnclose2(_ sender: Any)
    {
        self.drivepicker.isHidden = true
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
            let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "homevc") as!
            homevc
            self.navigationController?.pushViewController(btnSkip,animated:true)
            
        }))
        self.present(alert, animated: true, completion: nil)
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        arrdata.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath ) as! albumcell
        
        
    
        var allData = getimage()
        allData = arrdata[indexPath.row]
        
        let getfilename = allData.file_url
        cell.bgview.layer.cornerRadius = 5
        cell.bgview.clipsToBounds = true
        let filetype = allData.type
      
        
        if filetype == 0
        {
            cell.btnplay.isHidden = true
            cell.btnimg.isHidden = false
            cell.btnimg.addTarget(self, action: #selector(connect3(sender3:)), for: .touchUpInside)
            cell.btnimg.tag = indexPath.row
            cell.img.sd_setImage(with: URL(string: getfilename), placeholderImage: UIImage(named: "photo"))
        }
        else
        {
            let thumb = allData.thumb_url
            cell.btnplay.isHidden = false
            cell.btnimg.isHidden = true
            cell.btnplay.addTarget(self, action: #selector(connected2(sender2:)), for: .touchUpInside)
            cell.btnplay.tag = indexPath.row
            cell.img.sd_setImage(with: URL(string: thumb), placeholderImage: UIImage(named: "photo"))
        }
        
        cell.btnclose.addTarget(self, action: #selector(connect(sender:)), for: .touchUpInside)
        cell.btnclose.tag = indexPath.row
        
        DispatchQueue.main.async
            {HUD.hide()}
        return cell
    }
    
    @objc func connect(sender: UIButton)
    {
        let Data = arrdata[sender.tag]
        slideid = Data.id
        Apidelete(slideid: slideid)
        DispatchQueue.main.async
        {HUD.show(.progress)}
    }
    
    @objc func connect3(sender3: UIButton)
    {
        self.viewimg.isHidden = false
        let Data3 = arrdata[sender3.tag]
        slideid = Data3.id
        let imgurl = Data3.file_url as? String ?? ""
        self.imageviewurl = imgurl
        self.img.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: "photo"))
    }
    
    
    @objc func connected2(sender2: UIButton)
    {
        self.playerview.isHidden = false
        
        let Data3 = arrdata[sender2.tag]
        let videourl = Data3.file_url as? String
        videoU = videourl ?? ""
        slideid = Data3.id
        print(videourl)
//        let avPlayer = AVPlayer(url: URL(string: "\(videourl ?? "")")!);
//        videoplayurl = videourl ?? ""
//
        if Data3.type == 1
        {
            guard let url = NSURL(string: videourl!) as URL? else {return}
            self.play = AVPlayer(url: url)
            
            let videoLayer = AVPlayerLayer(player: self.play)
            videoLayer.frame = self.player.bounds
            videoLayer.videoGravity = .resizeAspect
            self.player.layer.addSublayer(videoLayer)
            self.play.play()
            }
        
        
    }
    
    
    
    @IBAction func btntrim(_ sender: Any)
    {
        print("this is video id",slideid)
        let btnSkip = self.storyboard?.instantiateViewController(withIdentifier: "trimvc") as! VideoMainViewController
        btnSkip.videourl = videoU
        btnSkip.videoid = slideid
        self.navigationController?.pushViewController(btnSkip,animated:true)
    }
    
    
    
    func getlistdata(token: String)
    {
        
        let headers = [
            "authorization": "Bearer \(token)",
        ]
        
        var requstParams = [String: Any]()
        
        
        Alamofire.request("http://techeruditedev.xyz/projects/photo-frame-api/api/slideshow/list_slides",  method: .post, parameters: requstParams, encoding:
            JSONEncoding.default, headers: headers).responseJSON
            { (response:DataResponse) in
                
                let responseJSON = response.result.value as! NSDictionary
                print("API Response",responseJSON)
                let JsonData = responseJSON["data"] as! Array<Dictionary<String, AnyObject>>
                let message = responseJSON["message"] as! String
                let Status = responseJSON["status"] as! Bool
                
                if Status == true
                {
                    print("Login Successfull")
                   
                    let arr = JsonData
                    
                    self.arrdata.removeAll()
                    for i in arr
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
                        self.arrdata.append(data)
                        print("this is an data count",self.arrdata.count)
                        self.collactionalbum.reloadData()
                    }
                    print("sucess")
                    
//                    self.screenSize = UIScreen.main.bounds
//                    self.screenWidth = self.screenSize.width
//                    self.screenHeight = self.screenSize.height
//
//                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//                            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//                    layout.itemSize = CGSize(width: self.screenWidth/3, height: self.screenWidth/3)
//                            layout.minimumInteritemSpacing = 0
//                            layout.minimumLineSpacing = 0
//                            collectionView!.collectionViewLayout = layout
                    
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
                    self.arrTempimg.removeAll()
                    let image = photo.image
                    print("this is photo url",image)
                    self.arrTempimg.append(photo.image)
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    self.arrVideoUrls.removeAll()
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
        
        if selectedvalue1 == "video"
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
                    self.arrTempimg1.removeAll()
                    let image = photo.image
                    print("this is photo url",image)
                    self.arrTempimg1.append(photo.image)
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    self.arrVideoUrls1.removeAll()
                    let assetURL = video.url
                    //let videourl = self.convertVideo(Video: video.url)
                    let pathURL = assetURL // URL
                    let pathString = pathURL.path // String
                    self.arrVideoUrls1.append(pathString)
                    print("My Url",self.arrVideoUrls1)
                    picker.dismiss(animated: true, completion: { [weak self] in
                        //self?.present(playerVC, animated: true, completion: nil)
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
            
            self.uploadImage1()
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
                
                if self.selectedvalue == "photo"
                {
                    for i in 0..<self.arrTempimg.count {
                        if let dataImages = self.arrTempimg[i].jpegData(compressionQuality: 0.7)
                        {
                            multipartFormData.append(dataImages, withName: "files[]", fileName: "\(i).jpg", mimeType: "files/png")
                        }
                    }
                }
                else
                {
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
                        
                        self.arrdata.removeAll()
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
                            self.arrdata.append(data)
                            print("this is an data count",self.arrdata.count)
                            self.imgpicker.isHidden = true
                            self.collactionalbum.reloadData()
                        }
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
            self.imgpicker.isHidden = false
            let alert = UIAlertController(title: "Alert", message: "Something Went Wrong! Try Later!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func uploadImage1(){
        
        
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
                
                if self.selectedvalue1 == "photo"
                {
                    for i in 0..<self.arrTempimg1.count {
                        if let dataImages = self.arrTempimg1[i].jpegData(compressionQuality: 0.7)
                        {
                            multipartFormData.append(dataImages, withName: "files[]", fileName: "\(i).jpg", mimeType: "files/png")
                        }
                    }
                }
                else
                {
                    for numberS in 0..<self.arrVideoUrls1.count{
                         let vUrl = self.arrVideoUrls1[numberS]
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
                        
                        self.arrdata.removeAll()
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
                            self.arrdata.append(data)
                            print("this is an data count",self.arrdata.count)
                            self.imgpicker.isHidden = true
                            self.collactionalbum.reloadData()
                        }
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
            self.imgpicker.isHidden = false
            let alert = UIAlertController(title: "Alert", message: "Something Went Wrong! Try Later!", preferredStyle: UIAlertController.Style.alert)
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
                    self.drivepicker.isHidden = true
                }
                
                else
                {
                    print("Login Failed")
                 
                    DispatchQueue.main.async
                        {HUD.hide()}
                    self.drivepicker.isHidden = false
                    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
        }
    }
    
    
    private func resetPlayer() {
        if play != nil {
            play.pause()
            play.replaceCurrentItem(with: nil)
            play = nil
            self.playerview.isHidden = true
        }
    }
    
    class PlayerView: UIView {
        override static var layerClass: AnyClass {
            return AVPlayerLayer.self;
        }

        var playerLayer: AVPlayerLayer {
            return layer as! AVPlayerLayer;
        }

        var player: AVPlayer? {

            get {
                return playerLayer.player;
            }
            set {
                playerLayer.player = newValue;
            }
        }
    }
    
    
    func Apidelete(slideid: Int)
    {
        
        let headers = [
            "authorization": "Bearer \(UserDefaults.standard.string(forKey: Constants.SESSION.token) ?? "")",
        ]
        
        let urlParams = [
            
            "slides_id": slideid
        ]
        
        print(urlParams)
        
        Alamofire.request(Constants.API.delete,  method: .post, parameters: urlParams, encoding:
            JSONEncoding.default, headers: headers).responseJSON
            { (response:DataResponse) in
                
                let responseJSON = response.result.value as! NSDictionary
                print("API Response",responseJSON)
                let JsonData = responseJSON["data"] as! Array<Dictionary<String,AnyObject>>
                let message = responseJSON["message"] as! String
                let Status = responseJSON["status"] as! Bool
                
                if Status == true
                {
                    print("Login Successfull")
                   
                    self.arrdata.removeAll()
                    for i in JsonData
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
                        self.arrdata.append(data)
                        print("this is an data count",self.arrdata.count)
                        self.showToast(message: message , font: .systemFont(ofSize: 10.0))
                        self.collactionalbum.reloadData()
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
    
    //MARK :- crop view
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        img.image = image
        //layoutImageView()
        
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            img.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: img,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.viewimg.isHidden = false },
                                                   completion: {
                                                    self.img.isHidden = false })
            self.arrTempimg.append(image)
        }
        else {
            self.img.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    
}


extension Albumvc {
    /* Gives a resolution for the video by URL */
    func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}




//
//  SecondViewController.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 2/28/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SaleVC: UIViewController {

    
    //MARK:- Outlets
    var u_name: String?
    var u_phone: String?
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var qrCodeImage: UIImageView!

    var documentUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        
    }
    
    fileprivate func initViewController() {
        handleNavigationBar()
        username.text = u_name ?? "username"
        phone.text = u_phone ?? "phone"
        email.text = Auth.shared.getUserEmail() ?? "ahmedmohamedeid98@gmail.com"
        
        if let filePath = exist(fileName: keys.qrCodeFileName) {
            // load image from filePath and show it to ui
            qrCodeImage.image = UIImage(contentsOfFile: filePath)
        }else {
            // generate image and save it to user document
            generateQRCodeImage()
            _ =  save(fileName: keys.qrCodeFileName)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handleNavigationBar() {
        navigationItem.title = "Sale"
        navigationController?.navigationBar.barTintColor = UIColor.DN.DarkBlue.color()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "tray.and.arrow.down.fill"), style: .plain, target: self, action: #selector(downlaodQRCodeBtn(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func generateQRCodeImage() {
        let username = u_name ?? "username"
        let email = self.email.text ?? "ahmedmohamedeid98@gmail.com"
        let phone = u_phone ?? "phome number"
        let u_data = "\(username);\(email);\(phone)"
        let data = u_data.data(using: .isoLatin1, allowLossyConversion: false)
        
        let filter: CIFilter? = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        let ciImage:CIImage = filter?.outputImage ?? CIImage()
        
        let scaleX = qrCodeImage.frame.width / ciImage.extent.size.width
        let scaleY = qrCodeImage.frame.height / ciImage.extent.size.height
        
        let transformedImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrCodeImage.image = UIImage(ciImage: transformedImage)
    }
    
    
    //MARK:- Actions
    @objc func downlaodQRCodeBtn(_ sender: Any) {
        if let _ = exist(fileName: keys.qrCodeFileName) {
            // Image is already Downloaded or save automatically by the app
            Auth.shared.buildAndPresentAlertWith("save success", message: "qrCodeImage downloaded successfully to path: /Documents/\(keys.qrCodeFileName)", viewController: self)
            print("file exist ::2")
        } else {
            if let _ = save(fileName: keys.qrCodeFileName) {
                Auth.shared.buildAndPresentAlertWith("save success", message: "qrCodeImage saved successfully to path: /Documents/\(keys.qrCodeFileName)", viewController: self)
                print("file save ::1")
            }else {
                Auth.shared.buildAndPresentAlertWith("faild saving", message: "faild to save image, try again.", viewController: self)
                print("file faild to save ::2")
            }
        }
        
    }
    
    func save(fileName: String) -> String? {
        do {
            let fileURL = documentUrl.appendingPathComponent(fileName)
            guard let image = qrCodeImage.image else {
                return nil
            }
            if let imgData = image.pngData() {
                try imgData.write(to: fileURL)
                return fileURL.path
            }
            
        }catch {
            print(error)
        }
        return nil
    }
    
    func exist(fileName: String) -> String? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let pathComponent = url.appendingPathComponent(fileName)
        let filePath = pathComponent.path
        if FileManager.default.fileExists(atPath: filePath) {
            return filePath
        } else {
            return nil
        }
    }
    
}


//
//  EditAccountVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 6/4/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit


class EditAccountVC: UIViewController {
    
    // Properities
    private lazy var meManager: MeManagerProtocol  = MeManager()
    private lazy var auth:UserAuthProtocol = UserAuth()
    private var editList: [String: Any] = [:]
    @IBOutlet weak var currentUsername: UILabel!
    @IBOutlet weak var newUsernameTextField: UITextField!
    
    @IBOutlet weak var currentCountry: UILabel!
    @IBOutlet weak var newCountryTextField: UITextField!
    
    @IBOutlet weak var currentPhone: UILabel!
    @IBOutlet weak var updatePhoneBtnOutlet: UIButton!
    
    @IBOutlet weak var currentImageView: DNAvatarImageView!
    @IBOutlet weak var updateImageBtnOutlet: UIButton!
    
    @IBOutlet weak var currentJob: UILabel!
    @IBOutlet weak var newJobTextField: UITextField!
    
    @IBOutlet weak var currentGender: UILabel!
    @IBOutlet weak var genderMaleBtnOutlet: UIButton!
    @IBOutlet weak var genderFemaleBtnOutlet: UIButton!

    var userInfo: AccountInfo? // this data come from setting vc

    private var gender: String? = nil {
        didSet {
            guard let txt = gender else { return }
            editList["gender"] = txt
            toggleGender(to: txt)
        }
    }
    private var newImage: UIImage? = nil {
        didSet {
            guard let image = newImage else {return}
            self.currentImageView.image = image
        }
    }
    private var newPhone: String? = nil {
        didSet {
            guard let phone = newPhone else {return}
            self.currentPhone.text = phone
        }
    }
    private var newCountry: String? = nil {
        didSet {
            guard let country = newCountry else {return}
            self.currentCountry.text = country
        }
    }
    private var newUsername: String? = nil {
        didSet {
            guard let username = newUsername else {return}
            self.currentUsername.text = username
        }
    }
    private var newJob: String? = nil {
        didSet {
            guard let job = newJob else {return}
            self.currentJob.text = job
        }
    }
    private var pickerSourceType: UIImagePickerController.SourceType? = nil {
        didSet{
            guard let type = pickerSourceType else {return}
            self.presentPickerViewController(withType: type)
        }
    }
    private var rightBarBtn: UIBarButtonItem!
    
     //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupNavBar()
        updateCurrentInfoWithComingData()
    }
    
    //handle status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func updateCurrentInfoWithComingData() {
        if let data = userInfo {
            self.currentUsername.text    = data.user.name
            self.currentCountry.text     = data.user.country
            self.currentJob.text         = data.user.job
            self.currentGender.text      = data.user.gender
            self.currentPhone.text       = data.user.phone
            self.currentImageView.downlaodedImage(from: data.user.photo ?? "")
        }
    }
    
    private func initView() {
        newCountryTextField.delegate = self
        newCountryTextField.doNotShowTheKeyboard()
        currentImageView.layer.cornerRadius = 35.0
        updatePhoneBtnOutlet.layer.cornerRadius = 20.0
        updateImageBtnOutlet.layer.cornerRadius = 20.0
    }
    
     //MARK:- Methods
    private func setupNavBar() {
        navigationItem.title = "Edit Account"
        rightBarBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChangesButton))
        //rightBarBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    private func getInputs() {
        if let _gender = gender, !_gender.isEmpty {
            editList["gender"] = _gender
        }
        
        if let job = newJobTextField.text, !job.isEmpty {
            editList["job"] = job
        }
        
        if let phone = newPhone, !phone.isEmpty {
            //editList["phone"] = phone
        }
        
        if let country = newCountryTextField.text, !country.isEmpty {
            editList["country"] = country
        }
        
        if let username = newUsernameTextField.text, !username.isEmpty {
            editList["username"] = username
        }
    }
    
     @objc private func saveChangesButton() {
        getInputs()
        Hud.showLoadingHud(onView: view, withLabel: "Updating...")
        meManager.editMyAccount(withData: editList) { (result) in
            Hud.hide(after: 0.0)
            switch result {
                case .success(let message):
                    self.presentDNAlertOnTheMainThread(title: "Success", Message: message.success)
                case .failure(let err):
                    self.presentDNAlertOnTheMainThread(title: "Failure", Message: err.localizedDescription)
            }
        }
    }
    
    
    @IBAction func updatePhoneBtnAction(_ sender: UIButton) {
        // take user to signInPhone
        let st = UIStoryboard(name: "Authentication", bundle: .main)
        let vc = st.instantiateViewController(identifier: "SignUpPhoneVCID") as? AddPhoneNumberVC
        vc?.updatePhoneDelegate = self
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
    
    @IBAction func updateImageBtnAction(_ sender: UIButton) {
        showPickerImageFromCameraOrPhotoLibraryAlertSheet()
    }
    
    private func presentPickerViewController(withType type: UIImagePickerController.SourceType) {
        let pickerImageVC = UIImagePickerController()
        pickerImageVC.delegate = self
        pickerImageVC.sourceType = type
        pickerImageVC.allowsEditing = true
        present(pickerImageVC, animated: true, completion: nil)
    }
    
    @IBAction func genderMaleBtnSelected(_ sender: UIButton) {
        gender = "Male"
    }
    
    @IBAction func genderFemaleBtnSelected(_ sender: UIButton) {
        gender = "Female"
    }
    
    
    private func toggleGender(to str: String) {
        if str == "Male" {
            genderMaleBtnOutlet.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            genderFemaleBtnOutlet.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            genderMaleBtnOutlet.setImage(UIImage(systemName: "circle"), for: .normal)
            genderFemaleBtnOutlet.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
    }
}


extension EditAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.currentImageView.image = pickedImage
            //guard let imageData   = pickedImage.pngData() else { return }
            //updateImageOnServer(imageData: imageData)
            let url = info[UIImagePickerController.InfoKey.imageURL] as! URL
            print("sssssS: \(url)")
            updateImageOnServer(imageURL: url, imageData: pickedImage.pngData()!)
            
        }else {
            // Error Message
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateImageOnServer(imageURL: URL, imageData: Data) {
        Hud.showLoadingHud(onView: view, withLabel: "upload image...")
//        ImageUploader.shared.uploadImage(requestURL: URL(string: "https://www.google.com")!, imageRequest: ImageRequest(attachment: imageData.base64EncodedString(), fileName: "userProfileImage")){ result in
//            Hud.hide(after: 0)
//            switch result {
//                case .success(let res):
//                print(res)
//                case .failure(_):
//                print("upload image failure")
//            }
//        }
        let urlString   = "https://dn-wallet.herokuapp.com/api/users/pic"
        let url         = URL(string: urlString)!
        
        var request     = URLRequest(url: url)
        let boundary = "--\(UUID().uuidString)"
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)\r\n", forHTTPHeaderField: "Content-Type")
        request.setValue(auth.getUserToken(), forHTTPHeaderField: "x-auth-token")
        
       var requestData = Data()
       requestData.append("--\(boundary)\r\n".data(using: .utf8)!)
//        //name=\"attachment\"
//       requestData.append("content-disposition; form-data; \r\n\r\n".data(using: .utf8)!)
       requestData.append(imageData)
//        //
//        requestData.append("--\(boundary)\r\n".data(using: .utf8)!)
//       requestData.append("content-disposition; form-data; name=\"fileName\" \r\n\r\n".data(using: .utf8)!)
//        requestData.append("userImage".data(using: .utf8)!)
//
    requestData.append("--\(boundary)\r\n".data(using: .utf8)!)
//
        request.addValue("\(requestData.count)", forHTTPHeaderField: "Content-Length")
        
        
        let task = URLSession.shared.uploadTask(with: request, fromFile: imageURL) { (data, response, error) in
            Hud.hide(after: 0)
            if let err = error {
                print("error in image uploading...\(err.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    print("success")
                    print(String(data: data!, encoding: .utf8))
                }else {
                    print("invalid status code : \(response.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    private func showPickerImageFromCameraOrPhotoLibraryAlertSheet() {
        let alert = UIAlertController(title: "Choose Method", message: "import image from", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.pickerSourceType = UIImagePickerController.SourceType.camera
        }
        let photoLibrary = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            self.pickerSourceType = UIImagePickerController.SourceType.photoLibrary
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
extension EditAccountVC: UpdatePhoneDelegate, PopUpMenuDelegate, UITextFieldDelegate {
    
    func selectedItem(title: String, code: String?) {
        newCountryTextField.text = title
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newCountryTextField {
            self.presentPopUpMenu(withCategory: .country, to: self)
            textField.endEditing(true)
        }
    }
    
    func newPhoneAndCountryInfo(phone: String, country: String) {
        self.newPhone = phone
        if let txt = self.currentCountry.text {
            if txt != country {  self.newCountry = country  }
        }
    }
}

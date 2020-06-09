//
//  EditAccountVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 6/4/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

struct UpdateAccount: Encodable {
    let username: String?
    let counrty: String?
    let gender: String?
    let job: String?
    let phone: String?
}

class EditAccountVC: UIViewController {

    // Properities
    private var gender: String? = nil {
        didSet {
            guard let txt = gender else { return }
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
    // Outlets
    //@IBOutlet weak var contentView: UIView!
    @IBOutlet weak var currentUsername: UILabel!
    @IBOutlet weak var newUsernameTextField: UITextField!
    @IBOutlet weak var currentCountry: UILabel!
    @IBOutlet weak var newCountryTextField: UITextField!
    @IBOutlet weak var currentPhone: UILabel!
    @IBOutlet weak var currentImageView: UIImageView!
    @IBOutlet weak var currentJob: UILabel!
    @IBOutlet weak var newJobTextField: UITextField!
    @IBOutlet weak var currentGender: UILabel!
    @IBOutlet weak var genderMaleBtnOutlet: UIButton!
    @IBOutlet weak var genderFemaleBtnOutlet: UIButton!
    @IBOutlet weak var updatePhoneBtnOutlet: UIButton!
    @IBOutlet weak var updateImageBtnOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupNavBar()
    }
    
    private func initView() {
        newCountryTextField.delegate = self
        currentImageView.layer.cornerRadius = 35.0
        updatePhoneBtnOutlet.layer.cornerRadius = 20.0
        updateImageBtnOutlet.layer.cornerRadius = 20.0
    }
    
    private func setupNavBar() {
        navigationItem.title = "Edit Account"
        rightBarBtn = UIBarButtonItem(title: "Save Changes", style: .plain, target: self, action: #selector(saveChangesButton))
        //rightBarBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    /*
     {
        "username" : "ahmed eid"
        "country" : "Egypt",
        "job": "Developer",
        "phone": "0154548784"
        "gender": "male"
     }
     // update image
     
     **/
    
     @objc private func saveChangesButton() {
        let newValue = UpdateAccount(username: newUsername, counrty: newCountry, gender: gender, job: newJob, phone: newPhone)
        print(newValue)
    }
    
    
    @IBAction func updatePhoneBtnAction(_ sender: UIButton) {
        // take user to signInPhone
        let st = UIStoryboard(name: "Authentication", bundle: .main)
        let vc = st.instantiateViewController(identifier: "SignUpPhoneVCID") as? SignUpPhoneVC
        vc?.updateState = true
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
        gender = "male"
    }
    
    @IBAction func genderFemaleBtnSelected(_ sender: UIButton) {
        gender = "female"
    }
    
    
    private func toggleGender(to str: String) {
        if str == "male" {
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
        }else {
            // Error Message
        }
        picker.dismiss(animated: true, completion: nil)
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
            let vc = PopUpMenu()
            vc.menuDelegate = self
            vc.dataSource = .country
            self.present(vc, animated: true, completion: nil)
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






























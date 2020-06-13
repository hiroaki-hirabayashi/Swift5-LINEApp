//
//  SignupViewController.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/11.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

//ログイン画面
class SignupViewController: UIViewController {

    //プロフィール画像
    @IBOutlet weak var profileImageButton: UIButton!
    //メールアドレス
    @IBOutlet weak var emailTextField: UITextField!
    //パスワード
    @IBOutlet weak var passwordTextField: UITextField!
    //名前
    @IBOutlet weak var userNameTextField: UITextField!
    //登録
    @IBOutlet weak var registerButton: UIButton!
    //すでにアカウントを持っている方
    @IBOutlet weak var alreadyHaveAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageButton.layer.cornerRadius = 85
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        registerButton.layer.cornerRadius = 12
        
        profileImageButton.addTarget(self, action: #selector(tapedProfileImageButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)

        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        
       
        registerButton.isEnabled = false
        registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
    }
    
    //プロフィール画像を押すと写真にアクセスする
    @objc func tapedProfileImageButton() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        //写真を拡大したり位置を変えたり編集できるようにする
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    //画像をFirestorageに保存する
    @objc private func tappedRegisterButton() {
        //nilではない時、処理を進める
        guard let image = profileImageButton.imageView?.image else { return }
        //jpegに置き換えてサイズを変更する
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child("fileName")
        
        storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました。\(err)")
                return
            }
            
            print("Firestorageへの情報の保存に成功しました。")
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("Firestorageからのダウンロードに失敗しました。\(err)")
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                self.createUserToFirestore(profileImageUrl: urlString)
      
            }
            
        }
        
    }
    

    //登録ボタンが押されたときの処理(FirestoreのAuthに登録する)
    func createUserToFirestore(profileImageUrl: String) {
        //nilではない時、処理を進める
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました。\(err)")
                return
            }
            print("認証情報の保存に成功しました。")
            
            guard let uid = res?.user.uid else { return }
            guard let username = self.userNameTextField.text else { return }
            let docData = [
                "email": email,
                "username": username,
                "createdAt": Timestamp(),
                "profileImageUrl": profileImageUrl
                ] as [String: Any]
            
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("Firestoreへの保存に失敗しました。\(err)")
                    return
                }
                
                print("Firestoreへの情報の保存が成功しました。")
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
}
    
  


    extension SignupViewController: UITextFieldDelegate {
        
        //いつ登録ボタンが押せるようになるか
        func textFieldDidChangeSelection(_ textField: UITextField) {
            let emailIsEmpty = emailTextField.text?.isEmpty ?? false
            let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
            let usernameIsEmpty = userNameTextField.text?.isEmpty ?? false
            
            //textfieldのどれか一つでも空なら登録ボタンは押せない
            if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
                registerButton.isEnabled = false
                registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
            } else {
                registerButton.isEnabled = true
                registerButton.backgroundColor = .rgb(red: 0, green: 185, blue: 0)
            }
        }
        
    }
    
    extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        //写真を選択した後の処理
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            //もしinfo[.editedImage]がnilじゃなかったら
            //editImage=編集した画像　originalImage=そのままの画像
            if let editImage = info[.editedImage] as? UIImage {
                profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
            } else if let originalImage = info[.originalImage] as? UIImage {
                profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            //画像を枠にはめる
            profileImageButton.setTitle("", for: .normal)
            profileImageButton.imageView?.contentMode = .scaleAspectFill
            profileImageButton.contentHorizontalAlignment = .fill
            profileImageButton.contentVerticalAlignment = .fill
            profileImageButton.clipsToBounds = true
            
            dismiss(animated: true, completion: nil)
        }
        
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
}




    



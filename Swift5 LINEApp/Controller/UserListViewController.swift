//
//  UserListViewController.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/13.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Nuke

//新規チャット開始画面
class UserListViewController: UIViewController {
    
    let cellId = "cellId"
    var users = [User]()
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var chatStartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userListTableView.delegate = self
        userListTableView.dataSource = self
        chatStartButton.layer.cornerRadius = 15
        navigationController?.navigationBar.tintColor = .rgb(red: 39, green: 49, blue: 69)
        
        fetchUserInfoFromFirestore()
    }
    
    //Firestoreからユーザー情報を取得
    func fetchUserInfoFromFirestore() {
        
        Firestore.firestore().collection("users").getDocuments { (snapShots, err) in
            if let err = err {
                print("user情報の取得に失敗しました。\(err)")
                return
            }
            
            snapShots?.documents.forEach({ (snapShot) in
                let dic = snapShot.data()
                let user = User.init(dic: dic)
                
                //ログイン済みのユーザーはListに載せない
                guard let uid = Auth.auth().currentUser?.uid else { return }
                if uid == snapShot.documentID {
                    return
                }
                //それ以外は追加(Listに乗せる)
                self.users.append(user)
                self.userListTableView.reloadData()
                
            })
        }
    }
    
}


extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    //セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    //セルを生成して値を渡す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserListTableViewCell
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    
    
    
}

//ユーザー選択画面のセル
class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLable: UILabel!
    //Firestoreから取得したユーザー情報をセットする
    var user: User? {
        didSet {
            userNameLable.text = user?.username
            if let url = URL(string: user?.profileImageUrl ?? "") {
                Nuke.loadImage(with: url, into: userImageView)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 25
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}










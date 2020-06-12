//
//  ChatListViewController.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/05.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //TableViewCellのIdentifire
    let cellId = "cellId"
    var users = [User]()

    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //chatListTableViewの設定に必要
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        //ナビゲーションバーの色をオリジナルに変更(UIColorExtension.swift),タイトルの文字色を白くする
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        navigationItem.title = "トーク"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        //ここまで
        
        //ログイン済みのユーザーはログイン画面をスキップ
        if Auth.auth().currentUser?.uid == nil {
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signupViewController = storyboard.instantiateViewController(withIdentifier: "SignupViewController")
            signupViewController.modalPresentationStyle = .fullScreen
            self.present(signupViewController, animated: true, completion: nil)
        }
        
//        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
//        let nextVC = storyboard.instantiateViewController(withIdentifier: "SignupViewController")
//        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserInfoFromFirestore()

    }
    
    func fetchUserInfoFromFirestore() {
        
        Firestore.firestore().collection("users").getDocuments { (snapShots, err) in
            if let err = err {
                print("user情報の取得に失敗しました。\(err)")
                return
            }
            
            snapShots?.documents.forEach({ (snapShot) in
                let dic = snapShot.data()
                let user = User.init(dic: dic)
                
                self.users.append(user)
                self.chatListTableView.reloadData()
                
                self.users.forEach { (user) in
                    print("user.username: ", user.username)

                }

            })
        }
        
    }
    
    //     セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    // セルの行数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }
    
    // セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    //タップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatRoomViewController = storyboard!.instantiateViewController(withIdentifier: "ChatRoomViewController")
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        
    }
    
}

class ChatListTableViewCell: UITableViewCell {
  
    //ユーザーアイコン
    @IBOutlet weak var userImageView: UIImageView!
    //名前
    @IBOutlet weak var partnerLabel: UILabel!
    //最後のメッセージ
    @IBOutlet weak var latestMessageLabel: UILabel!
    //日時
    @IBOutlet weak var dateLabel: UILabel!
    
    var user: User? {
        didSet {
            if let user = user {
                partnerLabel.text = user.username
                
                //            userImageView.image = user?.profileImageUrl
                dateLabel.text = dateFormatterForDateLabel(date: user.createdAt.dateValue())
                latestMessageLabel.text = user.email
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //ユーザーアイコンを角丸にする
        userImageView.layer.cornerRadius = 35
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}


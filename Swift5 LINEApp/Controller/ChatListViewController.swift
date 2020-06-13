//
//  ChatListViewController.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/05.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

//メッセージやり取り済みのユーザー選択画面
class ChatListViewController: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    //TableViewCellのIdentifire
    let cellId = "cellId"
    var user: User? {
        didSet {
            navigationItem.title = user?.username
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        confirmLoggedInUser()
        fetchLoginUserInfo()
    }
    
    
    func setupView() {
        //chatListTableViewの設定に必要
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        //ナビゲーションバーの色をオリジナルに変更(UIColorExtension.swift),タイトルの文字色を白くする
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        navigationItem.title = "トーク"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        //ここまで
        
        //新規チャット開始ボタン tappedNavRightBarButtonは押されたときの処理
        let rigntBarButton = UIBarButtonItem(title: "新規チャット", style: .plain, target: self, action: #selector(tappedNavRightBarButton))
        navigationItem.rightBarButtonItem = rigntBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        //        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        //        let nextVC = storyboard.instantiateViewController(withIdentifier: "SignupViewController")
        //        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func tappedNavRightBarButton() {
        let storyboard = UIStoryboard.init(name: "UserList", bundle: nil)
        let userListViewController = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        let nav = UINavigationController(rootViewController: userListViewController)
        self.present(nav, animated: true, completion: nil)
    }
    
    //ログイン済みのユーザーはログイン画面をスキップ
    func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil {
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signupViewController = storyboard.instantiateViewController(withIdentifier: "SignupViewController")
            signupViewController.modalPresentationStyle = .fullScreen
            self.present(signupViewController, animated: true, completion: nil)
        }
    }
    
    //ログイン中のユーザーを表示
    func fetchLoginUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
                return
            }
            
            guard let snapshot = snapshot, let dic = snapshot.data() else { return }
            
            let user = User(dic: dic)
            self.user = user
        }
    }
    
}
    
    extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
        
        //     セルの高さを設定
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
        
        // セルの行数を返すメソッド
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 0
        }
        
        // セルの内容を返すメソッド
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell
//            cell.user = users[indexPath.row]
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
            //プロパティーの値セットを検知する仕組み?
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
        
        //時刻の取得
        func dateFormatterForDateLabel(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: "ja_JP")
            return formatter.string(from: date)
        }
        
    
    
}

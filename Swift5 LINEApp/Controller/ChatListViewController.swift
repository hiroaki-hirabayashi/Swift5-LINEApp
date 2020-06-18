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
import FirebaseAuth
import Nuke

//メッセージの履歴の画面　メッセージやり取り済み
class ChatListViewController: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    //TableViewCellのIdentifire
    let cellId = "cellId"
    var chatRooms = [ChatRoom]()
    //ログイン中のユーザー名を表示
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
        fetchChatroomsInfoFromFirestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //新規会話開始ボタンが押された時、押されたユーザー情報を取得
    func fetchChatroomsInfoFromFirestore() {
        Firestore.firestore().collection("chatRooms").addSnapshotListener { (snapshots, err) in
            
        
            
//            .getDocuments { (snapshots, err) in
            if let err = err {
                print("ChatRooms情報の取得に失敗しました。\(err)")
                return
            }
            
            //新しく追加されたデータのみ取得する(同じデータが追加されてしまう為)
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    self.handleAddedDocumentChange(documentChange: documentChange)
                    
                case .modified, .removed:
                    print("")
                    
                }
            })
            
        }
    }
    
    func handleAddedDocumentChange(documentChange: DocumentChange) {
        let dic = documentChange.document.data()
        let chatrooms = ChatRoom(dic: dic)
        
        //メンバーのuidを調べ、自分のuidではない時、情報を取得する
        guard let uid = Auth.auth().currentUser?.uid else { return }
        chatrooms.memebers.forEach { (memberUid) in
            if memberUid != uid {
                Firestore.firestore().collection("users").document(memberUid).getDocument { (snaoshot, err) in
                    if let err = err {
                        print("ユーザー情報の取得に失敗しました。\(err)")
                        return
                    }
                    guard let dic = snaoshot?.data() else { return }
                    let user = User(dic: dic)
                    user.uid = documentChange.document.documentID
                    
                    chatrooms.partnerUser = user
                    self.chatRooms.append(chatrooms)
                    print(self.chatRooms.count)
                    self.chatListTableView.reloadData()
                }
            }
        }
        
    }
    
    func setupView() {
        //chatListTableViewの設定に必要
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.tableFooterView = UIView()
        
        //ナビゲーションバーの色をオリジナルに変更(UIColorExtension.swift),タイトルの文字色を白くする
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        navigationItem.title = "トーク"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        //ここまで
        
        //新規チャット開始ボタン tappedNavRightBarButtonは押されたときの処理
        let rigntBarButton = UIBarButtonItem(title: "新規チャット", style: .plain, target: self, action: #selector(tappedNavRightBarButton))
        navigationItem.rightBarButtonItem = rigntBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        let leftBarButton = UIBarButtonItem(title: "ログイン画面へ", style: .plain, target: self, action: #selector(tappedNavLeftBarButton))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        //        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        //        let nextVC = storyboard.instantiateViewController(withIdentifier: "SignupViewController")
        //        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func tappedNavRightBarButton() {
        let storyboard = UIStoryboard.init(name: "UserList", bundle: nil)
        let userListViewController = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        let nav = UINavigationController(rootViewController: userListViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
   
    @objc func tappedNavLeftBarButton() {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signupViewController = storyboard.instantiateViewController(withIdentifier: "SignupViewController")
        signupViewController.modalPresentationStyle = .fullScreen
        self.present(signupViewController, animated: true, completion: nil)
         
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
    
    //今現在ログイン中のユーザー情報を取得
    func fetchLoginUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //該当のユーザーを取得する
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
            return chatRooms.count
        }
        
        // セルの内容を返すメソッド
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell
            cell.chatRoom = chatRooms[indexPath.row]

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
//
//        var user: User? {
//            //プロパティーの値セットを検知する仕組み?
//            didSet {
//                if let user = user {
//                    partnerLabel.text = user.username
//
//                    //            userImageView.image = user?.profileImageUrl
//                    dateLabel.text = dateFormatterForDateLabel(date: user.createdAt.dateValue())
//                    latestMessageLabel.text = user.email
//                }
//            }
//        }
        //取得した情報をセルに反映する
        var chatRoom: ChatRoom? {
            didSet {
                if let chatroom = chatRoom {
                    partnerLabel.text = chatroom.partnerUser?.username
                    
                    guard let url = URL(string: chatroom.partnerUser?.profileImageUrl ?? "") else { return }
                    Nuke.loadImage(with: url, into: userImageView)
                    
                    dateLabel.text = dateFormatterForDateLabel(date: chatroom.createdAt.dateValue())
                    
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

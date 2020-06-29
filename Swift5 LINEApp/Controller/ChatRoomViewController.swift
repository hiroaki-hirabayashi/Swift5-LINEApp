//
//  ChatRoomViewController.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/06.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

//メッセージ表示画面

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    let cellId = "cellId"
    var sendMessage = [String]()
    
    var chatroom: ChatRoom?
    var user: User?
    //chatInputAccessoryView(メッセージ入力欄)のインスタンス作成
    lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        //chatInputAccessoryViewのdelegate
        view.delegate = self
        return view
    }()
    //ここまで
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        
        //cellの再利用,用意したviewをcellのテンプレートとして登録する
//        chatRoomTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        //↑一例
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        chatRoomTableView.backgroundColor = .rgb(red: 118, green: 140, blue: 180)
        
    }
    
    //inputAccessoryViewにChatInputAccessoryViewを貼り付け、更に自動的にtextfildを上げ下げしてくれる
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
}

  
extension ChatRoomViewController: ChatInputAccessoryViewDelegate {
    
    //chatInputAccessoryViewのtapedSendButtonの値(delegate)を受け取る
    func tapedSendButton(text: String) {
        
//        sendMessage.append(text)
//        //        chatInputAccessoryView.chatTextView.text = ""
//        chatRoomTableView.reloadData()
        guard let chatroomDocId = chatroom?.documentId else { return }
        guard let name = user?.username else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        chatInputAccessoryView.removeText()

        let docData = [
            "name": name,
            "createdAT": Timestamp(),
            "uid": uid,
            "message": text,
        
            ] as [String : Any]
        Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("message").document().setData(docData) { (error) in
            if let error = error {
                print("メッセージの受信に失敗しました。\(error)")
                return
            }
        }
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    //     セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //セルの最低基準の高さ
        chatRoomTableView.estimatedRowHeight = 20
        //TextView(送受信したメッセージ)の長さを優先してセルの高さが変わる
        return UITableView.automaticDimension
    }
    
    //セルを表示する数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sendMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatRoomTableViewCell//ChatRoomTableViewCellにアクセスする
        //        cell.messageTextView.text = sendMessage[indexPath.row]
        //        cell.backgroundColor = .purple
        cell.constraintText = sendMessage[indexPath.row]
        return cell
    }
    
}


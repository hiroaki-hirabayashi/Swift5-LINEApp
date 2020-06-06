//
//  ChatListViewController.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/05.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //TableViewCellのIdentifire
    private let cellId = "cellId"
    
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //chatListTableViewの設定に必要
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
    }
    
    //     セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    // セルの行数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    // セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //ユーザーアイコンを角丸にする
        userImageView.layer.cornerRadius = 35
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


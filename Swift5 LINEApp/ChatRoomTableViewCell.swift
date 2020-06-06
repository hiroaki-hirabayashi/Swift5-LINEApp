//
//  ChatRoomTableViewCell.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/07.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell{
    
    @IBOutlet weak var userImageView: UIImageView!
    
    //↓　scroding、Behavlorのチェックを外す
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //背景を透明にする
//        backgroundColor = .clear
        //
        userImageView.layer.cornerRadius = 20
        messageTextView.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super .setSelected(selected, animated: animated)
        
    }
}

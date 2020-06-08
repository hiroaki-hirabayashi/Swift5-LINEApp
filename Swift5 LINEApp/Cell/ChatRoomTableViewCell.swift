//
//  ChatRoomTableViewCell.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/07.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

//表示メッセージの形のテンプレート

import UIKit

class ChatRoomTableViewCell: UITableViewCell{
    
    @IBOutlet weak var userImageView: UIImageView!
    
    //↓　scroding、Behavlorのチェックを外す
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    
    var constraintText: String? {
        didSet{
            guard let text = constraintText else {return}
            let width = estimateFrameForTextView(text: text).width + 20
            messageTextViewWidthConstraint.constant = width
            messageTextView.text = text
        }
    }
    
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
    
    func estimateFrameForTextView(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
    }
}

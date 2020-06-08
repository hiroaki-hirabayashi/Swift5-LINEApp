//
//  ChatInputAccessoryView.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/07.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

//メッセージ入力、送信

import UIKit

protocol ChatInputAccessoryViewDelegate: class {
    func tapedSendButton(text: String)
}

class ChatInputAccessoryView: UIView, UITextViewDelegate {
    
    
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    weak var delegate: ChatInputAccessoryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nibInit()
        setupView()
        //可変にするための必要なもの
        autoresizingMask = .flexibleHeight
    }
    
    //textfildを可変にする　scroolのチェックを外す
    override var intrinsicContentSize: CGSize {
        
        return .zero
    }
    
    //textfileと送信ボタンの調整
    func setupView() {
        
        chatTextView.layer.cornerRadius = 15
        chatTextView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        chatTextView.layer.borderWidth = 1
        chatTextView.isEditable = true
        chatTextView.text = ""
        chatTextView.delegate = self
        
        sendButton.layer.cornerRadius = 15
        sendButton.imageView?.contentMode = .scaleAspectFill
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.isEnabled = false
        
    }
   
    //textfildの貼り付け
    func nibInit() {
        
        let nib = UINib(nibName: "ChatInputAccessoryView", bundle: nil)
        
        //初期化？
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        
        //可変にする
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //textViewの状態
    //送信ボタンを押せるときの設定
    func textViewDidChange(_ textView: UITextView) {
        
        print("textView.text", textView.text)
        
        if textView.text.isEmpty {
            
            sendButton.isEnabled = false
            
        } else {
            
            sendButton.isEnabled = true
            
        }
    }
    
    @IBAction func tapedSendButton(_ sender: Any) {
        
        guard let text = chatTextView.text else {return}
        delegate?.tapedSendButton(text: text)
    }
    
    func removeText() {
        
        chatTextView.text = ""
        sendButton.isEnabled = false
        
    }
    
}

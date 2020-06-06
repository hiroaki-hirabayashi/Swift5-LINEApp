//
//  ChatRoomViewController.swift
//  Swift5 LINEApp
//
//  Created by 平林宏淳 on 2020/06/06.
//  Copyright © 2020 Hiroaki_Hirabayashi. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    let cellId = "cellId"
    
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
    
    //     セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //セルの最低基準の高さ
        chatRoomTableView.estimatedRowHeight = 20
        //TextView(送受信したメッセージ)の長さを優先してセルの高さが変わる
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return 10
        
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//        cell.backgroundColor = .purple
        return cell
        
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

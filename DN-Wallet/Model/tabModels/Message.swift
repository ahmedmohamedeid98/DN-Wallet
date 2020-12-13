//
//  Notification.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 5/25/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct Message {
    let sender: String
    let body: String
    let date: String
    let type: String
    let isnew: Bool
    
    static func fetchMessages() -> [Message]{
        let msg1 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
        let msg2 = "when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        let msg3 = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English."
        let mess = [
            Message(sender: "A@gamil.com", body: msg1, date: "25-7-2015 14:05:00", type: "Send", isnew: true),
            Message(sender: "DN-Wallet", body: msg2, date: "11-2-2020 13:05:00", type: "Info", isnew: true),
            Message(sender: "A@gamil.com", body: msg3, date: "25-7-2015 14:05:00", type: "Send", isnew: false),
            Message(sender: "DN-Wallet", body: msg2, date: "11-2-2020 13:05:00", type: "Info", isnew: false),
            Message(sender: "A@gamil.com", body: msg1, date: "25-7-2015 14:05:00", type: "Send", isnew: false),
            Message(sender: "DN-Wallet", body: msg2, date: "11-2-2020 13:05:00", type: "Info", isnew: false)
        ]
        return mess
    }
}

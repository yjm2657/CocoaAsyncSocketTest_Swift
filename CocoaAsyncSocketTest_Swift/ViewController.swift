//
//  ViewController.swift
//  CocoaAsyncSocketTest_Swift
//
//  Created by YJM on 2017/9/1.
//  Copyright © 2017年 YJM. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController,GCDAsyncSocketDelegate {
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    var serverSocket: GCDAsyncSocket?
    var clientSocket: GCDAsyncSocket?
    
    
    
    @IBAction func listening(_ sender: UIButton) {
        serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do{
            try serverSocket?.accept(onPort: UInt16(portTextField.text!)!)
            addTextToTextView(text: "监听成功")
        }catch _ {
            addTextToTextView(text: "监听失败")
        }
        
    }
    @IBAction func sendBtnClick(_ sender: UIButton) {
        let data = messageTextField.text?.data(using: String.Encoding.utf8)
        //向客户端写入信息 timeout设置为-1 则不会超时， tag作为两边一样的标示
        clientSocket?.write(data!, withTimeout: -1, tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func addTextToTextView(text: String) {
        infoTextView.text = infoTextView.text.appendingFormat("%@\n", text)
    }
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        addTextToTextView(text: "连接成功")
        addTextToTextView(text: "连接地址" + newSocket.connectedHost!)
        addTextToTextView(text: "端口号" + String(newSocket.connectedPort))
        clientSocket = newSocket
        
        //第一次开始读取data
        clientSocket!.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let message = String(data: data, encoding: .utf8)
        addTextToTextView(text: message!)
        //再次准备读取data，以此来循环大区data
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ClientViewController.swift
//  CocoaAsyncSocketTest_Swift
//
//  Created by YJM on 2017/9/1.
//  Copyright © 2017年 YJM. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ClientViewController: UIViewController,GCDAsyncSocketDelegate {

    @IBOutlet weak var IPTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    var socket: GCDAsyncSocket?
    
    
    @IBAction func connectBtnClick(_ sender: UIButton) {
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            try socket?.connect(toHost: IPTextField.text!, onPort: UInt16(portTextField.text!)!)
            addTextToTextView(text: "连接成功")
        } catch _ {
            addTextToTextView(text: "连接失败")
        }
        
    }
    @IBAction func disconnectBtnClick(_ sender: UIButton) {
        socket?.disconnect()
        addTextToTextView(text: "断开连接")
    }
    @IBAction func sendBtnclick(_ sender: UIButton) {
        socket?.write((messageTextField.text?.data(using: .utf8))!, withTimeout: -1, tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addTextToTextView(text: String) {
        infoTextView.text = infoTextView.text.appendingFormat("%@\n", text)
    }
    
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        addTextToTextView(text: "连接服务器" + host)
        self.socket?.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let msg = String(data: data, encoding: .utf8)
        addTextToTextView(text: msg!)
        socket?.readData(withTimeout: -1, tag: 0)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

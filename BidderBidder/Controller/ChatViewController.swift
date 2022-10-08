//
//  ChatViewController.swift
//  BidderBidder
//
//  Created by 김한빈 on 2022/09/22.
//

import StreamChat
import UIKit

class ChatViewController: UIViewController {
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTableView: UITableView!

    var chatClient: ChatClient!
    var channelController: ChatChannelController!
    var messageLog: [String] = []
    var userId: String!
    let channelId = ChannelId(type: .messaging, id: "bidderbidderTest")
    let chatLogCell = "chatLogCell"

    override func viewDidLoad() {
        messageTextField.isHidden = true
        sendButton.isHidden = true
    }

    @IBAction func login(_: Any) {
        loginButton.isHidden = true
        userIdTextField.isHidden = true

        messageTextField.isHidden = false
        sendButton.isHidden = false
        userId = userIdTextField.text!

        sendRestRequest(url: Constant.domainURL + "/chat/token/" + userId, params: nil, isPost: false) { [self]
            response in
                switch response.result {
                case let .success(data):
                    let token =
                        try? Token(rawValue: String(data: data!, encoding: .utf8)!)

                    let config = ChatClientConfig(apiKey: .init(Secrets.chatApiKey))
                    chatClient = ChatClient(config: config)
                    chatClient.connectUser(
                        userInfo: .init(id: userId),
                        token: token!
                    ) { error in
                        if let error = error {
                            print("Connection failed with: \(error)")
                        } else {
                            self.createChannel()
                        }
                    }
                case .failure: break
                }
        }
    }

    @IBAction func sendMessage(_: Any) {
        let message = messageTextField.text!
        if message.isEmpty {
            return
        }
        messageTextField.text = ""
        channelController.createNewMessage(text: message) { [self] result in
            switch result {
            case .success:
                refreshMessageTableView()

            case let .failure(error):
                print(error)
            }
        }
    }

    func createChannel() {
        channelController = chatClient.channelController(for: channelId)

        channelController.synchronize { error in
            if let error = error {
                print(error)
            }
        }
        channelController.acceptInvite()
        channelController.delegate = self
    }

    func refreshMessageTableView() {
        messageTableView.reloadData()
        DispatchQueue.main.async { [self] in
            let indexPath = IndexPath(row: messageLog.count - 1, section: 0)
            messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ChatViewController: UITableViewDelegate { // 요건 지금 당장 사용하진 않지만 혹시나 해서 넣어뒀습니다
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        messageLog.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatLogCell)!
        let message = messageLog[indexPath.row]
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = message
            cell.contentConfiguration = content
        } else {
            // 기존과 동일(iOS 14.0 까지만 지원)
            cell.textLabel?.text = message
        }
        cell.selectionStyle = .none // 셀 선택시 회색으로 선택 표시해주는거 없애기

        return cell
    }
}

extension ChatViewController: ChatChannelControllerDelegate {
    func channelController(_: ChatChannelController, didUpdateMessages messages: [ListChange<ChatMessage>]) {
        for message in messages {
            if message.isInsertion {
                messageLog.append(message.item.text)
            }
        }
        refreshMessageTableView()
    }
}

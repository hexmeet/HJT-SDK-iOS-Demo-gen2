//
//  JoinMeetingVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class JoinMeetingVC: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var meetIdTF: UITextField!
    @IBOutlet weak var joinMeetingBtn: UIButton!
    @IBOutlet weak var cameraSwitch: UISwitch!
    @IBOutlet weak var microphoneSwitch: UISwitch!
    @IBOutlet weak var hiddenHistoryTabBtn: EnlargeEdgeButton!
    @IBOutlet weak var tabBg: UIView!
    @IBOutlet weak var tab: UITableView!
    @IBOutlet weak var tabHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyBoardView: UIView!
    @IBOutlet var keyBoardBtn: [UIButton]!
    
    let histroyArr = NSMutableArray.init(capacity: 1)
    var indexCursor: NSInteger = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSwitchState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        meetIdTF.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        for btn in keyBoardBtn {
            btn.backgroundColor = UIColor.white
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet.init(charactersIn: NUM).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return string == filtered
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histroyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCallCell") as? HistoryCallCell
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("HistoryCallCell", owner: self, options: nil)?.first as? UITableViewCell) as? HistoryCallCell
        }
        cell?.callNumberLb.text = "\(histroyArr[indexPath.row])"
        cell?.line.isHidden = indexPath.row == histroyArr.count-1 ? true : false
        cell?.deleteBtn.addTarget(self, action: #selector(removeHistoryCall(_:)), for: .touchUpInside)
        cell?.deleteBtn.tag = indexPath.row
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        meetIdTF.text = "\(histroyArr[indexPath.row])"
        tab.isHidden = true
        tabBg.isHidden = true
    }
}

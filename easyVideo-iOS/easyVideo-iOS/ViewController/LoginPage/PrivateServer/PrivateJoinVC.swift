//
//  PrivateJoinVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class PrivateJoinVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ManagerDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var serverTF: UITextField!
    @IBOutlet weak var meetingNumberTF: LimitTextField!
    @IBOutlet weak var nameTF: LimitTextField!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var micPhoneBtn: UIButton!
    @IBOutlet weak var advancedSetBtn: UIButton!
    @IBOutlet weak var hiddenHistoryTabBtn: EnlargeEdgeButton!
    @IBOutlet weak var tabBg: UIView!
    @IBOutlet weak var tab: UITableView!
    @IBOutlet weak var tabHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgHeightConstraint: NSLayoutConstraint!
    
    let histroyArr = NSMutableArray.init(capacity: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Manager.shared().addDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gethistroyCallNumber()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Manager.shared().removeDelegate(self)
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
        meetingNumberTF.text = "\(histroyArr[indexPath.row])"
        tab.isHidden = true
        tabBg.isHidden = true
    }
    
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet.init(charactersIn: NUM).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return string == filtered
    }
    
    // MARK: ManagerDelegate
    func onError(forMg err: EVError) {
        onError_(forMg: err)
    }
    
}

//
//  VideoVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/15.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension VideoVC {
    func initContent() {
        self.view.backgroundColor = UIColor.black
        
        let btnArr:[UIButton] = [exitVoiceModeBtn, signalBtn, switchCameraBtn, hangUpBtn, selectBtn, operateLocalVideoBtn, speechBtn, switchAudioBtn, modifyNameBtn, muteBtn, operateCameraBtn, meetingMGBtn, chatBtn, layoutChangeBtn, moreBtn, closeWebBtn, closeStatisticalBtn]
        
        for btn in btnArr {
            btn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        remoteList = [one, two, three, four]
        
        one.videoStateView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        two.videoStateView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        three.videoStateView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        four.videoStateView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        local.videoStateView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        local.setLocalBorderColor()
        
        // MG Page
        conferenceVC = ConferenceVC()
        webBg.addSubview(conferenceVC!.view)
        webBg.bringSubviewToFront(closeWebBtn)
        
        // Statistical Page
        statisticalVC = StatisticalVC()
        statisticalBg.addSubview(statisticalVC!.view)
        statisticalBg.bringSubviewToFront(closeStatisticalBtn)
        
        moreMenuView.setLayer(true, 4, nil, nil)
        
        creatGesturesForHiddenToolBar()
        
        creatGesturesForMoveWindow()
        
        initializeProperty()
        
        creatMessageView()
        
        setBottomConstraint(videoModel)
        
    }
    
    func initializeProperty() {
        contentMenuView.setLayer(true, 8, nil, nil)
        
        selectBtn.isSelected = false
        
        moreView.setLayer(true, 4, nil, nil)
        
        alertView.addObserver(self, forKeyPath: "hidden", options: [.new, .old], context: nil)
        alertView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        alertView.setLayer(true, 4, nil, nil)
        
        leftLb.backgroundColor = UIColor.init(formHexString: "0x5880F7")
        rightLb.backgroundColor = UIColor.white
        leftLb.textColor = UIColor.white
        rightLb.textColor = UIColor.black
        
        recordingView.setLayer(true, 3, nil, nil)
        recordingImg.setLayer(true, 7, nil, nil)
        recordingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        speakerView.setLayer(true, 3, nil, nil)
        speakerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func creatMessageView() {
        messageLb = UILabel(frame: CGRect(x: 0, y: 0, width: videoBg.width, height: 40))
        messageLb?.font = UIFont.systemFont(ofSize: 13)
        messageLb?.textColor = UIColor.white
        messageLb?.backgroundColor = UIColor.clear
        messageView.addSubview(messageLb!)
        
        staticLb = UILabel(frame: CGRect(x: 0, y: 0, width: videoBg.width, height: 40))
        staticLb?.font = UIFont.systemFont(ofSize: 13)
        staticLb?.textColor = UIColor.white
        staticLb?.backgroundColor = UIColor.clear
        messageView.addSubview(staticLb!)
    }
    
    func setBottomConstraint(_ type: VideoModeType) {
        if type == .audioMode {
            audioBg.isHidden = false
            exitVoiceModeBtn.isHidden = false
            moreMenuView.isHidden = false
            switchCameraBtn.isHidden = true
            switchCameraLb.isHidden = true
            operateCameraView.isHidden = true
            moreView.isHidden = false
            moreMenuView.isHidden = true
            layoutChangeView.isHidden = true
            
            if getFeatureSupportParameter(chatInConference) {
                let buttonWidth = Float(80)
                let offset = Float((meanBg.width-320)/5)
                
                muteConstraint.constant = CGFloat(offset)
                meetingMGConstraint.constant = CGFloat(offset*2 + buttonWidth)
                chatConstraint.constant = CGFloat(offset*3 + buttonWidth*2)
                moreConstraint.constant = CGFloat(offset*4 + buttonWidth*3)
            }else {
                let buttonWidth = Float(80)
                let offset = Float((meanBg.width-240)/4)
                
                muteConstraint.constant = CGFloat(offset)
                meetingMGConstraint.constant = CGFloat(offset*2 + buttonWidth)
                moreConstraint.constant = CGFloat(offset*3 + buttonWidth*2)
            }
            
            appDelegate.evengine.setVideoActive(0)
            
            DDLogWrapper.logInfo("setVideoActive 0")
        }else if type == .videoMode {
            audioBg.isHidden = true
            exitVoiceModeBtn.isHidden = true
            operateCameraView.isHidden = false
            switchCameraBtn.isHidden = false
            switchCameraLb.isHidden = false
            layoutChangeView.isHidden = false
            moreView.isHidden = false
            
            switchAudioBtn.setTitle("video.audiomode".localized, for: .normal)
            
            if getFeatureSupportParameter(chatInConference) {
                let buttonWidth = Float(80)
                let offset = Float((meanBg.width-480)/7)
                
                muteConstraint.constant = CGFloat(offset)
                operateCameraConstraint.constant = CGFloat(offset*2 + buttonWidth)
                meetingMGConstraint.constant = CGFloat(offset*3 + buttonWidth*2)
                chatConstraint.constant = CGFloat(offset*4 + buttonWidth*3)
                layoutChangeConstraint.constant = CGFloat(offset*5 + buttonWidth*4)
                moreConstraint.constant = CGFloat(offset*6 + buttonWidth*5)
            }else {
                let buttonWidth = Float(80)
                let offset = Float((meanBg.width-400)/6)
                
                muteConstraint.constant = CGFloat(offset)
                operateCameraConstraint.constant = CGFloat(offset*2 + buttonWidth)
                meetingMGConstraint.constant = CGFloat(offset*3 + buttonWidth*2)
                layoutChangeConstraint.constant = CGFloat(offset*4 + buttonWidth*3)
                moreConstraint.constant = CGFloat(offset*5 + buttonWidth*4)
            }
            
            appDelegate.evengine.setVideoActive(3)
            
            DDLogWrapper.logInfo("setVideoActive 3")
        }
    }
    
    func setBottomBtnFrame(_ type: VideoModeType) {
        if type == .audioMode {
            audioBg.isHidden = false
            exitVoiceModeBtn.isHidden = false
            switchCameraBtn.isHidden = true
            switchCameraLb.isHidden = true
            operateCameraView.isHidden = true
            moreView.isHidden = false
            layoutChangeView.isHidden = true
            
            if getFeatureSupportParameter(chatInConference) && getFeatureSupportParameter(imLoginSuccess) {
                let buttonWidth = Float(80)
                let offset = Float((meanBg.width-320)/5)
                chatView.isHidden = false
                
                muteConstraint.constant = CGFloat(offset)
                meetingMGConstraint.constant = CGFloat(offset*2 + buttonWidth)
                chatConstraint.constant = CGFloat(offset*3 + buttonWidth*2)
                moreConstraint.constant = CGFloat(offset*4 + buttonWidth*3)
            }else {
                let buttonWidth = Float(80)
                let offset = Float((meanBg.width-240)/4)
                chatView.isHidden = true
                
                muteConstraint.constant = CGFloat(offset)
                meetingMGConstraint.constant = CGFloat(offset*2 + buttonWidth)
                moreConstraint.constant = CGFloat(offset*3 + buttonWidth*2)
            }
        }else if type == .videoMode {
            audioBg.isHidden = true
            exitVoiceModeBtn.isHidden = true
            operateCameraView.isHidden = false
            switchCameraBtn.isHidden = false
            switchCameraLb.isHidden = false
            layoutChangeView.isHidden = false
            moreView.isHidden = false
            
            if getFeatureSupportParameter(chatInConference) && getFeatureSupportParameter(imLoginSuccess) {
                let buttonWidth = Float(80)
                let offset = Float((meanBg.width-480)/7)
                chatView.isHidden = false
                
                muteConstraint.constant = CGFloat(offset)
                operateCameraConstraint.constant = CGFloat(offset*2 + buttonWidth)
                meetingMGConstraint.constant = CGFloat(offset*3 + buttonWidth*2)
                chatConstraint.constant = CGFloat(offset*4 + buttonWidth*3)
                layoutChangeConstraint.constant = CGFloat(offset*5 + buttonWidth*4)
                moreConstraint.constant = CGFloat(offset*6 + buttonWidth*5)
            }else {
                let buttonWidth = Float(80)
                let offset = Float((meanBg.width-400)/6)
                chatView.isHidden = true
                
                muteConstraint.constant = CGFloat(offset)
                operateCameraConstraint.constant = CGFloat(offset*2 + buttonWidth)
                meetingMGConstraint.constant = CGFloat(offset*3 + buttonWidth*2)
                layoutChangeConstraint.constant = CGFloat(offset*4 + buttonWidth*3)
                moreConstraint.constant = CGFloat(offset*5 + buttonWidth*4)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "hidden" {
            if !alertView.isHidden {
                self.perform(#selector(hiddenAlert), with: nil, afterDelay: 3)
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc func hiddenAlert() {
        alertView.isHidden = true
    }
    
    @objc func didBecomeActive() {
        if isEnableCamera {
            appDelegate.evengine.enableCamera(true)
            DDLogWrapper.logInfo("evengine.enableCamera(true)")
        }
        
        appDelegate.evengine.audioInterruption(0)
    }
    
    @objc func didEnterBackground() {
        appDelegate.evengine.enableCamera(false)
        DDLogWrapper.logInfo("evengine.enableCamera(false)")
    }
    
    @objc func hiddenTool() {
        UIView.animate(withDuration: 0.5, animations: {
            self.topConstraint.constant = -49
            self.bottomConstraint.constant = -49
            self.moreMenuView.isHidden = true
            self.view.layoutIfNeeded()
        }) { (flag) in
            self.topNavBar.isHidden = true
            self.bottomNavBar.isHidden = true
        }
    }
    
    func joinChatMode() {
        userModel = .chatMode
        
        local.isHidden = true
        operateLocalVideoBtn.isSelected = local.isHidden
        
        one.nameLb.font = UIFont.systemFont(ofSize: 9)
        two.nameLb.font = UIFont.systemFont(ofSize: 9)
        three.nameLb.font = UIFont.systemFont(ofSize: 9)
        four.nameLb.font = UIFont.systemFont(ofSize: 9)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.topConstraint.constant = -49
            self.bottomConstraint.constant = -49
            self.moreMenuView.isHidden = true
            self.view.layoutIfNeeded()
        }) { (flag) in
            self.topNavBar.isHidden = true
            self.bottomNavBar.isHidden = true
        }
    }
    
    func joinMeetingMode() {
        userModel = .meetingMode
        
        one.nameLb.font = UIFont.systemFont(ofSize: 13)
        two.nameLb.font = UIFont.systemFont(ofSize: 13)
        three.nameLb.font = UIFont.systemFont(ofSize: 13)
        four.nameLb.font = UIFont.systemFont(ofSize: 13)
        
        one.videoStateView.isHidden = false
        two.videoStateView.isHidden = false
        three.videoStateView.isHidden = false
        four.videoStateView.isHidden = false
        
        self.changeLayout(layoutType)
    }
    
    func showAlert(_ title: String) {
        if userModel == .chatMode {
            return
        }
        
        alertLb.text = title
        
        let width = Utils.getWidthWithText(alertLb.text!, height: 40, font: 11)
        if width+20 < self.view.width/2 {
            alertViewConstraint.constant = width+50
        }else {
            alertViewConstraint.constant = self.view.width/2
        }
        
        alertView.isHidden = false
    }
    
    func creatGesturesForHiddenToolBar() {
        let gestures = UITapGestureRecognizer.init(target: self, action: #selector(handleSingleTap))
        gestures.numberOfTouchesRequired = 1
        meanBg.addGestureRecognizer(gestures)
    }
    
    func creatGesturesForMoveWindow() {
        let gestures = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        gestures.delaysTouchesBegan = true
        videoBg.addGestureRecognizer(gestures)
        
        let gestures2 = UITapGestureRecognizer.init(target: self, action: #selector(videoBghandleSingleTap))
        gestures2.numberOfTouchesRequired = 1
        videoBg.addGestureRecognizer(gestures2)
    }
    
    @objc func handleSingleTap() {
        self.changeLayout(layoutType)
        
        if topConstraint.constant == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.topConstraint.constant = -49
                self.bottomConstraint.constant = -49
                self.moreMenuView.isHidden = true
                self.view.layoutIfNeeded()
            }) { (flag) in
                self.topNavBar.isHidden = true
                self.bottomNavBar.isHidden = true
            }
        }else {
            self.topNavBar.isHidden = false
            self.bottomNavBar.isHidden = false
            UIView.animate(withDuration: 0.5) {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.hiddenTool), object: nil)
                self.perform(#selector(self.hiddenTool), with: nil, afterDelay: 10)
                self.topConstraint.constant = 0
                self.bottomConstraint.constant = 0
                self.moreMenuView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func videoBghandleSingleTap() {
        NotificationCenter.default.post(name: NSNotification.Name("backVideo"), object: nil)
    }
    
    @objc func handlePanGesture(_ p: UIPanGestureRecognizer) {
        if userModel == .chatMode {
            let appWindow = appDelegate.window
            let panPoint = p.location(in: appWindow)
            
            if p.state == .began {
                
            }else if p.state == .changed {
                self.view.window?.center = CGPoint(x: panPoint.x, y: panPoint.y)
            }else if p.state == .ended || p.state == .cancelled {
                let ballWidth = self.view.frame.size.width
                let ballHeight = self.view.frame.size.height
                let screenWidth = UIScreen.main.bounds.size.width
                let screenHeight = UIScreen.main.bounds.size.height
                
                let left = abs(panPoint.x)
                let right = abs(screenWidth-left)
                let top = abs(panPoint.y)
                
                let minSpace = left < right ? left:right
                var newCenter = CGPoint.zero
                var targetY = 0.0
                
                //Correcting Y
                if panPoint.y < 15 + ballHeight/2 {
                    targetY = Double(15 + ballHeight/2)
                }else if panPoint.y > (screenHeight - ballHeight/2 - 15) {
                    targetY = Double(screenHeight - ballHeight/2.0 - 15)
                }else {
                    targetY = Double(panPoint.y)
                }
                
                let centerXSpace = (0.5 - 0) * ballWidth
                let centerYSpace = (0.5 - 0) * ballHeight
                
                if minSpace == left {
                    newCenter = CGPoint(x: centerXSpace, y: CGFloat(targetY))
                }else if minSpace == right {
                    newCenter = CGPoint(x: screenWidth - centerXSpace, y: CGFloat(targetY))
                }else if minSpace == top {
                    newCenter = CGPoint(x: panPoint.x, y: centerXSpace)
                }else {
                    newCenter = CGPoint(x: panPoint.x, y: screenHeight - centerYSpace)
                }
                
                UIView.animate(withDuration: 0.25) {
                    self.view.window?.center = newCenter
                }
            }
        }
    }
    
    func startTimer() {
        timerSecond = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshJoinTime), userInfo: nil, repeats: true)
        if !appDelegate.isAnonymousUser {
            local.nameLb.text = appDelegate.evengine.getDisplayName()
            DDLogWrapper.logInfo("getDisplayName name:\(local.nameLb.text ?? "")")
        }
        
        if appDelegate.evengine.micEnabled() {
            muteBtn.setImage(UIImage.init(named: "icon_unmute"), for: .normal)
            muteLb.text = "video.control.btn.mute".localized
            muteLb.textColor = UIColor.white
        }else {
            muteBtn.setImage(UIImage.init(named: "icon_mute_"), for: .normal)
            muteLb.text = "video.control.btn.unmute".localized
            muteLb.textColor = UIColor.init(formHexString: "0xff4747")
        }
        
        isEnableCamera = appDelegate.evengine.micEnabled()
        
        if appDelegate.evengine.cameraEnabled(){
            operateCameraBtn.setImage(UIImage.init(named: "icon_unmute-camera"), for: .normal)
            operateCameraLb.text = "video.control.btn.stopVideo".localized
            operateCameraLb.textColor = UIColor.white
        }else {
            operateCameraBtn.setImage(UIImage.init(named: "icon_mute-camera_"), for: .normal)
            operateCameraLb.text = "video.control.btn.startVideo".localized
            operateCameraLb.textColor = UIColor.init(formHexString: "0xff4747")
        }
        
        layoutMode = .galleryMode
        chooseLayoutMode(layoutMode)
        
        perform(#selector(hiddenTool), with: nil, afterDelay: 10)
    }
    
    @objc func refreshJoinTime() {
        DispatchQueue.main.async {
            self.second += 1
            self.durationTimeLb.text = DateTools.formaterSeconds(toTimer: self.second)
            
            self.local.muteImg.isHidden = self.appDelegate.evengine.micEnabled() ? true:false
            self.local.nameConstraint.constant = self.appDelegate.evengine.micEnabled() ? 5:22
        }
    }
    
    // MARK: ButtonMethod
    @objc func buttonMethod(sender:UIButton) {
        switch sender {
        case exitVoiceModeBtn:
            exitVoiceModeBtnAction()
            break
        case signalBtn:
            signalBtnAction()
            break
        case switchCameraBtn:
            switchCameraBtnAction()
            break
        case hangUpBtn:
            let alert = UIAlertController.init(title: "", message: "alert.leavemeeting".localized, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "alert.cancel".localized, style: .default, handler: { (_) in
            }))
            alert.addAction(UIAlertAction(title: "alert.sure".localized, style: .default, handler: { (_) in
                self.appDelegate.evengine.leaveConference()
                DDLogWrapper.logInfo("sdk hangUp")
            }))
            
            present(alert, animated: true, completion: nil)
            break
        case selectBtn:
            selectBtnAction()
            break
        case operateLocalVideoBtn:
            local.isHidden = !local.isHidden
            operateLocalVideoBtn.isSelected = local.isHidden
            break
        case speechBtn:
            speechBtnAction()
            break
        case switchAudioBtn:
            switchAudioBtnAction()
            break
        case modifyNameBtn:
            modifyNameBtnAction()
            break
        case muteBtn:
            muteBtnAction()
            break
        case operateCameraBtn:
            operateCameraBtnAction()
            break
        case meetingMGBtn:
            meetingMGBtnAction()
            break
        case chatBtn:
            chatBtnAction()
            break
        case layoutChangeBtn:
            layoutChangeBtnAction()
            break
        case moreBtn:
            moreMenuView.isHidden = !moreMenuView.isHidden
            break
        case closeWebBtn:
            webBg.isHidden = true
            conferenceVC?.webKit.load(URLRequest(url: URL(string: "about:blank")!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20.0))
            break
        case closeStatisticalBtn:
            statisticalBg.isHidden = true
            break
        default: break
            
        }
    }
    
    // MARK: ButtonAction
    func switchCameraBtnAction() {
        appDelegate.evengine.switchCamera()
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == UIInterfaceOrientation.landscapeRight {
            let device = appDelegate.evengine.getDevice(.videoCapture)
            if device.name.contains("in_video:0") || device.name.count == 0 {
                appDelegate.evengine.setDeviceRotation(0)
            }else {
                appDelegate.evengine.setDeviceRotation(180)
            }
        }else if orientation == UIInterfaceOrientation.landscapeLeft {
            let device = appDelegate.evengine.getDevice(.videoCapture)
            if device.name.contains("in_video:0") || device.name.count == 0 {
                appDelegate.evengine.setDeviceRotation(180)
            }else {
                appDelegate.evengine.setDeviceRotation(0)
            }
        }
    }
    
    func speechBtnAction() {
        appDelegate.evengine.requestRemoteUnmute(true)
        
        DDLogWrapper.logInfo("requestRemoteUnmute(true)")
        
        showAlert("alert.handsup.approve".localized)
    }
    
    func switchAudioBtnAction() {
        videoModel = videoModel == .videoMode ? .audioMode : .videoMode
        if videoModel == .audioMode {
            switchAudioBtn.setTitle("video.videomode".localized, for: .normal)
            operateLocalVideoBtn.alpha = 0.5
            operateLocalVideoBtn.isEnabled = false
        }else {
            switchAudioBtn.setTitle("video.audiomode".localized, for: .normal)
            operateLocalVideoBtn.alpha = 1
            operateLocalVideoBtn.isEnabled = true
        }
        setBottomConstraint(videoModel)
    }
    
    func modifyNameBtnAction() {
        moreMenuView.isHidden = true
        let alert = UIAlertController.init(title: "", message: "alert.changeName".localized, preferredStyle: .alert)
        alert.addTextField { [weak self] (textField) in
            textField.placeholder = "alert.updateName.propt".localized
            textField.text = self?.local.nameLb.text
        }
        alert.addAction(UIAlertAction(title: "alert.cancel".localized, style: .default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "alert.sure".localized, style: .default, handler: { [weak self] (_) in
            let textField = alert.textFields?.first
            if textField?.text?.count != 0 {
                if !Utils.judgeSpecialCharacter(["\"", "<", ">"], withStr: textField!.text!) {
                    self?.showAlert("alert.specialcharacter".localized)
                    return
                }
                self?.appDelegate.evengine.setInConfDisplayName((textField?.text)!)
                
                DDLogWrapper.logInfo("setInConfDisplayName name:\(textField!.text!)")
                self?.local.nameLb.text = textField?.text!
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func muteBtnAction() {
        appDelegate.evengine.enableMic(!appDelegate.evengine.micEnabled())
        
        if appDelegate.evengine.micEnabled() {
            muteBtn.setImage(UIImage.init(named: "icon_unmute"), for: .normal)
            muteLb.text = "video.control.btn.mute".localized
            muteLb.textColor = UIColor.white
        }else {
            muteBtn.setImage(UIImage.init(named: "icon_mute_"), for: .normal)
            muteLb.text = "video.control.btn.unmute".localized
            muteLb.textColor = UIColor.init(formHexString: "0xff4747")
        }
    }
    
    func operateCameraBtnAction() {
        DDLogWrapper.logInfo("evengine.enableCamera(\(!appDelegate.evengine.cameraEnabled()))")
        appDelegate.evengine.enableCamera(!appDelegate.evengine.cameraEnabled())
        if appDelegate.evengine.cameraEnabled(){
            operateCameraBtn.setImage(UIImage.init(named: "icon_unmute-camera"), for: .normal)
            operateCameraLb.text = "video.control.btn.stopVideo".localized
            operateCameraLb.textColor = UIColor.white
        }else {
            operateCameraBtn.setImage(UIImage.init(named: "icon_mute-camera_"), for: .normal)
            operateCameraLb.text = "video.control.btn.startVideo".localized
            operateCameraLb.textColor = UIColor.init(formHexString: "0xff4747")
        }
        
        isEnableCamera = appDelegate.evengine.cameraEnabled()
    }
    
    func meetingMGBtnAction() {
        webBg.setNeedsLayout()
        webBg.layoutIfNeeded()
        webBg.isHidden = !webBg.isHidden
        conferenceVC?.view.frame = CGRect(x: 0, y: 0, width: webBg.width, height: webBg.height)
        conferenceVC?.loadWebView(meetingNumberLb.text!)
    }
    
    func chatBtnAction() {
        meanBg.isHidden = true
        
        if joinGroupChat != nil {
            joinGroupChat!(audioBg.isHidden)
            joinChatMode()
        }
    }
    
    func exitVoiceModeBtnAction() {
        speakerView.isHidden = true
        videoModel = .videoMode
        switchAudioBtn.setTitle("video.audiomode".localized, for: .normal)
        operateLocalVideoBtn.alpha = 1
        operateLocalVideoBtn.isEnabled = true
        setBottomConstraint(videoModel)
    }
    
    func signalBtnAction() {
        statisticalBg.isHidden = !statisticalBg.isHidden
        statisticalVC?.view.frame = CGRect(x: 0, y: 0, width: statisticalBg.width, height: statisticalBg.height)
    }
    
    func layoutChangeBtnAction() {
        if meetingMode == .discussionMode {
            layoutMode = layoutMode == .galleryMode ? .speakerMode:.galleryMode
            chooseLayoutMode(layoutMode)
        }else {
            showAlert("alert.openmainvenuemodel".localized)
        }
    }
    
    func selectBtnAction() {
        if selectBtn.isSelected {
            leftLb.backgroundColor = UIColor.init(formHexString: "0x5880F7")
            rightLb.backgroundColor = UIColor.white
            leftLb.textColor = UIColor.white
            rightLb.textColor = UIColor.black
            contentView.isHidden = false
        }else {
            rightLb.backgroundColor = UIColor.init(formHexString: "0x5880F7")
            leftLb.backgroundColor = UIColor.white
            rightLb.textColor = UIColor.white
            leftLb.textColor = UIColor.black
            contentView.isHidden = true
        }
        
        selectBtn.isSelected = !selectBtn.isSelected
    }
    
    // MARK: ChangeLayout
    func changeLayout(_ type:LayoutType) {
        if type == .oneVideo {
            oneBg.isHidden = false
            twoBg.isHidden = true
            threeBg.isHidden = true
            fourBg.isHidden = true
            
            if height*16/9 <= width {
                oneConstraint.constant = CGFloat(width-height*16/9)/2
                oneTop.constant = 0
                twoTop.constant = 0
                
                onewidth.constant = CGFloat(width)
                oneheight.constant = CGFloat(height)
                
                twowidth.constant = 0
                twoheight.constant = 0
                
                threewidth.constant = 0
                threeheight.constant = 0
                
                fourwidth.constant = 0
                fourheight.constant = 0
            }else {
                
                oneTop.constant = CGFloat(height-width*9/16)/2
                
                twoTop.constant = 0
                
                onewidth.constant = CGFloat(width)
                oneheight.constant = CGFloat(height-(height-width*9/16))
                
                twowidth.constant = 0
                twoheight.constant = 0
                
                threewidth.constant = 0
                threeheight.constant = 0
                
                fourwidth.constant = 0
                fourheight.constant = 0
            }
            
        }else if type == .twovideo {
            oneBg.isHidden = false
            twoBg.isHidden = false
            threeBg.isHidden = true
            fourBg.isHidden = true
            
            oneConstraint.constant = 0
            onewidth.constant = CGFloat(width/2)
            oneheight.constant = CGFloat(width/2*9/16)
            
            twowidth.constant = CGFloat(width/2)
            twoheight.constant = CGFloat(width/2*9/16)
            
            oneTop.constant = CGFloat((height-width/2*9/16)/2)
            twoTop.constant = CGFloat((height-width/2*9/16)/2)
            
            threewidth.constant = 0
            threeheight.constant = 0
            
            fourwidth.constant = 0
            fourheight.constant = 0
        }else if type == .threeVideo {
            oneBg.isHidden = false
            twoBg.isHidden = false
            threeBg.isHidden = false
            fourBg.isHidden = true
            
            if height*16/9 <= width {
                oneConstraint.constant = 0
                oneTop.constant = 0
                twoTop.constant = 0
                onewidth.constant = CGFloat(width/2)
                oneheight.constant = CGFloat(height/2)
                
                twowidth.constant = CGFloat(width/2)
                twoheight.constant = CGFloat(height/2)
                
                threewidth.constant = CGFloat(width/2)
                threeheight.constant = CGFloat(height/2)
            }else {
                oneTop.constant = CGFloat(height-width*9/16)/2
                twoTop.constant = CGFloat(height-width*9/16)/2
                
                onewidth.constant = CGFloat(width/2)
                oneheight.constant = CGFloat((height-(height-width*9/16))/2)
                
                twowidth.constant = CGFloat(width/2)
                twoheight.constant = CGFloat((height-(height-width*9/16))/2)
                
                threewidth.constant = CGFloat(width/2)
                threeheight.constant = CGFloat((height-(height-width*9/16))/2)
            }
            
            fourwidth.constant = 0
            fourheight.constant = 0
        }else if type == .fourVideo {
            oneBg.isHidden = false
            twoBg.isHidden = false
            threeBg.isHidden = false
            fourBg.isHidden = false
            
            if height*16/9 <= width {
                oneConstraint.constant = 0
                oneTop.constant = 0
                twoTop.constant = 0
                onewidth.constant = CGFloat(width/2)
                oneheight.constant = CGFloat(height/2)
                
                twowidth.constant = CGFloat(width/2)
                twoheight.constant = CGFloat(height/2)
                
                threewidth.constant = CGFloat(width/2)
                threeheight.constant = CGFloat(height/2)
                
                fourwidth.constant = CGFloat(width/2)
                fourheight.constant = CGFloat(height/2)
            }else {
                oneTop.constant = CGFloat(height-width*9/16)/2
                twoTop.constant = CGFloat(height-width*9/16)/2
                
                onewidth.constant = CGFloat(width/2)
                oneheight.constant = CGFloat((height-(height-width*9/16))/2)
                
                twowidth.constant = CGFloat(width/2)
                twoheight.constant = CGFloat((height-(height-width*9/16))/2)
                
                threewidth.constant = CGFloat(width/2)
                threeheight.constant = CGFloat((height-(height-width*9/16))/2)
                
                fourwidth.constant = CGFloat(width/2)
                fourheight.constant = CGFloat((height-(height-width*9/16))/2)
            }
        }
    }
    
    // MARK: UpdatedSafeAreaNotifier
    func viewSafeAreaInsetsDidChange_() {
        videoBg.setNeedsLayout()
        videoBg.layoutIfNeeded()

        width = Float(videoBg.frame.size.width)
        height = Float(videoBg.frame.size.height)

        if height>width {
            height = Float(videoBg.frame.size.width)
            width = Float(videoBg.frame.size.height)
        }

        changeLayout(layoutType)
    }
    
}

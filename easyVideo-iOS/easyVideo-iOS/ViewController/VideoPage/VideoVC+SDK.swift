//
//  VideoVC+SDK.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension VideoVC {
    func setVideoForSKD() {
        let arr:[UIView] = [one.videoV, two.videoV, three.videoV, four.videoV]
        Utils.setRemoteVideo(arr)
        appDelegate.evengine.setLocalVideoWindow(Unmanaged.passUnretained(local.videoV).toOpaque())
        appDelegate.evengine.setRemoteContentWindow(Unmanaged.passUnretained(contentView).toOpaque())
    }
    
    func chooseLayoutMode(_ layoutMode:LayoutMode) {
        let layout = EVLayoutRequest()
        layout.page = .currentPage
        layout.max_resolution = EVVideoSize(width: 0, height: 0)
        
        if layoutMode == .speakerMode {
            layout.mode = .speakerMode
            layout.max_type = ._1
            layoutChangeBtn.setImage(UIImage.init(named: "icon_gallery_"), for: .normal)
        }else {
            layout.mode = .galleryMode
            layout.max_type = ._4
            layoutChangeBtn.setImage(UIImage.init(named: "icon_lecture_"), for: .normal)
        }
        
        appDelegate.evengine.setLayout(layout)
    }
    
    //Need to do to get out of meetings
    func callEndMethod() {
        NotificationCenter.default.post(name: NSNotification.Name("backVideo"), object: nil)
        
        moreMenuView.isHidden = true
        statisticalBg.isHidden = true
        webBg.isHidden = true
        selectBtn.isSelected = false
        local.isHidden = false
        isMuteforEnd = false
        isLocalVideoHidden = false
        isReceivedUnmuteMsg = false
        meetingMode = .discussionMode
        contentView.isHidden = true
        contentMenuView.isHidden = true
        recordingView.isHidden = true
        videoModel = .videoMode
        setBottomConstraint(videoModel)
        
        let featurePlist = NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(featureSupportPlist))
        featurePlist.setValue(false, forKey: imLoginSuccess)
        PlistUtils.savePlistFile(featurePlist as! [AnyHashable : Any], withFileName: featureSupportPlist)
        
        if timerSecond != nil {
            if timerSecond!.isValid {
                timerSecond?.invalidate()
                timerSecond = nil
            }
        }
        
        second = 0
        durationTimeLb.text = "00:00:00"
        
        messageView.isHidden = true
        messageLb?.layer.removeAllAnimations()
    }
    
    func staticSpeed(_ msg: EVMessageOverlay) {
        messageLb?.isHidden = true
        staticLb?.frame = CGRect(x: 0, y: 0, width: messageView.width, height: 40)
        staticLb?.isHidden = false
        messageCount = 10000
        staticLb?.text = msg.content
        staticLb?.textColor = Utils.color(withHexString: msg.foregroundColor)
        staticLb?.textAlignment = .center
    }
    
    func otherSpeed(_ msg: EVMessageOverlay) {
        staticLb?.isHidden = true
        messageLb?.isHidden = false
        
        let width = Utils.getWidthWithText(msg.content, height: 40, font: 13)
        messageLb?.frame = CGRect(x: 0, y: 0, width: width, height: 40)
        
        if msg.displaySpeed == 2 {
            timeInteger = 14
        }else if msg.displaySpeed == 5 {
            timeInteger = 10
        }else if msg.displaySpeed == 8 {
            timeInteger = 6
        }
        setAnimation(messageLb!, timeInteger)
    }
    
    func setAnimation(_ animationView:UIView, _ time:NSInteger) {
        let width = Utils.getWidthWithText(messageLb!.text!, height: 40, font: 13)
        
        let basicAni = CABasicAnimation()
        basicAni.keyPath = "position"
        basicAni.fromValue = NSValue.init(cgPoint: CGPoint(x: messageView.width + width/2, y: 20))
        basicAni.toValue = NSValue.init(cgPoint: CGPoint(x: -width, y: 20))
        basicAni.duration = CFTimeInterval(time)
        basicAni.fillMode = .forwards
        basicAni.isRemovedOnCompletion = false
        basicAni.delegate = self
        animationView.layer.add(basicAni, forKey: nil)
    }
    
    // MARK: SDKMETHOD
    func onCallEnd(_ info: EVCallInfo) {
        callEndMethod()
        
        if hiddenWindowblock != nil {
            hiddenWindowblock!()
        }
    }
    
    func onLayoutIndication(_ layout: EVLayoutIndication) {
        DDLogWrapper.logInfo("sdk onLayoutIndication sites.count:\(layout.sites.count) speakerName:\(layout.speaker_name)")
        
        if layout.speaker_name.count != 0 {
            speakerNameLb.text = layout.speaker_name
            speakerView.isHidden = !audioBg.isHidden ? false : true
        }
        
        if layout.speaker_index == -1 {
            speakerView.isHidden = layout.speaker_name.count != 0 ? false : true
            for video in remoteList {
                video.setNormolSpeaker()
            }
        }else {
            var i = 0
            for video in remoteList {
                if i == layout.speaker_index {
                    video.setActiveSpeaker()
                }else {
                    video.setNormolSpeaker()
                }
                i += 1
            }
        }
        
        meetingMode = layout.mode_settable ? .discussionMode : .mainVenueMode
        
        for site in layout.sites {
            for video in remoteList {
                if site.window == Unmanaged.passUnretained(video.videoV).toOpaque() {
                    if video.videoV == one.videoV {
                        one.nameConstraint.constant = site.mic_muted || site.remote_muted ? 22:5
                        one.muteImg.isHidden = site.mic_muted || site.remote_muted ? false:true
                        one.nameLb.text = site.name
                    }else if video.videoV == two.videoV {
                        two.nameConstraint.constant = site.mic_muted || site.remote_muted ? 22:5
                        two.muteImg.isHidden = site.mic_muted || site.remote_muted ? false:true
                        two.nameLb.text = site.name
                    }else if video.videoV == three.videoV {
                        three.nameConstraint.constant = site.mic_muted || site.remote_muted ? 22:5
                        three.muteImg.isHidden = site.mic_muted || site.remote_muted ? false:true
                        three.nameLb.text = site.name
                    }else if video.videoV == four.videoV {
                        four.nameConstraint.constant = site.mic_muted || site.remote_muted ? 22:5
                        four.muteImg.isHidden = site.mic_muted || site.remote_muted ? false:true
                        four.nameLb.text = site.name
                    }
                }
            }
        }
        
        if layout.sites.count == 2 {
            layoutType = .twovideo
        }else if layout.sites.count == 3 {
            layoutType = .threeVideo
        }else if layout.sites.count == 4 {
            layoutType = .fourVideo
        }else {
            layoutType = .oneVideo
        }
        self.changeLayout(layoutType)
    }
    
    func onLayoutSiteIndication(_ site: EVSite) {
        if site.is_local {
            local.nameLb.text = site.name
            local.muteImg.isHidden = site.remote_muted ? false : true
            local.nameConstraint.constant = site.remote_muted ? 22 : 5
            speechBtn.isEnabled = site.remote_muted ? false : true
            speechBtn.alpha = site.remote_muted ? 1 : 0.5
            
            if site.remote_muted {
                local.muteImg.isHidden = false
                local.nameConstraint.constant = 22
                speechBtn.isEnabled = true
                speechBtn.alpha = 1
                if !isMuteforEnd {
                    isMuteforEnd = true
                    showAlert("alert.alertlabel.nospeak".localized)
                }
            }else {
                local.muteImg.isHidden = true
                local.nameConstraint.constant = 5
                speechBtn.isEnabled = false
                speechBtn.alpha = 0.5
                if isMuteforEnd {
                    isMuteforEnd = false
                    showAlert("alert.alertlabel.speak".localized)
                }
            }
            
        }
        for video in remoteList {
            if site.window == Unmanaged.passUnretained(video.videoV).toOpaque() {
                if video.videoV == one.videoV {
                    one.muteImg.isHidden = site.mic_muted || site.remote_muted ? false:true
                    one.nameConstraint.constant = site.mic_muted || site.remote_muted ? 22:5
                    one.nameLb.text = site.name
                }else if video.videoV == two.videoV {
                    two.muteImg.isHidden = site.mic_muted || site.remote_muted ? false:true
                    two.nameConstraint.constant = site.mic_muted || site.remote_muted ? 22:5
                    two.nameLb.text = site.name
                }else if video.videoV == three.videoV {
                    three.nameConstraint.constant = site.mic_muted || site.remote_muted ? 22:5
                    three.muteImg.isHidden = site.mic_muted || site.remote_muted ? false:true
                    three.nameLb.text = site.name
                }else if video.videoV == four.videoV {
                    four.nameConstraint.constant = site.mic_muted || site.remote_muted ? 22:5
                    four.muteImg.isHidden = site.mic_muted || site.remote_muted ? false:true
                    four.nameLb.text = site.name
                }
            }
        }
    }
    
    func onContent(_ info: EVContentInfo) {
        DDLogWrapper.logInfo("sdk onContent type:\(info.type) status:\(info.status)")
        
        if info.status == .denied {
            
        }else if info.status == .granted {
            if info.type == .content || info.type == .whiteBoard {
                if info.enabled {
                    if info.dir == .upload {
                        
                    }else {
                        contentView.isHidden = false
                        contentMenuView.isHidden = false
                        leftLb.backgroundColor = UIColor.init(formHexString: "0x5880F7")
                        rightLb.backgroundColor = UIColor.white
                        leftLb.textColor = UIColor.white
                        rightLb.textColor = UIColor.black
                        selectBtn.isSelected = false
                    }
                }else {
                    contentView.isHidden = true
                    contentMenuView.isHidden = true
                }
            }
        }else if info.status == .released {
            contentView.isHidden = true
            contentMenuView.isHidden = true
        }
    }
    
    func onRecordingIndication(_ info: EVRecordingInfo) {
        switch info.state {
        case .none:
            recordingView.isHidden = true
            speakerConstraint.constant = 35
            break
        case .on:
            recordingView.isHidden = false
            speakerConstraint.constant = 110
            recordingLb.text = info.live ? "LIVE":"REC"
            break
        case .pause:
            recordingView.isHidden = true
            speakerConstraint.constant = 35
            break
        default:
            break
        }
    }
    
    func onMessageOverlay(_ msg: EVMessageOverlay) {
        DDLogWrapper.logInfo("sdk onMessageOverlay enable:\(msg.enable) content:\(msg.content)")
        if msg.enable {
            if msg.content.count == 0 {
                return
            }
            messageLb?.layer.removeAllAnimations()
            
            let width = Utils.getWidthWithText(msg.content, height: 40, font: 13)
            if width > messageView.width {
                messageLb?.frame = CGRect(x: 0, y: 0, width: width+50, height: 40)
            }else {
                messageLb?.frame = CGRect(x: 0, y: 0, width: messageView.width, height: 40)
            }
            
            messageLb?.textColor = Utils.color(withHexString: msg.foregroundColor)
            messageView.layer.backgroundColor = Utils.color(withHexString: msg.backgroundColor).withAlphaComponent((CGFloat(1-msg.transparency/100))).cgColor
            messageLb?.text = msg.content
            messageCount = Int(msg.displayRepetitions)
            messageView.isHidden = false
            
            msg.displaySpeed == 0 ? staticSpeed(msg):otherSpeed(msg)
        }else {
            messageView.isHidden = true
            messageLb?.layer.removeAllAnimations()
        }
    }
    
    func onParticipant(_ number: Int32) {
        DDLogWrapper.logInfo("sdk onParticipant number:\(number)")
        peopleNumberLb.text = "\(number)"
    }
    
    func onNetworkQuality(_ quality_rating: Float) {
        signalBtn.setImage(UIImage.init(named: "image_\(quality_rating)"), for: .normal)
    }
    
    func onWarn(_ warn: EVWarn) {
        DDLogWrapper.logInfo("sdk onWarn code:\(warn.code)")
        
        let setInfo = NSDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(setPlist))
        if setInfo[enableCloseTip] != nil && setInfo[enableCloseTip] as! Bool {
            if warn.code == .networkPoor || warn.code == .networkVeryPoor || warn.code == .bandwidthInsufficient || warn.code == .bandwidthVeryInsufficient {
                return
            }
        }
        
        switch warn.code {
        case .networkPoor:
            showAlert("alert.network_stable".localized)
            break
        case .networkVeryPoor:
            showAlert("alert.network_poor".localized)
            break
        case .bandwidthInsufficient:
            showAlert("alert.network_insufficient".localized)
            break
        case .bandwidthVeryInsufficient:
            showAlert("alert.network_shortage".localized)
            break
        case .unmuteAudioNotAllowed:
            showAlert("alert.unmuteAudioNotAllowed".localized)
            break
        case .unmuteAudioIndication:
            if userModel == .chatMode {
                isReceivedUnmuteMsg = true
            }
            showUnmuteMsg()
            break
        default: break
        }
        
    }
    
    func onLayoutSpeakerIndication(_ speaker: EVLayoutSpeakerIndication) {
        DDLogWrapper.logInfo("sdk onLayoutSpeakerIndication speaker:\(speaker)")
        
        if speaker.speaker_name.count != 0 {
            speakerView.isHidden = false
            speakerNameLb.text = speaker.speaker_name
            speakerView.isHidden = !audioBg.isHidden ? false : true
        }
        
        if speaker.speaker_index == -1 {
            speakerView.isHidden = speaker.speaker_name.count != 0 ? false : true
            for video in remoteList {
                video.setNormolSpeaker()
            }
        }else {
            var i = 0
            for video in remoteList {
                if i == speaker.speaker_index {
                    video.setActiveSpeaker()
                }else {
                    video.setNormolSpeaker()
                }
                i += 1
            }
        }
    }
    
    func onMuteSpeakingDetected() {
        DDLogWrapper.logInfo("sdk onMuteSpeakingDetected")
        
        let setInfo = NSDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(setPlist))
        if setInfo[enableCloseTip] != nil && setInfo[enableCloseTip] as! Bool {
            return
        }
        showAlert("alert.micmute".localized)
    }
    
    func onMicMutedShow(_ mic_muted: Int32) {
        DDLogWrapper.logInfo("sdk onMicMutedShow mic_muted:\(mic_muted)")
        
        if mic_muted != 0 {
            muteBtn.setImage(UIImage.init(named: "icon_mute_"), for: .normal)
            muteLb.text = "video.control.btn.unmute".localized
            muteLb.textColor = UIColor.init(formHexString: "0xff4747")
            showAlert("alert.alertlabel.nospeak".localized)
        }else {
            muteBtn.setImage(UIImage.init(named: "icon_unmute"), for: .normal)
            muteLb.text = "video.control.btn.mute".localized
            muteLb.textColor = UIColor.white
            showAlert("alert.alertlabel.speak".localized)
        }
    }
}

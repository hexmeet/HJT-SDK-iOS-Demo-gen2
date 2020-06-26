//
//  BaseTabBarVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit
import CoreTelephony

class BaseTabBarVC: UITabBarController, UITabBarControllerDelegate, EVEngineDelegate, EMEngineDelegate {
    
    var imTimer: Timer?
    
    let center = CTCallCenter()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var videoWidow: UIWindow?
    var videoVC: VideoVC?
    var theDeviceorientation: UIDeviceOrientation!
    var invitationView: InvitationView?
    var p2pCallView: P2pCallView?
    var needDelayJoin: Bool = false
    var meetingIdStr = ""
    var passwordStr = ""
    var serverStr = ""
    var nameStr = ""
    var portStr = ""
    var p2pImg = ""
    var p2pName = ""
    var imGrp = ""
    var imAdr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTabBarVC()
        
        addAVAudioSessionInterruptionNotification()
        
        addAudioRouteChangeListenerCallback()
        
        creatVideoWindow()
        
        setMotionManager()
        
        setCTCallCenter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewController.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: EVEngineDelegate
    func onRegister(_ registered: Bool) {
        onRegister_(registered)
    }
    
    func onLoginSucceed(_ user: EVUserInfo) {
        onLoginSucceed_(user)
    }
    
    func onError(_ err: EVError) {
        onError_(err)
    }
    
    func onDownloadUserImageComplete(_ path: String) {
        onDownloadUserImageComplete_(path)
    }
    
    func onCallConnected(_ info: EVCallInfo) {
        onCallConnected_(info)
    }
    
    func onPeerImageUrl(_ imageUrl: String) {
        onPeerImageUrl_(imageUrl)
    }
    
    func onCallPeerConnected(_ info: EVCallInfo) {
        onCallPeerConnected_(info)
    }
    
    func onCallEnd(_ info: EVCallInfo) {
        onCallEnd_(info)
    }
    
    func onJoinConferenceIndication(_ info: EVCallInfo) {
        onJoinConferenceIndication_(info)
    }
    
    func onContent(_ info: EVContentInfo) {
        onContent_(info)
    }
    
    func onNetworkQuality(_ quality_rating: Float) {
        onNetworkQuality_(quality_rating)
    }
    
    func onWarn(_ warn: EVWarn) {
        onWarn_(warn)
    }
    
    func onLayoutIndication(_ layout: EVLayoutIndication) {
        onLayoutIndication_(layout)
    }
    
    func onLayoutSpeakerIndication(_ speaker: EVLayoutSpeakerIndication) {
        onLayoutSpeakerIndication_(speaker)
    }
    
    func onLayoutSiteIndication(_ site: EVSite) {
        onLayoutSiteIndication_(site)
    }
    
    func onMessageOverlay(_ msg: EVMessageOverlay) {
        onMessageOverlay_(msg)
    }
    
    func onRecordingIndication(_ info: EVRecordingInfo) {
        onRecordingIndication_(info)
    }
    
    func onParticipant(_ number: Int32) {
        onParticipant_(number)
    }
    
    func onMuteSpeakingDetected() {
        onMuteSpeakingDetected_()
    }
    
    func onMicMutedShow(_ mic_muted: Int32) {
        onMicMutedShow_(mic_muted)
    }
    
    func onUploadFeedback(_ number: Int32) {
        onUploadFeedback_(number)
    }
    
    func onNotifyChatInfo(_ chatInfo: EVChatGroupInfo) {
        onNotifyChatInfo_(chatInfo)
    }
    
    // MARK: EMEngineDelegate
    func onMessageReciveData(_ message: MessageBody) {
        onMessageReciveData_(message)
    }
    
    func onEMError(_ err: EMError) {
        onEMError_(err)
    }
    
    func onLoginSucceed() {
        onLoginSucceed_()
    }
    
    func onMessageSendSucceed(_ messageState: MessageState) {
        onMessageSendSucceed_(messageState)
    }
    
    func onGroupMemberInfo(_ groupMemberInfo: EMGroupMemberInfo) {
        onGroupMemberInfo_(groupMemberInfo)
    }

}

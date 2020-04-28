//
//  VideoVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/14.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class VideoVC: BaseViewController, CAAnimationDelegate {
    
    public var joinGroupChat : ((_ flag:Bool)->())?
    
    var timerSecond: Timer?
    var second: Int32 = 0
    var remoteList: [VideoView] = []
    
    // MARK: VideoBg
    @IBOutlet weak var videoBg: UIView!
    @IBOutlet weak var one: VideoView!
    @IBOutlet weak var two: VideoView!
    @IBOutlet weak var three: VideoView!
    @IBOutlet weak var four: VideoView!
    @IBOutlet weak var local: VideoView!
    @IBOutlet weak var oneBg: UIView!
    @IBOutlet weak var twoBg: UIView!
    @IBOutlet weak var threeBg: UIView!
    @IBOutlet weak var fourBg: UIView!
    
    @IBOutlet weak var oneConstraint: NSLayoutConstraint!
    @IBOutlet weak var oneheight: NSLayoutConstraint!
    @IBOutlet weak var onewidth: NSLayoutConstraint!
    @IBOutlet weak var oneTop: NSLayoutConstraint!
    @IBOutlet weak var twoheight: NSLayoutConstraint!
    @IBOutlet weak var twowidth: NSLayoutConstraint!
    @IBOutlet weak var twoTop: NSLayoutConstraint!
    @IBOutlet weak var threeheight: NSLayoutConstraint!
    @IBOutlet weak var threewidth: NSLayoutConstraint!
    @IBOutlet weak var fourheight: NSLayoutConstraint!
    @IBOutlet weak var fourwidth: NSLayoutConstraint!
    
    // MARK: VideoBg
    @IBOutlet weak var audioBg: UIView!
    @IBOutlet weak var exitVoiceModeBtn: UIButton!
    @IBOutlet weak var exitVoiceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var exitVoiceWidthConstraint: NSLayoutConstraint!
    
    // MARK: MeanBg
    @IBOutlet weak var meanBg: UIView!
    
    @IBOutlet weak var topNavBar: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var signalBtn: UIButton!
    @IBOutlet weak var encryptedImg: UIImageView!
    @IBOutlet weak var durationTimeLb: UILabel!
    @IBOutlet weak var meetingNumberLb: UILabel!
    @IBOutlet weak var switchCameraBtn: UIButton!
    @IBOutlet weak var switchCameraLb: UILabel!
    @IBOutlet weak var hangUpBtn: UIButton!
    
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var recordingImg: UIImageView!
    @IBOutlet weak var recordingLb: UILabel!
    
    @IBOutlet weak var speakerView: UIView!
    @IBOutlet weak var speakerNameLb: UILabel!
    @IBOutlet weak var speakerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentMenuView: UIView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var leftLb: UILabel!
    @IBOutlet weak var rightLb: UILabel!
    
    @IBOutlet weak var moreMenuView: UIView!
    @IBOutlet weak var operateLocalVideoBtn: UIButton!
    @IBOutlet weak var speechBtn: UIButton!
    @IBOutlet weak var switchAudioBtn: UIButton!
    @IBOutlet weak var modifyNameBtn: UIButton!
    
    @IBOutlet weak var bottomNavBar: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var muteView: UIView!
    @IBOutlet weak var muteBtn: UIButton!
    @IBOutlet weak var muteLb: UILabel!
    @IBOutlet weak var operateCameraView: UIView!
    @IBOutlet weak var operateCameraBtn: UIButton!
    @IBOutlet weak var operateCameraLb: UILabel!
    @IBOutlet weak var meetingMGView: UIView!
    @IBOutlet weak var peopleNumberLb: UILabel!
    @IBOutlet weak var meetingMGBtn: UIButton!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var layoutChangeView: UIView!
    @IBOutlet weak var layoutChangeBtn: UIButton!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    
    // MARK: Message
    @IBOutlet weak var messageView: UIView!
    
    // MARK: webBg
    @IBOutlet weak var webBg: UIView!
    var conferenceVC:ConferenceVC?
    @IBOutlet weak var closeWebBtn: EnlargeEdgeButton!
    
    // MARK: statisticalBg
    @IBOutlet weak var statisticalBg: UIView!
    var statisticalVC:StatisticalVC?
    @IBOutlet weak var closeStatisticalBtn: UIButton!
    
    // MARK: alertView
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLb: UILabel!
    @IBOutlet weak var alertViewConstraint: NSLayoutConstraint!
    
    // MARK: BottomConstraint
    @IBOutlet weak var muteConstraint: NSLayoutConstraint!
    @IBOutlet weak var operateCameraConstraint: NSLayoutConstraint!
    @IBOutlet weak var meetingMGConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatConstraint: NSLayoutConstraint!
    @IBOutlet weak var layoutChangeConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreConstraint: NSLayoutConstraint!
    
    /// SafeAreaSize
    var width: Float = 0.0
    var height: Float = 0.0
    
    var layoutType = LayoutType.oneVideo
    var meetingMode = MeetingMode.discussionMode
    var layoutMode = LayoutMode.galleryMode
    var videoModel = VideoModeType.videoMode
    var userModel = UserMode.meetingMode
    
    var messageLb: UILabel?
    var staticLb: UILabel?
    var messageCount = 0
    var timeInteger = 0
    var isMuteforEnd = false
    var isEnableCamera = false
    var isLocalVideoHidden = false
    var isReceivedUnmuteMsg = false
    
    public var hiddenWindowblock : (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
        
        setVideoForSKD()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setBottomBtnFrame(videoModel)
        
        viewSafeAreaInsetsDidChange_()
    }
    
    // MARK: CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        messageCount -= 1
        if messageCount == 0 {
            messageView.isHidden = true
            messageLb?.layer.removeAllAnimations()
        }else {
            setAnimation(messageLb!, timeInteger)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true;
    }
}

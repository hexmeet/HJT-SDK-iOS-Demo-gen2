//
//  SwiftUtils.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/2/29.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

//判断是否为11位的正确号码
func isValidNumber(_ number: String) -> Bool {
    if number.count != 11 {
        return false
    }else {
        return true
    }
}

//保存历史呼叫记录
func saveNumberMethod(_ number: String) {
    if number.first != "1" {
        return
    }
    
    let arr = NSMutableArray.init(capacity: 1)
    
    if UserDefaults.standard.object(forKey: histroyCall) != nil {
        arr.addObjects(from: UserDefaults.standard.object(forKey: histroyCall) as! [String])
    }
    
    if arr.count < 5 {
        for str in arr {
            let hisNumber = "\(str)"
            if hisNumber == number {
                arr.remove(str)
            }
        }
        arr.insert(number, at: 0)
    }else {
        var flag = true
        for str in arr {
            let hisNumber = "\(str)"
            if hisNumber == number {
                arr.remove(str)
                arr.insert(str, at: 0)
                flag = false
            }
        }
        if flag {
            arr.removeLastObject()
            arr.insert(number, at: 0)
        }
    }
    
    UserDefaults.standard.setValue(arr, forKey: histroyCall)
}

func playSound() {
    let soundManager = SoundManager.shared()
    let ringPath = Bundle.main.path(forResource: "ringtone", ofType: "wav")
    let audioSession = AVAudioSession.sharedInstance()
    try? audioSession.setCategory(.playback)
    soundManager?.playSound(ringPath, looping: true, fadeIn: false)
}

func stopSound() {
    let soundManager = SoundManager.shared()
    let ringPath = Bundle.main.path(forResource: "ringtone", ofType: "wav")
    soundManager?.stopSound(ringPath)
}

func getSize(url: URL)->UInt64
{
    var fileSize : UInt64 = 0
    do {
        let attr = try FileManager.default.attributesOfItem(atPath: url.path)
        fileSize = attr[FileAttributeKey.size] as! UInt64
         
        let dict = attr as NSDictionary
        fileSize = dict.fileSize()
    } catch {
        print("Error: \(error)")
    }
    return fileSize
}

// MARK: 权限检测
func checkCameraPermission() -> Bool {
    var permission = true
    
    let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
    
    switch videoStatus {
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { (statusFirst) in
            if statusFirst {
                //用户首次允许
                DDLogWrapper.logInfo("camera is permitted by user!")
            } else {
                DDLogWrapper.logInfo("camera permission is denied by user, call will not send any audio sample to remote!")
            }
        }
        break
    case .authorized:
        DDLogWrapper.logInfo("CameraPermissions -- Authorized")
        break
    case .denied:
        DDLogWrapper.logInfo("CameraPermissions -- Denied")
        permission = false
        break
    case .restricted:
        DDLogWrapper.logInfo("CameraPermissions -- restricted")
        permission = false
        break
    default:
        break
    }
    
    return permission
}

func checkMicphonePermission() -> Bool {
    var permission = true
    
    let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    switch audioStatus {
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .audio) { (statusFirst) in
            if statusFirst {
                //用户首次允许
                DDLogWrapper.logInfo("micphone is permitted by user!")
            } else {
                DDLogWrapper.logInfo("micphone permission is denied by user, call will not send any audio sample to remote!")
            }
        }
        break
    case .authorized:
        DDLogWrapper.logInfo("CameraPermissions -- Authorized")
        break
    case .denied:
        DDLogWrapper.logInfo("CameraPermissions -- Denied")
        permission = false
        break
    case .restricted:
        DDLogWrapper.logInfo("CameraPermissions -- restricted")
        permission = false
        break
    default:
        break
    }
    
    return permission
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint

     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
    */
    func setMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {

        NSLayoutConstraint.deactivate([self])

        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)

        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier

        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

class NibView: UIView {
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
}

//NibView的private方法
private extension NibView {
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        view.frame = bounds
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view as Any]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view as Any]))
    }
}

extension UIView {

    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self));
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

//
//  BaseVC+jump.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

extension BaseViewController {
    
    func whetherTheLogin() {
        appDelegate.isLogin = false
        PresentLoginVCPage(animated: true, presentStyle: .fullScreen)
    }
    
    // MARK: Presnet
    /// 跳转LoginVC
    func PresentLoginVCPage(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let login = LoginVC()
        let nav = UINavigationController.init(rootViewController: login)
        nav.modalPresentationStyle = style
        present(nav, animated: flag, completion: nil)
    }
    
    /// 跳转PrivateVC
    func PresentPrivatePage(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let privatvc = PrivateVC()
        privatvc.modalPresentationStyle = style
        present(privatvc, animated: flag, completion: nil)
    }
    
    /// 跳转CloudVC
    func PresentCloudVCPage(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let cloud = CloudVC()
        cloud.modalPresentationStyle = style
        present(cloud, animated: flag, completion: nil)
    }
    
    /// 跳转PrivateJoinVC
    func PresentPrivateJoinVCPage(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let privatejoinVC = PrivateJoinVC()
        let nav = UINavigationController(rootViewController: privatejoinVC)
        nav.modalPresentationStyle = style
        present(nav, animated: flag, completion: nil)
    }
    
    /// 跳转PrivateLoginVC
    func PresentPrivateLoginVCPage(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let privateloginVC = PrivateLoginVC()
        privateloginVC.modalPresentationStyle = style
        present(privateloginVC, animated: flag, completion: nil)
    }
    
    /// 跳转AdvancedSettingVC
    func PresentAdvancedSettingVCPage(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let advancedSettingVC = AdvancedSettingVC()
        advancedSettingVC.modalPresentationStyle = style
        present(advancedSettingVC, animated: flag, completion: nil)
    }
    
    /// 跳转LoginSettingVC
    func PresentLoginSettingVCPage(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let loginSettingVC = LoginSettingVC()
        loginSettingVC.modalPresentationStyle = style
        present(loginSettingVC, animated: flag, completion: nil)
    }
    
    /// 跳转CloudLoginVC
    func PresentCloudLoginVCPage(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let cloudLoginVC = CloudLoginVC()
        cloudLoginVC.modalPresentationStyle = style
        present(cloudLoginVC, animated: flag, completion: nil)
    }
    
    /// 跳转CloudJoinVC
    func PresentCloudJoinVCCPage(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let cloudJoinVC = CloudJoinVC()
        let nav = UINavigationController(rootViewController: cloudJoinVC)
        nav.modalPresentationStyle = style
        present(nav, animated: flag, completion: nil)
    }
    
    /// 跳转AnonymousLinkVC
    func PresentAnonymousLinkVCPage(animated flag: Bool, presentStyle style: UIModalPresentationStyle, dict:NSMutableDictionary) {
        let anonymousLinkVC = AnonymousLinkVC()
        anonymousLinkVC.modalPresentationStyle = style
        anonymousLinkVC.dict = dict
        present(anonymousLinkVC, animated: flag, completion: nil)
    }
    
    /// 跳转SettingVC
    func PresentSettingVC(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let settingVC = SettingVC()
        let nav = UINavigationController(rootViewController: settingVC)
        settingVC.backBool = false
        nav.modalPresentationStyle = style
        present(nav, animated: flag, completion: nil)
    }
    
    /// 跳转AboutVC
    func PresentAboutVC(animated flag: Bool, presentStyle style: UIModalPresentationStyle) {
        let aboutVC = AboutVC()
        let nav = UINavigationController(rootViewController: aboutVC)
        aboutVC.backBool = false
        nav.modalPresentationStyle = style
        present(nav, animated: flag, completion: nil)
    }
    
    /// dismissAllModalController
    func disMissAllModelController(animated flag:Bool) {
        let tabbar = BaseTabBarVC()
        tabbar.needDelayJoin = getTabBarVC().needDelayJoin
        tabbar.meetingIdStr = getTabBarVC().meetingIdStr
        tabbar.passwordStr = getTabBarVC().passwordStr
        appDelegate.window?.rootViewController = tabbar
    }
    
    // MARK: Push, Pop
    /// Pop
    func poptoPreviousPage(animated flag:Bool) {
        navigationController?.popViewController(animated: flag)
    }
    
    func poptoSpecifiedPage(viewController vc:UIViewController, animated flag:Bool) {
        navigationController?.popToViewController(vc, animated: flag)
    }
    
    func poptoRootPage(animated flag:Bool) {
        navigationController?.popToRootViewController(animated: flag)
    }
    
    /// 跳转SettingVC
    func pushSettingVC(animated flag:Bool) {
        let settingVC = SettingVC()
        settingVC.hidesBottomBarWhenPushed = true
        settingVC.backBool = true
        navigationController?.pushViewController(settingVC, animated: flag)
    }
    
    /// 跳转InvitaVC
    func pushInvitaVC(animated flag:Bool) {
        let invitaVC = InvitaVC()
        invitaVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(invitaVC, animated: flag)
    }
    
    /// 跳转AboutVC
    func pushAboutVC(animated flag:Bool) {
        let aboutVC = AboutVC()
        aboutVC.backBool = true
        aboutVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(aboutVC, animated: flag)
    }
    
    /// 跳转 UserInformationVC
    func pushUserInformationVC(animated flag:Bool) {
        let userInformationVC = UserInformationVC()
        userInformationVC.hidesBottomBarWhenPushed = true
        userInformationVC.block = {
            let user = NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(userPlist))
            user.setValue("NO", forKey: loginState)
            PlistUtils.savePlistFile(user as! [AnyHashable : Any], withFileName: userPlist)
            
            self.appDelegate.hiddenNetworkWindow()
            
            self.appDelegate.evengine.logout()
            DDLogWrapper.logInfo("pushUserInformationVC evengine.logout()");
            self.whetherTheLogin()
            
            self.poptoRootPage(animated: true)
            self.tabBarController?.selectedIndex = 0
        }
        navigationController?.pushViewController(userInformationVC, animated: flag)
    }
    
    /// 跳转 ModifyPasswordVC
    func pushModifyPasswordVC(animated flag:Bool) {
        let modifyPasswordVC = ModifyPasswordVC()
        modifyPasswordVC.block = {
            let user = NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(userPlist))
            user.setValue("NO", forKey: loginState)
            PlistUtils.savePlistFile(user as! [AnyHashable : Any], withFileName: userPlist)
            
            self.appDelegate.evengine.logout()
            DDLogWrapper.logInfo("evengine.logout()");
            self.whetherTheLogin()
            
            self.poptoRootPage(animated: true)
            self.tabBarController?.selectedIndex = 0
        }
        modifyPasswordVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(modifyPasswordVC, animated: flag)
    }
    
    /// 跳转TermsServiceVC
    func pushTermsServiceVC(animated flag:Bool) {
        let termsServiceVC = TermsServiceVC()
        termsServiceVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(termsServiceVC, animated: flag)
    }
    
    /// 跳转FeedbackVC
    func pushFeedbackVC(animated flag:Bool) {
        let feedback = FeedBackVC()
        feedback.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(feedback, animated: flag)
    }
    
    // MARK: EVSDKMETHOD
    func userLogin(withServer server: String, withPort port: Int, withAccout accout: String, withPassword password :String) {
        appDelegate.isAnonymousUser = false
        //判断https
        appDelegate.evengine.enableSecure(getSetParameter(enableHttps) != nil ? getSetParameter(enableHttps)! : false)
        appDelegate.evengine.login(withLocation: server, port: UInt32(port), name: accout, password: appDelegate.evengine .encryptPassword(password))
    }
}

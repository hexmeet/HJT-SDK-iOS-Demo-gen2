//
//  UserInformationVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation
import MobileCoreServices

extension UserInformationVC {
    func initContent() {
        title = "title.infomation".localized
        
        createBackItem()
    }
    
    func tableView_(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = NormalWithImgCell.cellWithTableViewForUserInformationVC(tableView, indexRow: indexPath.row)
            return cell
        }else if indexPath.row == 1 {
            let cell = NormalCell.cellWithTableViewForUserInformationVC(tableView, indexRow: indexPath.row)
            return cell
        }else if (indexPath.row == 7) {
            let cell = LoginOutCell.cellWithTableView(tableView, indexRow: indexPath.row)
            return cell
        }else {
            let cell = NormalWithLbCell.cellWithTableViewForUserInformationVC(tableView, indexRow: indexPath.row)
            return cell
        }
    }
    
    func modifyDisPlayNameAction() {
        
        let alert = UIAlertController(title: "alert.changeName".localized, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "alert.updateName.propt".localized
            textField.text = PlistUtils.loadPlistFilewithFileName(userPlist)[displayName] as? String
        }
        alert.addAction(UIAlertAction(title: "alert.cancel".localized, style: .default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "alert.sure".localized, style: .default, handler: {[weak self] (_) in
            let textField = alert.textFields![0]
            if textField.text?.count != 0 {
                self?.appDelegate.evengine.changeDisplayName(textField.text!)
                
                DDLogWrapper.logInfo("changeDisplayName name:\(textField.text!)")
                
                let cell = self?.tab.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! NormalCell
                cell.cellDetailLb.text = textField.text!
                
                let userInfo = getUserPlist()
                userInfo.setValue(textField.text!, forKey: displayName)
                PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName:userPlist)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func loginOutAction() {
        Utils.showAlert("alert.note.loginout".localized, oneBtn: "alert.sure".localized, twoBtn: "alert.cancel".localized) {[weak self] (flag) in
            if flag {
                if self?.block != nil {
                    self?.block!()
                }
            }
        }
    }
    
    func modifyHeadImg() {
        
        Utils.showCameraAlert("takePhoto".localized, twoBtn: "takeLibrary".localized, threeBtn: "alert.cancel".localized) {[weak self] (flag) in
            if flag {
                if (self?.isCameraAvailable())! && (self?.doesCameraSupportTakingPhotos())! {
                    self?.imgPicker.sourceType = .camera
                    if (self?.isFrontCameraAvailable())! {
                        self?.imgPicker.cameraDevice = .front
                    }

                    self?.imgPicker.mediaTypes = [(kUTTypeImage as String)]
                    self?.imgPicker.delegate = self
                    self?.imgPicker.allowsEditing = false
                    self?.imgPicker.transitioningDelegate = self
                    self?.imgPicker.modalPresentationStyle = .fullScreen

                    self?.present(self!.imgPicker, animated: true, completion: {
                        DDLogWrapper.logInfo("[UI] user open camera")
                    })
                }
            }else {
                if (self?.isPhotoLibraryAvailable())! {
                    self?.imgPicker.navigationBar.isTranslucent = false
                    self?.imgPicker.navigationBar.tintColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
                    self?.imgPicker.navigationBar.barStyle = .default
                    self?.imgPicker.sourceType = .photoLibrary
                    self?.imgPicker.mediaTypes = [(kUTTypeImage as String)]
                    self?.imgPicker.delegate = self
                    self?.imgPicker.allowsEditing = false
                    self?.imgPicker.transitioningDelegate = self
                    self?.imgPicker.modalPresentationStyle = .fullScreen
                    self?.imgPicker.navigationBar.barTintColor = .white
                    UIBarButtonItem.appearance().tintColor = UIColor.black

                    self?.present(self!.imgPicker, animated: true, completion: {
                        self?.setNeedsStatusBarAppearanceUpdate()
                        DDLogWrapper.logInfo("[UI] user open PhotoLibrary")
                    })
                }
            }
        }
    }
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func doesCameraSupportTakingPhotos() -> Bool {
        return cameraSupportsMedia(String(kUTTypeImage), paramSourceType: .camera)
    }
    
    func cameraSupportsMedia(_ paramMediaType: String, paramSourceType: UIImagePickerController.SourceType) ->Bool {
        var result = false
        if paramMediaType.count == 0 {
            return result
        }
        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: paramSourceType)! as NSArray
        availableMediaTypes.enumerateObjects { (obj, idx, stop) in
            let mediaType = obj as! String
            if mediaType ==  paramMediaType {
                result = true
            }
        }
        return result
    }
    
    func isFrontCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.front)
    }
    
    func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    func imageByScalingToMaxSize(_ sourceImage: UIImage) -> UIImage {
        if sourceImage.size.width < 200.0 {
            return sourceImage
        }
        
        var btWidth = 0.0
        var btHeight = 0.0
        
        if sourceImage.size.width > sourceImage.size.height {
            btHeight = 200.0
            btWidth = Double(sourceImage.size.width * (200.0 / sourceImage.size.height))
        }else {
            btWidth = 200.0
            btHeight = Double(sourceImage.size.width * (200.0 / sourceImage.size.height))
        }
        
        let targetSize = CGSize(width: btWidth, height: btHeight)
        
        return imageByScalingAndCroppingForSourceImage(sourceImage, targetSize)
    }
    
    func imageByScalingAndCroppingForSourceImage(_ sourceImage: UIImage,_ targetSize: CGSize) -> UIImage {
        var newImage:UIImage?
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        
        if __CGSizeEqualToSize(imageSize, targetSize) == false {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            
            if widthFactor > heightFactor {
                scaleFactor = Double(widthFactor)
            }else {
                scaleFactor = Double(heightFactor)
            }
            
            scaledWidth  = width * CGFloat(scaleFactor)
            scaledHeight = height * CGFloat(scaleFactor)
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if (newImage != nil) {
            
        }
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

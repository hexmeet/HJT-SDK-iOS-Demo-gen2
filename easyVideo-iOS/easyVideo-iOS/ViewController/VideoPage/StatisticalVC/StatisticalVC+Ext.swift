//
//  StatisticalVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension StatisticalVC {
    func initContent() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        timerSecond = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(refreshStatistical), userInfo: nil, repeats: true)
    }
    
    @objc func refreshStatistical() {
        sgnalArr = appDelegate.evengine.getStats()
        
        if sgnalArr.count == 0 {
            return
        }
        let stats = sgnalArr[0]
        if stats.is_encrypted {
            statisLb.text = "\("video.statistics.title".localized)(\("video.statistics.encrypt".localized))"
        }else {
            statisLb.text = "\("video.statistics.title".localized)"
        }
        
        codecsArr.removeAllObjects()
        rateArr.removeAllObjects()
        fblArr.removeAllObjects()
        loseArr.removeAllObjects()
        loseNum.removeAllObjects()
        dataArray.removeAllObjects()
        
        for stats in sgnalArr {
            if stats.type == .audio {
                if stats.dir == .upload {
                    dataArray.add("\("video.statistics.column.thisEnd.audio".localized)")
                }else {
                    dataArray.add("\("video.statistics.column.farEnd.audio".localized)")
                }
            }else if stats.type == .video {
                if stats.dir == .upload {
                    dataArray.add("\("video.statistics.column.thisEnd.video".localized)")
                }else {
                    dataArray.add("\("video.statistics.column.farEnd.video".localized)")
                }
            }else {
                if stats.dir == .upload {
                    dataArray.add("\("video.statistics.column.thisEnd.content".localized)")
                }else {
                    dataArray.add("\("video.statistics.column.farEnd.content".localized)")
                }
            }
            
            codecsArr.add(stats.payload_type)
            rateArr.add(String(format:"%.1f", stats.real_bandwidth))
            
            if stats.type == .audio {
                fblArr.add("-")
            }else {
                fblArr.add("\(stats.resolution.width)x\(stats.resolution.height) (\(String(format:"%.1f", stats.fps)))")
            }
            
            loseArr.add("\(String(format:"%.1f", stats.packet_loss_rate))")
            loseNum.add("\(Int(stats.cum_packet_loss))")
            
            tab.reloadData()
        }
    }
}

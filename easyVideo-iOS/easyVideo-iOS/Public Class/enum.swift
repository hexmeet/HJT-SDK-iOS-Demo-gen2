//
//  enum.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/15.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

// MARK: Video display mode
enum LayoutType {
    case oneVideo //1x1
    case twovideo //1x2
    case threeVideo // 2x2
    case fourVideo // 2x2
}

enum MeetingMode {
    case mainVenueMode
    case discussionMode
}

enum LayoutMode {
    case galleryMode
    case speakerMode
}

enum VideoModeType {
    case videoMode
    case audioMode
}

enum MBProgressHUBPosition {
    case MBProgressHUBPositionTop
    case MBProgressHUBPositionCenter
    case MBProgressHUBPositionBottom
}

enum UserMode {
    case meetingMode
    case chatMode
}

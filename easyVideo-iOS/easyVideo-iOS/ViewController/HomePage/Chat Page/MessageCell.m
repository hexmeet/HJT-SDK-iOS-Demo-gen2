//
//  MessageCell.m
//  EasyVideo
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

/**
时间
 */
@property (nonatomic, weak) UILabel *timeLabel;

/**
 内容
 */
@property (nonatomic, weak) UIButton *contentBtn;

/**
 头像
 */
//@property (nonatomic, weak) UIImageView *iconView;

/**
 姓名
 */
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation MessageCell


/**
 重写init方法
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UIButton *contentBtn = [[UIButton alloc] init];
        [self.contentView addSubview:contentBtn];
        contentBtn.titleLabel.font = HQTextFont;
        contentBtn.titleLabel.numberOfLines = 0;
        [contentBtn setTitleColor:HEXCOLOR(0x313131) forState:UIControlStateNormal];
        self.contentBtn = contentBtn;
        
//        UIImageView *iconView = [[UIImageView alloc] init];
//        [self.contentView addSubview:iconView];
//        self.iconView = iconView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //清空cell的背景颜色
        self.backgroundColor = [UIColor clearColor];
//
//        self.iconView.layer.masksToBounds = YES;
//        self.iconView.layer.cornerRadius = 20;
       
        /*
        CGFloat top =
        CGFloat left,
        CGFloat bottom,
        CGFloat right
         */
        //设置按钮的内边距
        self.contentBtn.contentEdgeInsets = UIEdgeInsetsMake(HQEdgeInsets, HQEdgeInsets, HQEdgeInsets, HQEdgeInsets);
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *identifier = @"message";
    MessageCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setMessageFrame:(MessageFrameModel *)messageFrame
{
    _messageFrame = messageFrame;
    MessageModel *message = _messageFrame.message;
    //1,设置时间
    self.timeLabel.frame = messageFrame.timeF;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = message.time;
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = HEXCOLOR(0x919191);
    //2,设置头像
    if (MessageModelTypeMe == message.type) {
//        self.iconView.image = [UIImage imageNamed:@"me"];
        [self.contentBtn setBackgroundImage:[UIImage resizableImageWith:@"chat_send_nor"] forState:UIControlStateNormal];
        [self.contentBtn setTitleColor:HEXCOLOR(0x313131) forState:UIControlStateNormal];
        self.nameLabel.textColor = HEXCOLOR(0x919191);
    }else
    {
        [self.contentBtn setBackgroundImage:[UIImage resizableImageWith:@"chat_recive_nor"]  forState:UIControlStateNormal];
//        self.iconView.image = [UIImage imageNamed:@"other"];
        [self.contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nameLabel.textColor = HEXCOLOR(0x4381ff);
    }
//    self.iconView.frame = _messageFrame.iconF;
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:message.imagUrl]];
    
    //3,设置名字
    self.nameLabel.text = message.name;
    self.nameLabel.font = [UIFont systemFontOfSize:11];
//    self.nameLabel.textColor = HEXCOLOR(0x919191);
    self.nameLabel.frame = _messageFrame.nameF;
    
    //4,设置正文
    [self.contentBtn setTitle:message.content forState:UIControlStateNormal];
    self.contentBtn.frame = _messageFrame.textF;
    
//    [[EVUserIdManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray * _Nonnull results) {
//        for (EMGroupMemberInfo *user in results) {
//            if ([user.emuserId isEqualToString:message.from]) {
//                [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.imageUrl] placeholderImage:[UIImage imageNamed:@"default_image"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                    if (error != nil) {
//                        self.iconView.image = [UIImage imageNamed:@"default_image.png"];
//                    }
//                }];
//
//            }
//        }
//    } fail:nil];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  FeedBackVC.m
//  ss
//
//  Created by quanhao huang on 2020/3/1.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "FeedBackVC.h"
#import "FeedBackCell.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <TZImagePickerController.h>
#import "UIViewController+custom.h"
#import "UITextView+ExtentRange.h"
#import <sys/utsname.h>

@interface FeedBackVC ()<UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UITextViewDelegate, MBProgressHUDDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    MBProgressHUD *HUD;
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UILabel *limitWordLable;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UITextView *textView;
//@property (weak, nonatomic) IBOutlet UITextField *contactFd;
@property (weak, nonatomic) IBOutlet UITextView *contactFd;

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBackItem];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    _collection.delegate = self;
    _collection.dataSource = self;
    
    self.title = NSLocalizedString(@"set.feedback", @"意见反馈");
    _textView.delegate = self;
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    UINib *nib = [UINib nibWithNibName:@"FeedBackCell" bundle:nil];
    [_collection registerNib:nib forCellWithReuseIdentifier:@"FeedBackCell"];
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UITextView class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *objcName = [NSString stringWithUTF8String:name];
        NSLog(@"%d : %@",i,objcName);
    }
    
    [self setupplaceholderLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadProgress:) name:@"uploadProgress" object:nil];

    _contactFd.placeholdFont = [UIFont systemFontOfSize:16];
    _contactFd.placeholder = NSLocalizedString(@"set.contact.placeholder", @"填写您的手机号码或邮箱，方便我们与您联系");
    _contactFd.placeholdColor = [UIColor lightGrayColor];
    
    [_contactFd contentSizeToFit];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupplaceholderLabel{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = NSLocalizedString(@"me.feedback.placeholder", @"请填写10字以上的问题描述，以便我们更好的帮助您解决问题。");
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = HEXCOLOR(0xe1e1e1);
    [placeHolderLabel sizeToFit];
    [self.textView addSubview:placeHolderLabel];
    placeHolderLabel.font = [UIFont systemFontOfSize:16];
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

- (void)removeAction:(UIButton *)sender
{
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collection reloadData];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 200)
    {
      textView.text = [textView.text substringToIndex:200];
    }
    
    self.limitWordLable.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)[textView.text length], 200];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length > 200)
    {
       NSRange rangeIndex = [text rangeOfComposedCharacterSequenceAtIndex:200];

       if (rangeIndex.length == 1)//字数超限
       {
           textView.text = [text substringToIndex:200];
           self.limitWordLable.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, 200];
       }else{
           NSRange rangeRange = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 200)];
           textView.text = [text substringWithRange:rangeRange];
       }
        return NO;
    }
    return YES;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FeedBackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedBackCell" forIndexPath:indexPath];
    cell.removeBtn.tag = indexPath.row;
    [cell.removeBtn addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_selectedPhotos.count != 4) {
        if (indexPath.item == _selectedPhotos.count) {
            cell.img.image = [UIImage imageNamed:@"icon_upload"];
            cell.removeBtn.hidden = YES;
        }else {
            cell.img.image = _selectedPhotos[indexPath.row];
            cell.removeBtn.hidden = NO;
        }
    }else {
        cell.img.image = _selectedPhotos[indexPath.row];
        cell.removeBtn.hidden = NO;
    }
        
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_selectedPhotos.count == 4) {
        return 4;
    }else{
        return _selectedPhotos.count+1;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedPhotos.count != 4 && indexPath.row == _selectedPhotos.count) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        imagePickerVc.maxImagesCount = 4;
        imagePickerVc.allowPickingVideo = false;
        imagePickerVc.allowPickingOriginalPhoto = true;
        imagePickerVc.allowTakeVideo = false;
        imagePickerVc.allowTakePicture = false;
        imagePickerVc.selectedAssets = _selectedAssets;
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
            self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
            [self->_collection reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {

    return UIEdgeInsetsMake(0, 0, 0, 0);;
}
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
    return 0;
}

- (IBAction)submitAction:(id)sender {
    
    ZipArchive *zip = [[ZipArchive alloc] init];

    NSString *path = [FileTools getDocumentsFailePath];
    NSString *logPath = [path stringByAppendingPathComponent:@"Log"];
    NSString *zipPath = [logPath stringByAppendingPathComponent:@"log.zip"];
    
    for (int i = 0; i < 4; i++) {
        NSString *imgPath = [logPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png", i]];
        if ([FileTools isExistWithFile:imgPath]) {
            [FileTools deleteTheFileWithFilePath:imgPath];
        }
    }
    
    //将图片写入磁盘
    if (_selectedPhotos.count != 0) {
        for (int i = 0; i < _selectedPhotos.count; i++) {
            NSData *data = [self zipNSDataWithImage:_selectedPhotos[i]];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];

            NSString * ImagePath = [NSString stringWithFormat:@"/%d.png", i];
            [fileManager createFileAtPath:[logPath stringByAppendingString:ImagePath] contents:data attributes:nil];
        }
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:logPath];
    
    if ([FileTools isExistWithFile:zipPath]) {
        [FileTools deleteTheFileWithFilePath:zipPath];
    }
    
    NSMutableArray *logArr = [NSMutableArray arrayWithCapacity:1];
    NSString *fileName;
    while (fileName = [dirEnum nextObject]) {
        [logArr addObject:fileName];
    }
    
    if ([zip CreateZipFile2:zipPath]) {
        for (NSString *fileName in logArr) {
            [zip addFileToZip:[logPath stringByAppendingPathComponent:fileName] newname:fileName];
        }
    }
    
    if ([FileTools isExistWithFile:[path stringByAppendingPathComponent:@"emsdk1.log"]]) {
        [zip addFileToZip:[path stringByAppendingPathComponent:@"emsdk1.log"] newname:@"emsdk1.log"];
    }
    if ([FileTools isExistWithFile:[path stringByAppendingPathComponent:@"emsdk2.log"]]) {
        [zip addFileToZip:[path stringByAppendingPathComponent:@"emsdk2.log"] newname:@"emsdk2.log"];
    }
    if ([FileTools isExistWithFile:[path stringByAppendingPathComponent:@"emsdk3.log"]]) {
        [zip addFileToZip:[path stringByAppendingPathComponent:@"emsdk3.log"] newname:@"emsdk3.log"];
    }
    
    if( ![zip CloseZipFile2] ){
        
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabel.text = NSLocalizedString(@"alert.upload", @"上传中");
    HUD.margin = 10;
    HUD.delegate = self;
    [HUD showAnimated:YES];
    [appDelegate.evengine uploadFeedbackFiles:zipPath contact:_contactFd.text description:_textView.text];
}

- (void)uploadProgress:(NSNotification *)sender {
    NSDictionary *dic = sender.userInfo;
    int progress = [dic[@"Progress"] intValue];
    if (progress < 0) {
        HUD.detailsLabel.text = NSLocalizedString(@"alert.uploaded.failed", @"上传失败");
    }else if (progress == 100) {
        HUD.detailsLabel.text = NSLocalizedString(@"alert.uploaded.successfully", @"上传成功");
    }
    
    [HUD hideAnimated:YES afterDelay:2];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if ([hud.detailsLabel.text isEqualToString:NSLocalizedString(@"alert.uploaded.successfully", @"上传成功")]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
\
- (NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280||height>1280) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
    //2.宽大于1280高小于1280
    }else if(width>1280||height<1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
    //3.宽小于1280高大于1280
    }else if(width<1280||height>1280){
        CGFloat scale = width/height;
        height = 1280;
        width = height*scale;
    //4.宽高都小于1280
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return data;
}
 
@end

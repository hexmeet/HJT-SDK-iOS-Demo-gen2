//
//  GSCollectionViewFlowLayout.m
//  ss
//
//  Created by quanhao huang on 2020/3/1.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "GSCollectionViewFlowLayout.h"

@implementation GSCollectionViewFlowLayout

#pragma mark - 初始化layout的结构和初始需要的参数
- (void)prepareLayout
{
    [super prepareLayout];
}

//#pragma mark - cell的左右间距

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
   
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index];
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1];
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ?
        nil : layoutAttributes[index+1];

        [layoutAttributesTemp addObject:currentAttr];
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
   
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                
            }else{
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
       
        else if( currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}

- (void)setCellFrameWith:(NSMutableArray*)layoutAttributes{
    CGFloat nowWidth = 0.0;
    
    nowWidth = self.sectionInset.left;
    for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
        CGRect nowFrame = attributes.frame;
        nowFrame.origin.x = nowWidth;
        attributes.frame = nowFrame;
        nowWidth += nowFrame.size.width + 10;
    }
    
    [layoutAttributes removeAllObjects];
}

@end

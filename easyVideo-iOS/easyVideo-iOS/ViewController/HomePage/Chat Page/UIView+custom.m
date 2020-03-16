
#import "UIView+custom.h"

@implementation UIView (custom)

-(UIView*)drawLineWithRect:(CGRect)frame Color:(UIColor*)color AutoSizeMask:(UIViewAutoresizing)mask
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = color;
    line.autoresizingMask = mask;
    [self addSubview:line];
    
    return line;
}

@end

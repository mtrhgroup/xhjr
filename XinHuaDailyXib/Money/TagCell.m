//
//  TagCell.m
//  XinHuaDailyXib
//
//  Created by apple on 14/11/13.
//
//

#import "TagCell.h"
@implementation TagCell{
    NSString *_tag;
    UILabel *tag_lbl;
        CAShapeLayer *_shapeLayer;
}
- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self drawDashedBorder];
        tag_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0, frameRect.size.width, frameRect.size.height)];
        tag_lbl.backgroundColor = [UIColor clearColor];
        tag_lbl.text = @"";
        tag_lbl.textAlignment=NSTextAlignmentCenter;
        tag_lbl.textColor = [UIColor blackColor];
        tag_lbl.font = [UIFont fontWithName:@"Arial" size:15];
        [[self contentView] addSubview:tag_lbl];
    }
    return self;
}
-(NSString *)tag{
    return _tag;
}
-(void)setTag:(NSString *)tag{
    if(_tag==nil||![_tag isEqualToString:tag]){
        _tag=tag;
        tag_lbl.text=tag;
    }
}
- (void)drawDashedBorder
{
    if (_shapeLayer) [_shapeLayer removeFromSuperlayer];
    
    //border definitions
    CGFloat cornerRadius = 10;
    CGFloat borderWidth = 1;
    
    //drawing
    CGRect frame = self.bounds;
    
    _shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:4], [NSNumber numberWithInt:4], nil];
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [self.layer addSublayer:_shapeLayer];
    self.layer.cornerRadius = cornerRadius;
}
@end

//
//  GraphView.m
//  Calculator
//
//  Created by deng zhiping on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;
@synthesize origin = _origin;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
    
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)tap:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [gesture locationInView:self];
        
        // see midPoint
        self.origin = CGPointMake(p.x - self.bounds.size.width / 2, 
                                  p.y - (self.bounds.size.height - 40) / 2);
    }
}


#define DEFAULT_SCALE 10

- (CGFloat)scale
{
    if (!_scale) {
        _scale = [[NSUserDefaults standardUserDefaults] doubleForKey:@"scale"];
        if (!_scale) 
            _scale = DEFAULT_SCALE;
    }
    return _scale;
}

- (void)setScale:(CGFloat)scale
{
    if (_scale != scale) {
        _scale = scale;
        [[NSUserDefaults standardUserDefaults] setDouble:_scale forKey:@"scale"];
        [self setNeedsDisplay];
    }
}

- (CGPoint)origin
{
    _origin.x = [[NSUserDefaults standardUserDefaults] doubleForKey:@"origin.x"];
    _origin.y = [[NSUserDefaults standardUserDefaults] doubleForKey:@"origin.y"];
    return _origin;
}

- (void)setOrigin:(CGPoint)origin
{
    if (_origin.x != origin.x || _origin.y != origin.y) {
        _origin = origin;
        [[NSUserDefaults standardUserDefaults] setDouble:origin.x forKey:@"origin.x"];
        [[NSUserDefaults standardUserDefaults] setDouble:origin.y forKey:@"origin.y"];

        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGRect drawRect = self.bounds;
    
    drawRect.origin.x = 0;
    drawRect.origin.y = 40;
    drawRect.size.height -= drawRect.origin.y;
    
    CGPoint midPoint;
    midPoint.x = self.origin.x + drawRect.size.width / 2;
    midPoint.y = self.origin.y + drawRect.size.height / 2;

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [AxesDrawer drawAxesInRect:drawRect originAtPoint:midPoint scale:self.scale];
 
    [[UIColor blueColor] setFill];
    [[UIColor blueColor] setStroke];
    
    double X = ((drawRect.size.width / self.scale) / 2.0 + self.origin.x / self.scale);
    
    CGFloat x, y, x2, y2;
    CGContextBeginPath(context);
    x = drawRect.origin.x;
    y = [self.dataSource valueFor:x];
    y2 = (drawRect.origin.y + drawRect.size.height / 2) - (y * self.scale);

    CGContextMoveToPoint(context, x, y2); 
    float step = 1.0 / self.contentScaleFactor;
    for (x = drawRect.origin.x; x < drawRect.origin.x + drawRect.size.width; x += step) {
        x2 = -X + (x - drawRect.origin.x) / self.scale;
        y = [self.dataSource valueFor:x2];
        y2 = (self.origin.y + drawRect.size.height / 2) - (y * self.scale);

        CGContextAddLineToPoint(context, x, y2);
    }
    CGContextStrokePath(context);
}


@end

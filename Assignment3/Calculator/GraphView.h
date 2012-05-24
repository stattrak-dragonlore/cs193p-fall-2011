//
//  GraphView.h
//  Calculator
//
//  Created by deng zhiping on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDataSource <NSObject>

- (double)valueFor:(double)x;

@end

@interface GraphView : UIView

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)tap:(UIPanGestureRecognizer *)gesture;



@end

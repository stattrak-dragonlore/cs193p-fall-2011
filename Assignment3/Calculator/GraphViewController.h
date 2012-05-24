//
//  GraphViewController.h
//  Calculator
//
//  Created by deng zhiping on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *description;
@property (nonatomic) NSString *programString;
@property (nonatomic) id program;

@end

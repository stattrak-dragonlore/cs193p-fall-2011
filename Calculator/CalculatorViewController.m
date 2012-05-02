//
//  CalculatorViewController.m
//  Calculator
//
//  Created by deng zhiping on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userEntering;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSString *historyContent;
@end

@implementation CalculatorViewController
@synthesize history = _history;
@synthesize display = _display;
@synthesize userEntering = _userEntering;
@synthesize brain = _brain;
@synthesize historyContent = _historyContent;

- (CalculatorBrain *)brain
{
    if (!_brain)
        _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSString *)historyContent
{
    if (!_historyContent)
        _historyContent = [[NSString alloc] init];
    return _historyContent;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    
    //NSLog(@"digit %@ pressed", digit);

    if (self.userEntering) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userEntering = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userEntering) {
        /* just change the sign of current display */
        if ([sender.currentTitle isEqualToString:@"+/-"]) {
            if ([self.display.text hasPrefix:@"-"]) {
                self.display.text = [self.display.text substringFromIndex:1];
            } else {
                self.display.text = [@"-" stringByAppendingString:self.display.text];
            }
            return;
        } 
        
        [self enterPressed];
    }
    
    self.historyContent = [self.historyContent stringByAppendingFormat:@" %@", sender.currentTitle];
     
    self.history.text = [self.historyContent stringByAppendingString:@" ="];

    double result = [self.brain performOperation:[sender currentTitle]];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    
    self.display.text = resultString;
}

- (IBAction)dotPressed 
{
    if (self.userEntering) {
        if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    } else {
        self.display.text = @".";
        self.userEntering = YES;
    }
    
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];

    self.historyContent = [self.historyContent stringByAppendingFormat:@" %@", self.display.text];
    self.history.text = self.historyContent;
    self.userEntering = NO;
}

- (IBAction)clearPressed 
{
    [self.brain clear];
    self.historyContent = @"";
    self.history.text = self.historyContent;
    self.userEntering = NO;
    self.display.text = @"0";
}

- (IBAction)backspacePressed 
{
    if (self.userEntering) {
        if (([self.display.text length] == 1) || 
            ([self.display.text hasPrefix:@"-"] && self.display.text.length == 2)) {
            self.display.text = @"0";
            self.userEntering = NO;
        } else {
            self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
        }
    }

}

@end

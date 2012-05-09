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
@property (nonatomic, strong) NSDictionary *testVaribleValues;
@end

@implementation CalculatorViewController
@synthesize history = _history;
@synthesize display = _display;
@synthesize variblesDisplay = _variblesDisplay;
@synthesize userEntering = _userEntering;
@synthesize brain = _brain;
@synthesize testVaribleValues = _testVaribleValues;

- (CalculatorBrain *)brain
{
    if (!_brain)
        _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


- (NSDictionary *)testVaribleValues
{
    if (!_testVaribleValues)
        _testVaribleValues = [[NSDictionary alloc] init];
    return _testVaribleValues;
}


- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    
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
    
    double result = [self.brain performOperation:[sender currentTitle] usingVariblevalues:self.testVaribleValues];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];

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

    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    self.userEntering = NO;
}


- (IBAction)clearPressed 
{
    [self.brain clear];
    self.history.text = @"";
    self.userEntering = NO;
    self.display.text = @"0";
    self.variblesDisplay.text = @"";
    self.testVaribleValues = nil;
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

- (IBAction)variblePressed:(UIButton *)sender 
{
    NSString *varible = sender.currentTitle;
    if (self.userEntering) {
        [self enterPressed];
    }
    self.display.text = varible;
    [self.brain pushVariable:varible];
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
}

- (IBAction)setTestVaribleValures:(UIButton *)sender 
{
    NSDictionary *varibleValues = nil;
    if ([sender.currentTitle isEqualToString:@"Test 1"]) {
        varibleValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1], @"x", [NSNumber numberWithDouble:10], @"y", [NSNumber numberWithDouble:-3.2], @"z", nil];
    } else if ([sender.currentTitle isEqualToString:@"Test 2"]) {
        varibleValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:2], @"x", [NSNumber numberWithDouble:3], @"y", [NSNumber numberWithDouble:-1], @"z", nil];
    
    } else if ([sender.currentTitle isEqualToString:@"Test 3"]) {
        varibleValues = nil;
        }
    self.testVaribleValues = varibleValues;

    [self updateDisplay];
 }

- (IBAction)undoPressed 
{
    if (self.userEntering) {
        if ([self.display.text length] == 1) {
            [self updateDisplay];
            self.userEntering = NO;
        } else {
            self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
        }
    } else {
        [self.brain popTheTop];
        [self updateDisplay];
    }
}


- (void)updateDisplay
{
    double result = [[self.brain class] runProgram:self.brain.program usingVariableValues:self.testVaribleValues];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    
    NSSet *varibles = [[self.brain class] variablesUsedInProgram:self.brain.program];
    
    NSString *variblesString = @"";
    for (NSString *v in varibles) {
        NSNumber *value = [self.testVaribleValues valueForKey:v];
        variblesString = [variblesString stringByAppendingFormat:@"%@ = %g, ", v, [value doubleValue]];
    }
    
    self.variblesDisplay.text = variblesString;


}

@end

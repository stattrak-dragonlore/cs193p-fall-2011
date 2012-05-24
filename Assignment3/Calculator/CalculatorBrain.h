//
//  CalculatorBrain.h
//  Calculator
//
//  Created by deng zhiping on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variable;
- (void)popTheTop;
- (double)performOperation:(NSString *)operation usingVariblevalues:(NSDictionary *)varibleValues;
- (void)clear;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)varibleValues;
+ (NSSet *)variablesUsedInProgram:(id)program; 
                                                ;

@end

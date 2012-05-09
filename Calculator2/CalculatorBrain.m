//
//  CalculatorBrain.m
//  Calculator
//
//  Created by deng zhiping on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "math.h"
#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;

//+ (BOOL)isOperation:(id)element;
//+ (BOOL)isVarible:(id)element;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (id)program
{
    return [self.programStack copy];
}

- (NSMutableArray *)programStack
{
    if (!_programStack)
        _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}


- (double)performOperation:(NSString *)operation usingVariblevalues:(NSDictionary *)varibleValues
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:varibleValues];
}

+ (BOOL)isOperation:(NSString *)element
{
/*    if (![element isKindOfClass:[NSString class]])
        return NO;
 */
    NSSet *operationSet;
    operationSet = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"sin", 
                    @"cos", @"pi", @"sqrt", @"log", @"+/-", @"e", nil];
    return [operationSet containsObject:element];
}

+ (BOOL)isSingleOperandOperation:(NSString *)operation
{
    if ([operation isEqualToString:@"sqrt"] ||
        [operation isEqualToString:@"log"] ||
        [operation isEqualToString:@"+/-"] ||
        [operation isEqualToString:@"sin"] ||
        [operation isEqualToString:@"cos"])
        return YES;
    return NO;
}

+ (BOOL)isDoubleOperandOperation:(NSString *)operation
{
    if ([operation isEqualToString:@"+"]  ||
        [operation isEqualToString:@"-"]  ||
        [operation isEqualToString:@"*"]  ||
        [operation isEqualToString:@"/"])
        return YES;
    return NO;
}

+ (BOOL)isNoOperandOpeartion:(NSString *)operation
{
    if ([operation isEqualToString:@"pi"] ||
        [operation isEqualToString:@"e"])
        return YES;
    return NO;
}


+ (BOOL)isVarible:(id)element
{
    if (![element isKindOfClass:[NSString class]])
        return NO;
    return ![self isOperation:element];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)varibleValues
{
    NSMutableArray *stack = nil;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        for (int i = 0; i < [stack count]; i++) {
            id element = [stack objectAtIndex:i];
            if ([self isVarible:element]) {
                id value = [varibleValues valueForKey:element];
                if (value) {
                    [stack replaceObjectAtIndex:i withObject:value];
                } else {
                    [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:0]];
                }
            }
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program; 
{
    /* http://codereview.stackexchange.com/questions/8691/scanning-an-nsarray-to-produce-an-nsset */
    if ([program isKindOfClass:[NSArray class]]) {
        NSSet *programSet = [NSSet setWithArray:program];
        NSSet *varibles = [programSet objectsPassingTest:^BOOL (id obj, BOOL *stop) {
            return [self isVarible:obj];
        }];
        return [varibles count] > 0 ? varibles : nil;
    } 
    return nil;
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack)
        [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;

        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            result = - [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) {
                result = [self popOperandOffProgramStack:stack] / divisor;
            } else {
                result = 0;
            }
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"pi"]) {
            result = acos(0) * 2;
        } else if ([operation isEqualToString:@"e"]) {
            result = M_E;
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"log"]) {
            result = log([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"+/-"]) {
            result = (-1) * [self popOperandOffProgramStack:stack];
        }
    }
    
    return result;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    id topOfStack = [stack lastObject];
    if (topOfStack) 
        [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack stringValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        if ([self isNoOperandOpeartion:topOfStack]) {
            return topOfStack;
        } else if ([self isSingleOperandOperation:topOfStack]) {
            return [NSString stringWithFormat:@"%@(%@)", topOfStack, [self descriptionOfTopOfStack:stack]];
        } else if ([self isDoubleOperandOperation:topOfStack]) {
            NSString *top1 = [self descriptionOfTopOfStack:stack];
            NSString *top2 = [self descriptionOfTopOfStack:stack];
            return [NSString stringWithFormat:@"(%@ %@ %@)", top2, topOfStack, top1];
        } else 
            /* varible */
            return topOfStack;
    }
    return @"";
}


+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack = nil;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    } 
    
    NSString *description = @"";
    while ([stack count]) {
        if ([description isEqualToString:@""]) 
            description = [self descriptionOfTopOfStack:stack];
        else 
            description = [description stringByAppendingFormat:@", %@",
                           [self descriptionOfTopOfStack:stack]];
    }
    return description;
}

- (void)popTheTop
{
    [self.programStack removeLastObject];
}

- (void)clear
{
    [self.programStack removeAllObjects];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"stack: %@", [self.programStack description]];
}


@end

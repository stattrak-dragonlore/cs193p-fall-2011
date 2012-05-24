//
//  GraphViewController.m
//  Calculator
//
//  Created by deng zhiping on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;

@end

@implementation GraphViewController
@synthesize description = _description;
@synthesize graphView = _graphView;
@synthesize programString = _programString;
@synthesize program;

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
    self.description.text = self.programString;
    UIPinchGestureRecognizer *pingr = [[UIPinchGestureRecognizer alloc] initWithTarget:graphView action:@selector(pinch:)];
    UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:graphView action:@selector(pan:)];
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:graphView action:@selector(tap:)];
    tapgr.numberOfTapsRequired = 3;

    [graphView addGestureRecognizer:pingr];
    [graphView addGestureRecognizer:pangr];
    [graphView addGestureRecognizer:tapgr];
}


- (double)valueFor:(double)x
{
    NSDictionary *varibles = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:x] forKey:@"x"];

    return [CalculatorBrain runProgram:self.program usingVariableValues:varibles];
}


@end

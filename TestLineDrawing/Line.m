//
//  Line.m
//  TestLineDrawing
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "Line.h"

@implementation Line

+ (id) lineWithPointA:(CGPoint) pointA pointB:(CGPoint) pointB
{
    Line *line = [[Line alloc] init];
    line.pointA = pointA;
    line.pointB = pointB;
    
    return line;
}

- (void) draw
{
    
}
@end

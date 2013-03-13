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
    CGFloat colourGeen[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColor(c, colourGeen);
    
    CGContextMoveToPoint(c, self.pointA.x, self.pointA.y);
    CGContextAddLineToPoint(c, self.pointB.x, self.pointB.y);
    
    CGContextStrokePath(c);
}
@end

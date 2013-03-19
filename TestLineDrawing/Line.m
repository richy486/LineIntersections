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

// http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=geometry2
+ (BOOL) intersectionsPoint1a:(CGPoint) point1a point1b:(CGPoint) point1b
                      point2a:(CGPoint) point2a point2b:(CGPoint) point2b
           intersectingPointX:(double*) intersectingPointX
           intersectingPointY:(double*) intersectingPointY
{
    double A1 = point1b.y - point1a.y;
    double B1 = point1a.x - point1b.x;
    double C1 = A1 * point1a.x + B1 * point1a.y;
    
    double A2 = point2b.y - point2a.y;
    double B2 = point2a.x - point2b.x;
    double C2 = A2 * point2a.x + B2 * point2a.y;
    
    double det = A1*B2 - A2*B1;
    
    double x, y;
    if(det == 0){
        return NO;
    }else{
        x = (B2*C1 - B1*C2)/det;
        y = (A1*C2 - A2*C1)/det;
        
        
    }
    
    BOOL onLineX1 = MIN(point1a.x, point1b.x) <= x + TOLL && x - TOLL <= MAX(point1a.x, point1b.x);
    BOOL onLineY1 = MIN(point1a.y, point1b.y) <= y + TOLL && y - TOLL <= MAX(point1a.y, point1b.y);
    BOOL onLineX2 = MIN(point2a.x, point2b.x) <= x + TOLL && x - TOLL <= MAX(point2a.x, point2b.x);
    BOOL onLineY2 = MIN(point2a.y, point2b.y) <= y + TOLL && y - TOLL <= MAX(point2a.y, point2b.y);
    
    *intersectingPointX = x;
    *intersectingPointY = y;
    
    if (onLineX1 && onLineY1 && onLineX2 && onLineY2)
    {
        return YES;
    }
    return NO;
}

- (BOOL) intersectionsPointB:(CGPoint) pointA pointA:(CGPoint) pointB
          intersectingPointX:(double*) intersectingPointX
          intersectingPointY:(double*) intersectingPointY
{
    return [Line intersectionsPoint1a:pointA point1b:pointB point2a:self.pointA point2b:self.pointB intersectingPointX:intersectingPointX intersectingPointY:intersectingPointY];
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

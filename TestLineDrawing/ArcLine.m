//
//  ArcLine.m
//  TestLineDrawing
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "ArcLine.h"

@implementation ArcLine
+ (id) lineWithPointA:(CGPoint) pointA pointB:(CGPoint) pointB radius:(double) radius chord:(double) chord angle:(double) angle
{
    ArcLine *arcLine = [[ArcLine alloc] init];
    arcLine.pointA = pointA;
    arcLine.pointB = pointB;
    arcLine.radius = radius;
    arcLine.chord = chord;
    arcLine.angle = angle;
    
    if (radius*2 < chord)
    {
        NSLog(@"waning diamater (%.02f) is less than chord (%.02f)", radius*2, chord);
    }
    
    return arcLine;
}

- (void) draw
{
    CGFloat colourOrange[4] = {1.0f, 0.5f, 0.0f, 1.0f};
    CGFloat colourGreen[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    CGFloat colourYellow[4] = {1.0f, 1.0f, 0.0f, 1.0f};
    
    
    // theta = 2 arcsin(c/[2r]),
    CGFloat theta = 2 * asin(self.chord / (2 * self.radius));

    CGFloat startPoint = -self.angle - (theta/2) - M_PI_2;
    CGFloat endPoint = startPoint + theta;
    
    double height = self.radius - (self.radius * (1 - cos(theta/2)));
    double centreOfPointsX = self.pointA.x + 0.5 * (self.pointB.x - self.pointA.x);
    double centreOfPointsY = self.pointA.y + 0.5 * (self.pointB.y - self.pointA.y);
    double rotateAngle = self.angle + M_PI_2;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, rotateAngle);
    transform = CGAffineTransformTranslate(transform, 0, height);
    transform = CGAffineTransformRotate(transform, -rotateAngle);
    transform = CGAffineTransformTranslate(transform, centreOfPointsX, centreOfPointsY);
    
    CGPoint point = CGPointApplyAffineTransform(CGPointMake(0, 0), transform);
    
    
    BOOL clockwise = YES;
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColor(c, colourOrange);
    CGContextAddArc(c,
                    point.x,
                    point.y,
                    self.radius,
                    startPoint,
                    endPoint,
                    clockwise ? 0 : 1); // UIView flips the Y-coordinate
    CGContextStrokePath(c);
    
    
    
    
//    {
//        CGContextRef c = UIGraphicsGetCurrentContext();
//        CGContextSetStrokeColor(c, colourYellow);
//        CGContextMoveToPoint(c
//                             , point.x + self.radius * cos(startPoint)
//                             , point.y + self.radius * sin(startPoint));
//        CGContextAddLineToPoint(c
//                                , point.x + self.radius * cos(endPoint)
//                                , point.y + self.radius * sin(endPoint));
//        CGContextStrokePath(c);
//    }
}
@end

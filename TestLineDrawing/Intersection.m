//
//  Intersection.m
//  TestLineDrawing
//
//  Created by Richard Adem on 12/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "Intersection.h"

@implementation Intersection

+ (id) intersectionWithX:(double) x Y:(double) y
                 point1a:(CGPoint) point1a point1b:(CGPoint) point1b
                 point2a:(CGPoint) point2a point2b:(CGPoint) point2b
{
    Intersection *intersection = [[Intersection alloc] init];
    intersection.intersectionX = x;
    intersection.intersectionY = y;
    intersection.linePoint1a = point1a;
    intersection.linePoint1b = point1b;
    intersection.linePoint2a = point2a;
    intersection.linePoint2b = point2b;
    
    return intersection;
}

@end

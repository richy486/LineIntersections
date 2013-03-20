//
//  ArcLine.h
//  TestLineDrawing
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"

@interface ArcLine : Line
@property (nonatomic) double radius;
@property (nonatomic) double chord;
@property (nonatomic) double angle;
@property (nonatomic) BOOL inward;

+ (id) lineWithPointA:(CGPoint) pointA pointB:(CGPoint) pointB radius:(double) radius chord:(double) chord angle:(double) angle;
- (BOOL) intersectionsPointA:(CGPoint) pointA pointB:(CGPoint) pointB
          intersectingPointX:(double*) intersectingPointX
          intersectingPointY:(double*) intersectingPointY;
- (BOOL) intersectionsPointA:(CGPoint) pointA pointB:(CGPoint) pointB
         intersectingPoint1X:(double*) intersectingPoint1X
         intersectingPoint1Y:(double*) intersectingPoint1Y
         intersectingPoint2X:(double*) intersectingPoint2X
         intersectingPoint2Y:(double*) intersectingPoint2Y;

- (void) calculateAngle;
@end

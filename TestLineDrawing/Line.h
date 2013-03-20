//
//  Line.h
//  TestLineDrawing
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject
@property (nonatomic) CGPoint pointA;
@property (nonatomic) CGPoint pointB;

+ (id) lineWithPointA:(CGPoint) pointA pointB:(CGPoint) pointB;
+ (BOOL) intersectionsPoint1a:(CGPoint) point1a point1b:(CGPoint) point1b
                      point2a:(CGPoint) point2a point2b:(CGPoint) point2b
           intersectingPointX:(double*) intersectingPointX
           intersectingPointY:(double*) intersectingPointY;
- (BOOL) intersectionsPointA:(CGPoint) pointA pointB:(CGPoint) pointB
          intersectingPointX:(double*) intersectingPointX
          intersectingPointY:(double*) intersectingPointY;
- (void) draw;
@end

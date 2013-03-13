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

+ (id) lineWithPointA:(CGPoint) pointA pointB:(CGPoint) pointB radius:(double) radius chord:(double) chord angle:(double) angle;
@end

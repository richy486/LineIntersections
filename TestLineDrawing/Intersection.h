//
//  Intersection.h
//  TestLineDrawing
//
//  Created by Richard Adem on 12/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Intersection : NSObject
@property (nonatomic) double intersectionX;
@property (nonatomic) double intersectionY;
@property (nonatomic) CGPoint linePoint1a;
@property (nonatomic) CGPoint linePoint1b;
@property (nonatomic) CGPoint linePoint2a;
@property (nonatomic) CGPoint linePoint2b;

+ (id) intersectionWithX:(double) x Y:(double) y
                 point1a:(CGPoint) point1a point1b:(CGPoint) point1b
                 point2a:(CGPoint) point2a point2b:(CGPoint) point2b;
@end

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
@end

//
//  Maths.h
//  TestLineDrawing
//
//  Created by Richard Adem on 19/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Maths : NSObject

+ (float) dot:(CGPoint)p1 andPoint:(CGPoint)p2;
+ (double) wrap:(double) value max:(double) max min:(double) min;
@end

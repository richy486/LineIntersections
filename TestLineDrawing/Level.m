//
//  Level.m
//  TestLineDrawing
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "Level.h"
#import "Line.h"

@interface Level()
{
    float _rotation;
}
@end

@implementation Level
+ (id)sharedInstance
{
    static id state = nil;
    if (!state)
    {
        @synchronized(self)
        {
            if (!state)
            {
                state = [[self alloc] init];
            }
        }
    }
    
    return state;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _rotation = 0.0;
        [self setPlayerPosition: CGPointMake(100.0, 100.0)];
    }
    return self;
}

#pragma mark - getters setters

- (float) rotation
{
    return _rotation;
}
- (void) setRotation:(float)val
{
    _rotation = val;
    
    for (Line *line in [self levelLines])
    {
        [line setPointA:[self rotatePoint:line.pointA by:_rotation]];
        [line setPointB:[self rotatePoint:line.pointB by:_rotation]];
    }
}

- (CGPoint) rotatePoint:(CGPoint) point by:(float) rotation
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, LEVEL_OFFSET, LEVEL_OFFSET);
    transform = CGAffineTransformRotate(transform, rotation);
    transform = CGAffineTransformTranslate(transform, -LEVEL_OFFSET, -LEVEL_OFFSET);
    
    CGPoint pointRot = CGPointApplyAffineTransform(point, transform);
    
    return pointRot;
}
@end

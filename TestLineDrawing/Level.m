//
//  Level.m
//  TestLineDrawing
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "Level.h"

@interface Level()
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
        [self setPlayerPosition: CGPointMake(100.0, 100.0)];
    }
    return self;
}
@end

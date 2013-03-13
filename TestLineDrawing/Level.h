//
//  Level.h
//  TestLineDrawing
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject
@property (nonatomic, strong) NSMutableArray *levelLines;
@property (nonatomic, strong) NSMutableArray *playerPoints;
@property (nonatomic) CGPoint playerPosition;
+ (id)sharedInstance;
@end

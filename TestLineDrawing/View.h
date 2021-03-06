//
//  View.h
//  TestLineDrawing
//
//  Created by Richard Adem on 8/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View : UIView


@property (nonatomic, strong) NSArray *linesIntersecting;
@property (nonatomic, strong) NSArray *intersectingPoints;
@property (nonatomic, strong) NSMutableArray *intersectingLines;

- (float) rotation;
- (void) setRotation:(float)val;
@end

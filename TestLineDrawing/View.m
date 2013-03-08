//
//  View.m
//  TestLineDrawing
//
//  Created by Richard Adem on 8/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "View.h"

@implementation View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor lightGrayColor]];
        self.tapPoint = CGPointMake(100.0, 100.0);
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [self drawPath];
    [self drawTapPoint];
    [self drawIntersectingPoints];
}

- (void) drawPath
{
    if (self.points && [self.points count] > 0)
    {
//        CGContextRef c = UIGraphicsGetCurrentContext();
//        
//        CGFloat colourBlack[4] = {0.0f, 0.0f, 0.0f, 1.0f};
//        CGFloat colourRed[4] = {1.0f, 0.0f, 0.0f, 1.0f};
//        CGFloat colourGeen[4] = {0.0f, 1.0f, 0.0f, 1.0f};
//        CGContextSetStrokeColor(c, colourBlack);
//        CGContextBeginPath(c);
//        
//        NSInteger i = 0;
//        CGPoint firstPoint;
//        for (NSValue *val in self.points)
//        {
//            if (i == 3)
//            {
//                CGContextSetStrokeColor(c, colourRed);
//            }
//            else
//            {
//                CGContextSetStrokeColor(c, colourGeen);
//            }
//            
//            CGPoint point = [val CGPointValue];
//            
//            
//            
//            if (i == 0)
//            {
//                CGContextMoveToPoint(c, point.x, point.y);
//                firstPoint = point;
//            }
//            else
//            {
//                CGContextAddLineToPoint(c, point.x, point.y);
//            }
//            
//            ++i;
//        }
//        CGContextAddLineToPoint(c, firstPoint.x, firstPoint.y);
//        
//        CGContextStrokePath(c);
        
        
        CGFloat colourRed[4] = {1.0f, 0.0f, 0.0f, 1.0f};
        CGFloat colourGeen[4] = {0.0f, 1.0f, 0.0f, 1.0f};
        
        for (NSInteger i = 1; i < [self.points count] + 1; ++i)
        {
            NSInteger indexA = i-1;
            NSInteger indexB = i == [self.points count] ? 0 : i;
            
            NSValue *val2a = [self.points objectAtIndex:indexA];
            CGPoint point2a = [val2a CGPointValue];
            NSValue *val2b = [self.points objectAtIndex:indexB];
            CGPoint point2b = [val2b CGPointValue];
            
            CGContextRef c = UIGraphicsGetCurrentContext();
            
            
            
            if (self.linesIntersecting && i - 1 < [self.linesIntersecting count]
                && [[self.linesIntersecting objectAtIndex:i - 1] boolValue] == YES)
            {
                CGContextSetStrokeColor(c, colourRed);
            }
            else
            {
                CGContextSetStrokeColor(c, colourGeen);
            }
            
            CGContextMoveToPoint(c, point2a.x, point2a.y);
            CGContextAddLineToPoint(c, point2b.x, point2b.y);
            
            CGContextStrokePath(c);
        }
    }
}

- (void) drawTapPoint
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGFloat colour[4] = {0.0f, 0.0f, 1.0f, 1.0f};
    CGContextSetStrokeColor(c, colour);
    CGContextAddEllipseInRect(c, CGRectMake(self.tapPoint.x - 2, self.tapPoint.y - 2, 4, 4));
    CGContextStrokePath(c);
    
    CGContextSetStrokeColor(c, colour);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0, self.tapPoint.y);
    CGContextAddLineToPoint(c, self.tapPoint.x, self.tapPoint.y);
    CGContextStrokePath(c);
}


- (void) drawIntersectingPoints
{
    if (self.intersectingPoints)
    {
        for (NSValue *val in self.intersectingPoints)
        {
            CGPoint point = [val CGPointValue];
            
            CGContextRef c = UIGraphicsGetCurrentContext();
            CGFloat colour[4] = {1.0f, 0.0f, 0.0f, 1.0f};
            CGContextSetStrokeColor(c, colour);
            CGContextAddEllipseInRect(c, CGRectMake(point.x - 2, point.y - 2, 4, 4));
            CGContextStrokePath(c);
        }
    }
}
@end

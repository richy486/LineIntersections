//
//  View.m
//  TestLineDrawing
//
//  Created by Richard Adem on 8/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "View.h"
#import "Intersection.h"
#import "Line.h"
#import "Level.h"

@interface View()
{
    float _rotation;
}
@end

@implementation View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _rotation = 0.0;
        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
    [self drawPath];
    [self drawTapPoint];
    [self drawIntersectingPoints];
    [self drawIntersectingLines];
}

- (void) drawPath
{
    if ([[Level sharedInstance] levelLines] && [[[Level sharedInstance] levelLines] count] > 0)
    {
        for (Line *line in [[Level sharedInstance] levelLines])
        {
            [line draw];
        }
    }
}

- (void) drawTapPoint
{
#ifndef HIDE_PLAYER_BODY
    if ([[Level sharedInstance] playerPoints])
    {
        CGContextRef c = UIGraphicsGetCurrentContext();

        CGFloat colourBlack[4] = {1.0f, 1.0f, 1.0f, 1.0f};
        CGContextSetStrokeColor(c, colourBlack);
        CGContextBeginPath(c);

        NSInteger i = 0;
        CGPoint firstPoint;
        for (NSValue *val in [[Level sharedInstance] playerPoints])
        {
            CGPoint point = [val CGPointValue];
            if (i == 0)
            {
                CGContextMoveToPoint(c, point.x + [[Level sharedInstance] playerPosition].x, point.y + [[Level sharedInstance] playerPosition].y);
                firstPoint = point;
            }
            else
            {
                CGContextAddLineToPoint(c, point.x + [[Level sharedInstance] playerPosition].x, point.y + [[Level sharedInstance] playerPosition].y);
            }
            
            ++i;
        }
        CGContextAddLineToPoint(c, firstPoint.x + [[Level sharedInstance] playerPosition].x, firstPoint.y + [[Level sharedInstance] playerPosition].y);

        CGContextStrokePath(c);
    }
#endif
    
    if ([[Level sharedInstance] playerPoints] && [[[Level sharedInstance] playerPoints] count] > 0)
    {
        NSValue *valPlayer0 = [[[Level sharedInstance] playerPoints] objectAtIndex:0];
        CGPoint playerPoint = CGPointMake([[Level sharedInstance] playerPosition].x + [valPlayer0 CGPointValue].x, [[Level sharedInstance] playerPosition].y + [valPlayer0 CGPointValue].y);
        
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGFloat colour[4] = {1.0f, 1.0f, 1.0f, 1.0f};
        CGContextSetStrokeColor(c, colour);
        CGContextAddEllipseInRect(c, CGRectMake(playerPoint.x - 2, playerPoint.y - 2, 4, 4));
        CGContextStrokePath(c);
        
        CGContextSetStrokeColor(c, colour);
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0, playerPoint.y);
        CGContextAddLineToPoint(c, playerPoint.x, playerPoint.y);
        CGContextStrokePath(c);
    }
}


- (void) drawIntersectingPoints
{
    if (self.intersectingPoints)
    {
        for (Intersection *intersection in self.intersectingPoints)
        {
            CGPoint point = CGPointMake(intersection.intersectionX, intersection.intersectionY);
            
            CGContextRef c = UIGraphicsGetCurrentContext();
            CGFloat colour[4] = {1.0f, 0.0f, 0.0f, 1.0f};
            CGContextSetStrokeColor(c, colour);
            CGContextAddEllipseInRect(c, CGRectMake(point.x - 2, point.y - 2, 4, 4));
            CGContextStrokePath(c);
        }
    }
}

- (void) drawIntersectingLines
{
    if (self.intersectingLines && [self.intersectingLines count] > 0)
    {
        CGFloat colourRed[4] = {1.0f, 0.0f, 0.0f, 1.0f};
        CGFloat colourOrange[4] = {1.0f, 1.0f, 0.0f, 1.0f};
        
        for (Intersection *intersection in self.intersectingLines)
        {
            {
                CGContextRef c = UIGraphicsGetCurrentContext();
                CGContextSetStrokeColor(c, colourRed);
                CGContextMoveToPoint(c, intersection.linePoint2a.x, intersection.linePoint2a.y);
                CGContextAddLineToPoint(c, intersection.linePoint2b.x, intersection.linePoint2b.y);
                CGContextStrokePath(c);
            }
            
            {
                CGContextRef c = UIGraphicsGetCurrentContext();
                CGContextSetStrokeColor(c, colourOrange);
                CGContextAddEllipseInRect(c, CGRectMake(intersection.intersectionX - 4, intersection.intersectionY - 4, 8, 8));
                CGContextStrokePath(c);
            }
        }
    }
}

#pragma mark - getters setters

- (float) rotation
{
    return _rotation;
}
- (void) setRotation:(float)val
{
    _rotation = val;
    
    CGAffineTransform transformRot = CGAffineTransformMakeRotation(_rotation);
    
    for (NSInteger i = 0; i < [[[Level sharedInstance] playerPoints] count]; ++i)
    {
        NSValue *val = [[[Level sharedInstance] playerPoints] objectAtIndex:i];
        CGPoint point = [val CGPointValue];
        CGPoint pointRot = CGPointApplyAffineTransform(point, transformRot);
        
        [[[Level sharedInstance] playerPoints] replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:pointRot]];
    }
}


@end

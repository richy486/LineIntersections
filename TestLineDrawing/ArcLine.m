//
//  ArcLine.m
//  TestLineDrawing
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "ArcLine.h"
#import "Maths.h"

@implementation ArcLine
+ (id) lineWithPointA:(CGPoint) pointA pointB:(CGPoint) pointB radius:(double) radius chord:(double) chord angle:(double) angle
{
    ArcLine *arcLine = [[ArcLine alloc] init];
    arcLine.pointA = pointA;
    arcLine.pointB = pointB;
    arcLine.radius = radius;
    arcLine.chord = chord;
    arcLine.angle = angle;
    
    if (radius*2 < chord)
    {
        NSLog(@"warning diamater (%.02f) is less than chord (%.02f)", radius*2, chord);
    }
    
    return arcLine;
}

- (BOOL) intersectionsPointA:(CGPoint) pointA pointB:(CGPoint) pointB
          intersectingPointX:(double*) intersectingPointX
          intersectingPointY:(double*) intersectingPointY
{
    double intersectingPoint2X = 0.0;
    double intersectingPoint2Y = 0.0;
    return [self intersectionsPointA:pointA pointB:pointB intersectingPoint1X:intersectingPointX intersectingPoint1Y:intersectingPointY intersectingPoint2X:&intersectingPoint2X intersectingPoint2Y:&intersectingPoint2Y];
}
- (BOOL) intersectionsPointA:(CGPoint) pointA pointB:(CGPoint) pointB
         intersectingPoint1X:(double*) intersectingPoint1X
         intersectingPoint1Y:(double*) intersectingPoint1Y
         intersectingPoint2X:(double*) intersectingPoint2X
         intersectingPoint2Y:(double*) intersectingPoint2Y
{
    //return [super intersectionsPointB:pointA pointA:pointB intersectingPointX:intersectingPointX intersectingPointY:intersectingPointY];
    
    double theta = 2 * asin(self.chord / (2 * self.radius));
    
    double height = self.radius - (self.radius * (1.0 - cos(theta/2)));
    double centreOfPointsX = self.pointA.x + 0.5 * (self.pointB.x - self.pointA.x);
    double centreOfPointsY = self.pointA.y + 0.5 * (self.pointB.y - self.pointA.y);
    double rotateAngle = self.angle + M_PI_2;

    CGFloat startPoint = self.angle - (theta/2) - M_PI_2;
    CGFloat endPoint = startPoint + theta;
    CGFloat min = -M_PI;
    CGFloat max = M_PI;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, self.pointA.x, self.pointA.y);
    transform = CGAffineTransformRotate(transform, self.angle);
    transform = CGAffineTransformTranslate(transform, 0, height);
    transform = CGAffineTransformRotate(transform, -self.angle);
    transform = CGAffineTransformTranslate(transform, -self.pointA.x, -self.pointA.y);
    CGPoint point = CGPointApplyAffineTransform(CGPointMake(centreOfPointsX, centreOfPointsY), transform);
    
    double intersectionA = 0.0;
    double intersectionB = 0.0;
    BOOL intersection = [self circleLineIntersectionPointA:pointA
                                                    pointB:pointB
                                               circlePoint:CGPointMake(point.x, point.y)
                                              circleRadius:self.radius
                                             intersectionA:&intersectionA intersectionB:&intersectionB];
    
    
    CGPoint p1 = CGPointMake(((pointB.x - pointA.x) * intersectionA) + pointA.x
                             , ((pointB.y - pointA.y) * intersectionA) + pointA.y);
    
    CGPoint p2 = CGPointMake(((pointB.x - pointA.x) * intersectionB) + pointA.x
                             , ((pointB.y - pointA.y) * intersectionB) + pointA.y);
    
    CGFloat theta1 = atan2(p1.y - point.y, p1.x - point.x);
    CGFloat theta2 = atan2(p2.y - point.y, p2.x - point.x);
    
    BOOL inside1 = NO;
    BOOL inside2 = NO;
    CGFloat startPointNorm = [Maths wrap:startPoint max:max min:min];
    CGFloat endPointNorm = [Maths wrap:endPoint max:max min:min];
    if (startPointNorm < endPointNorm)
    {
        inside1 = theta1 >= startPointNorm && theta1 <= endPointNorm;
        inside2 = theta2 >= startPointNorm && theta2 <= endPointNorm;
    }
    else
    {
        if (startPointNorm >= 0.0 && endPointNorm <= 0.0)
        {
            if ((theta1 >= startPointNorm && theta1 <= M_PI && theta1 >= 0)
                || (theta1 <= endPointNorm && theta1 >= -M_PI && theta1 <= 0)
                )
            {
                inside1 = YES;
            }
            
            if ((theta2 >= startPointNorm && theta2 <= M_PI && theta2 >= 0)
                || (theta2 <= endPointNorm && theta2 >= -M_PI && theta2 <= 0)
                )
            {
                inside2 = YES;
            }
        }
        else
        {
            if (theta1 <= startPointNorm && theta1 >= endPointNorm)
            {
                inside1 = YES;
            }
            if (theta2 <= startPointNorm && theta2 >= endPointNorm)
            {
                inside2 = YES;
            }
        }
        
    }
    
    if (inside1)
    {
        *intersectingPoint1X = p1.x;
        *intersectingPoint1Y = p1.y;
    }
    else
    {
        *intersectingPoint1X = -MAXFLOAT;
        *intersectingPoint1Y = -MAXFLOAT;
    }
    
    if (inside2)
    {
        *intersectingPoint2X = p2.x;
        *intersectingPoint2Y = p2.y;
    }
    else
    {
        *intersectingPoint2X = -MAXFLOAT;
        *intersectingPoint2Y = -MAXFLOAT;
    }
    
    return intersection && (inside1 || inside2);
}

// http://stackoverflow.com/a/1084899/667834
- (BOOL) circleLineIntersectionPointA:(CGPoint) pointA pointB:(CGPoint) pointB
                          circlePoint:(CGPoint) circlePoint circleRadius:(CGFloat) radius
                        intersectionA:(double*)intersectionA intersectionB:(double*)intersectionB
{
    CGPoint d = CGPointMake(pointB.x - pointA.x, pointB.y - pointA.y);
    CGPoint f = CGPointMake(pointA.x - circlePoint.x, pointA.y - circlePoint.y);
    CGFloat r = radius;
    
    float a = [Maths dot:d andPoint:d];  //d.Dot( d ) ;
    float b = 2* [Maths dot:f andPoint:d];   //f.Dot( d ) ;
    float c = [Maths dot:f andPoint:f] - r*r ;
    
    float discriminant = b*b-4*a*c;
    if( discriminant < 0 ) // &lt;
    {
        // no intersection
    }
    else
    {
        // ray didn't totally miss sphere,
        // so there is a solution to
        // the equation.
        
        discriminant = sqrt( discriminant );
        
        // either solution may be on or off the ray so need to test both
        // t1 is always the smaller value, because BOTH discriminant and
        // a are nonnegative.
        float t1 = (-b - discriminant)/(2*a);
        float t2 = (-b + discriminant)/(2*a);
        
        *intersectionA = t1;
        *intersectionB = t2;
        
        // 3x HIT cases:
        //          -o->             --|-->  |            |  --|->
        // Impale(t1 hit,t2 hit), Poke(t1 hit,t2>1), ExitWound(t1<0, t2 hit),
        
        // 3x MISS cases:
        //       ->  o                     o ->              | -> |
        // FallShort (t1>1,t2>1), Past (t1<0,t2<0), CompletelyInside(t1<0, t2>1)
        
        if( t1 >= 0 && t1 <= 1 )
        {
            // t1 is an intersection, and if it hits,
            // it's closer than t2 would be
            // Impale, Poke
            return YES ;
        }
        
        // here t1 didn't intersect so we are either started
        // inside the sphere or completely past it
        if( t2 >= 0 && t2 <= 1 )
        {
            // ExitWound
            return YES ;
        }
        
        // no intn: FallShort, Past, CompletelyInside
        return NO ;
    }
    
    return NO;
}

#pragma tools



- (void) draw
{
    CGFloat colourGeen[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    
    
    // Update angle
    double deltaY = self.pointA.y - self.pointB.y;
    double deltaX = self.pointA.x - self.pointB.x;
    //self.angle = [Maths wrap:M_2_PI - atan2(deltaY, deltaX) max:M_PI min:-M_PI];
    self.angle = atan2(deltaY, deltaX);
    
    // theta = 2 arcsin(c/[2r]),
    double theta = 2 * asin(self.chord / (2 * self.radius));

    CGFloat startPoint = self.angle - (theta/2) - M_PI_2;
    CGFloat endPoint = startPoint + theta;
    
    double height = self.radius - (self.radius * (1.0 - cos(theta/2)));
    double centreOfPointsX = self.pointA.x + 0.5 * (self.pointB.x - self.pointA.x);
    double centreOfPointsY = self.pointA.y + 0.5 * (self.pointB.y - self.pointA.y);
    double rotateAngle = self.angle + M_PI_2;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, self.pointA.x, self.pointA.y);
    transform = CGAffineTransformRotate(transform, self.angle);
    transform = CGAffineTransformTranslate(transform, 0, height);
    transform = CGAffineTransformRotate(transform, -self.angle);
    transform = CGAffineTransformTranslate(transform, -self.pointA.x, -self.pointA.y);
    CGPoint point = CGPointApplyAffineTransform(CGPointMake(centreOfPointsX, centreOfPointsY), transform);
    
    {
        CGFloat colourWhite[4] = {1.0f, 1.0f, 1.0f, 0.25f};
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colourWhite);
        CGContextAddEllipseInRect(c, CGRectMake(point.x - self.radius, point.y - self.radius, self.radius*2, self.radius*2));
        CGContextStrokePath(c);
    }
    
    // points
    {
        CGFloat colour[4] = {1.0f, 0.0f, 1.0f, 1.0f};
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colour);
        CGContextAddEllipseInRect(c, CGRectMake(self.pointA.x - 4, self.pointA.y - 4, 8, 8));
        CGContextStrokePath(c);
    }
    {
        CGFloat colour[4] = {1.0f, 0.0f, 1.0f, 1.0f};
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colour);
        CGContextAddEllipseInRect(c, CGRectMake(self.pointB.x - 4, self.pointB.y - 4, 8, 8));
        CGContextStrokePath(c);
    }
    
    // 
    {
        CGFloat colour[4] = {1.0f, 0.0f, 1.0f, 1.0f};
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colour);
        CGContextMoveToPoint(c
                             , point.x
                             , point.y);
        CGContextAddLineToPoint(c
                                , centreOfPointsX
                                , centreOfPointsY);
        CGContextStrokePath(c);
    }
    
    
    BOOL clockwise = YES;
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColor(c, colourGeen);
    CGContextAddArc(c,
                    point.x,
                    point.y,
                    self.radius,
                    startPoint,
                    endPoint,
                    clockwise ? 0 : 1); // UIView flips the Y-coordinate
    CGContextStrokePath(c);
    
    
    
    
    {
        CGFloat colour[4] = {1.0f, 0.0f, 1.0f, 1.0f};
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colour);
        CGContextMoveToPoint(c
                             , point.x + self.radius * cos(startPoint)
                             , point.y + self.radius * sin(startPoint));
        CGContextAddLineToPoint(c
                                , point.x + self.radius * cos(endPoint)
                                , point.y + self.radius * sin(endPoint));
        CGContextStrokePath(c);
    }
}
@end

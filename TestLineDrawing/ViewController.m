//
//  ViewController.m
//  TestLineDrawing
//
//  Created by Richard Adem on 8/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "ViewController.h"
#import "View.h"
#import "Intersection.h"
#import "Line.h"
#import "ArcLine.h"
#import "Level.h"
#import "Maths.h"

@interface ViewController ()
{
    float _prevRotation;
    CGPoint _beginPan;
    CGPoint _beginPan2;
}
@property (nonatomic, strong) UILabel *resultLabel;
@end



@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _prevRotation = 0.0;
        _beginPan = CGPointZero;
        _beginPan2 = CGPointZero;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setView:[[View alloc] init]];
    
    CGFloat mult = 5.0;
    
    NSArray *levelPoints = [NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:CGPointMake(25.0 * mult + LEVEL_OFFSET - 300.0,  0.0 * mult + LEVEL_OFFSET)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(50.0 * mult + LEVEL_OFFSET - 300.0, 25.0 * mult + LEVEL_OFFSET)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(37.5 * mult + LEVEL_OFFSET - 300.0, 37.5 * mult + LEVEL_OFFSET)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(50.0 * mult + LEVEL_OFFSET - 300.0, 50.0 * mult + LEVEL_OFFSET)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(100.0 * mult + LEVEL_OFFSET - 300.0, 0.0 * mult + LEVEL_OFFSET)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(112.5 * mult + LEVEL_OFFSET - 300.0, 12.5 * mult + LEVEL_OFFSET)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(50.0 * mult + LEVEL_OFFSET - 300.0, 75.0 * mult + LEVEL_OFFSET)]
                       ,    [NSValue valueWithCGPoint:CGPointMake( 0.0 * mult + LEVEL_OFFSET - 300.0, 25.0 * mult + LEVEL_OFFSET)]
                       , nil];
//    const float size = 20.0;
//    NSArray *levelPoints = [NSArray arrayWithObjects:
//                            [NSValue valueWithCGPoint:CGPointMake(-size * mult + LEVEL_OFFSET,  -size * mult + LEVEL_OFFSET)]
//                            ,    [NSValue valueWithCGPoint:CGPointMake(size * mult + LEVEL_OFFSET, -size * mult + LEVEL_OFFSET)]
//                            ,    [NSValue valueWithCGPoint:CGPointMake(size * mult + LEVEL_OFFSET, size * mult + LEVEL_OFFSET)]
//                            ,    [NSValue valueWithCGPoint:CGPointMake(-size * mult + LEVEL_OFFSET, size * mult + LEVEL_OFFSET)]
//                            , nil];
    
    NSMutableArray *levelLines = [NSMutableArray arrayWithCapacity:[levelPoints count]];
    for (NSInteger levelIndex = 1; levelIndex < [levelPoints count] + 1; ++levelIndex)
    {
        
        NSInteger indexA = levelIndex-1;
        NSInteger indexB = levelIndex == [levelPoints count] ? 0 : levelIndex;
        
        NSValue *valA = [levelPoints objectAtIndex:indexA];
        CGPoint pointA = [valA CGPointValue];
        NSValue *valB = [levelPoints objectAtIndex:indexB];
        CGPoint pointB = [valB CGPointValue];
        
        if (levelIndex == 1)
        {
            double chord = sqrt(pow((pointB.x - pointA.x), 2.0) + pow((pointB.y - pointA.y), 2.0));
            double radius = chord * 0.75;
            
            // 
//            double deltaY = pointB.y - pointA.y;
//            double deltaX = pointB.x - pointA.x;

//            // 
            double deltaY = pointA.y - pointB.y;
            double deltaX = pointA.x - pointB.x;
            
            double angle = atan2(deltaY, deltaX);
            
            ArcLine *arcLine = [ArcLine lineWithPointA:pointA pointB:pointB radius:radius chord: chord angle:angle];
            [arcLine setInward:angle < 0];
            
            [levelLines addObject:arcLine];
        }
        else
        {
            
            [levelLines addObject:[Line lineWithPointA:pointA pointB:pointB]];
        }
    }
    [[Level sharedInstance] setLevelLines:levelLines];
    
    NSMutableArray *playerPoints = [NSMutableArray arrayWithObjects:
                             [NSValue valueWithCGPoint:CGPointMake(-30.0,  -30.0)]
                             , [NSValue valueWithCGPoint:CGPointMake(-10.0,  -30.0)]
                             , [NSValue valueWithCGPoint:CGPointMake(-10.0,  -10.0)]
                             , [NSValue valueWithCGPoint:CGPointMake(10.0,  -10.0)]
                             , [NSValue valueWithCGPoint:CGPointMake(10.0,  -30.0)]
                             , [NSValue valueWithCGPoint:CGPointMake(30.0,  -30.0)]
                             , [NSValue valueWithCGPoint:CGPointMake(30.0,  10.0)]
                             , [NSValue valueWithCGPoint:CGPointMake(-30.0,  10.0)]
                             , nil];
    [[Level sharedInstance] setPlayerPoints:playerPoints];
    
    self.resultLabel = [[UILabel alloc] init];
    [self.resultLabel setFrame:CGRectMake(20, 900, 700, 100)];
    [self.resultLabel setText:@"###"];
    [self.resultLabel setNumberOfLines:0];
    [self.view addSubview:self.resultLabel];
    
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateGestureAction:)];
    [rotateGesture setDelegate:self];
    [self.view addGestureRecognizer:rotateGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [panGesture setDelegate:self];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setMinimumNumberOfTouches:1];
    [self.view addGestureRecognizer:panGesture];
    
    UIPanGestureRecognizer *panGesture2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction2:)];
    [panGesture2 setDelegate:self];
    [panGesture2 setMaximumNumberOfTouches:2];
    [panGesture2 setMinimumNumberOfTouches:2];
    [self.view addGestureRecognizer:panGesture2];
}

#pragma mark - events

#pragma mark - gestures

- (void)rotateGestureAction:(UIRotationGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan
        || (_prevRotation < 0.0 && gestureRecognizer.rotation > 0.0)
        || (_prevRotation > 0.0 && gestureRecognizer.rotation < 0.0))
    {
        _prevRotation = 0.0;
    }
    float thisRotate = gestureRecognizer.rotation - _prevRotation;
    _prevRotation = gestureRecognizer.rotation;
    
//    [(View*)self.view setRotation:thisRotate * 2];
    [[Level sharedInstance] setRotation:thisRotate * 2];
    
    [self.view setNeedsDisplay];
    [self checkInOutPlayer];
}

- (void) panGestureAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint newCenter = [gestureRecognizer translationInView:self.view];
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        _beginPan.x = [[Level sharedInstance] playerPosition].x;
        _beginPan.y = [[Level sharedInstance] playerPosition].y;
        
        
        
    }
    newCenter = CGPointMake(_beginPan.x + newCenter.x, _beginPan.y + newCenter.y);
    
    
    [[Level sharedInstance] setPlayerPosition:newCenter];
    
    [self.view setNeedsDisplay];
    [self checkInOutPlayer];
}

- (void) panGestureAction2:(UIPanGestureRecognizer *)gestureRecognizer
{
//    CGPoint newCenter = [gestureRecognizer translationInView:self.view];
//    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
//        _beginPan2.x = [(View*)self.view position2].x;
//        _beginPan2.y = [(View*)self.view position2].y;
//        
//        
//        
//    }
//    newCenter = CGPointMake(_beginPan2.x + newCenter.x, _beginPan2.y + newCenter.y);
//    
//    
//    [(View*)self.view setPosition2:newCenter];
//    
//    [self.view setNeedsDisplay];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - calculations
// these should go into some other class

- (void) checkInOutPlayer
{
    NSMutableArray *levelLines = [[Level sharedInstance] levelLines];
    NSArray *playerPoints = [[Level sharedInstance] playerPoints];
    
    if (levelLines && [levelLines count] > 1 && playerPoints && [playerPoints count] > 0)
    {
        CGPoint playerPosition = [[Level sharedInstance] playerPosition];
        NSMutableArray *intersectingPoints = [NSMutableArray arrayWithCapacity:[levelLines count]];
        NSMutableArray *intersectingLines = [NSMutableArray arrayWithCapacity:[levelLines count]];
        
        // -- Edge intersections --
        
        BOOL foundIntersection = NO;
#ifndef HIDE_PLAYER_BODY
        for (NSInteger playerIndex = 1; playerIndex < [playerPoints count] + 1; ++playerIndex)
        {
            NSInteger indexA = playerIndex-1;
            NSInteger indexB = playerIndex == [playerPoints count] ? 0 : playerIndex;
            
            NSValue *valPlayer_a = [playerPoints objectAtIndex:indexA];
            CGPoint pointPlayer_a = CGPointMake(playerPosition.x + [valPlayer_a CGPointValue].x, playerPosition.y + [valPlayer_a CGPointValue].y);
            NSValue *valPlayer_b = [playerPoints objectAtIndex:indexB];
            CGPoint pointPlayer_b = CGPointMake(playerPosition.x + [valPlayer_b CGPointValue].x, playerPosition.y + [valPlayer_b CGPointValue].y);
            
            for (Line *line in levelLines)
            {
                CGPoint point2a = line.pointA;
                CGPoint point2b = line.pointB;
                
                double x = 0.0;
                double y = 0.0;
                
                if ([line respondsToSelector:@selector(intersectionsPointA:pointB:intersectingPoint1X:intersectingPoint1Y:intersectingPoint2X:intersectingPoint2Y:)])
                {
                    double x2 = 0.0;
                    double y2 = 0.0;
                    if ([(ArcLine*)line intersectionsPointA:pointPlayer_a pointB:pointPlayer_b intersectingPoint1X:&x intersectingPoint1Y:&y intersectingPoint2X:&x2 intersectingPoint2Y:&y2])
                    {
                        if (x > -MAXFLOAT & y > -MAXFLOAT)
                        {
                            [intersectingPoints addObject:[Intersection intersectionWithX:x Y:y point1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b]];
                            foundIntersection = YES;
                            break;
                        }

                        if (x2 > -MAXFLOAT & y2 > -MAXFLOAT)
                        {
                            [intersectingPoints addObject:[Intersection intersectionWithX:x2 Y:y2 point1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b]];
                            foundIntersection = YES;
                            break;
                        }
                    }
                    
                }
                else
                {
                    if ([line intersectionsPointA:pointPlayer_a pointB:pointPlayer_b intersectingPointX:&x intersectingPointY:&y]) //([self intersectionsPoint1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b intersectingPointX:&x intersectingPointY:&y])
                    {
                        [intersectingPoints addObject:[Intersection intersectionWithX:x Y:y point1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b]];
                        
                        foundIntersection = YES;
                        break;
                    }
                }
            }
            
            if (foundIntersection)
            {
                break;
            }
        }
#endif
        // -- Ray trace intersections --
        
        NSInteger intersectionsCount = 0;
        if (!foundIntersection)
        {
            NSValue *valPlayer0 = [playerPoints objectAtIndex:0];
            CGPoint playerPoint = CGPointMake(playerPosition.x + [valPlayer0 CGPointValue].x, playerPosition.y + [valPlayer0 CGPointValue].y);
            
            CGPoint pointPlayer_a = CGPointMake(0.0, playerPoint.y);
            CGPoint pointPlayer_b = playerPoint;
            
            
            for (Line *line in levelLines)
            {
                double x = 0.0;
                double y = 0.0;
                
                // http://alienryderflex.com/polygon/ - figure 4
                CGPoint linePointA = line.pointA;
                CGPoint linePointB = line.pointB;
                if (line.pointA.y >= playerPoint.y - TOLL && line.pointA.y <= playerPoint.y + TOLL)
                {
                    linePointA = CGPointMake(linePointA.x, linePointA.y - 1.0);
                }
                if (line.pointB.y >= playerPoint.y - TOLL && line.pointB.y <= playerPoint.y + TOLL)
                {
                    linePointB = CGPointMake(linePointB.x, linePointB.y - 1.0);
                }
                
                if ([Line intersectionsPoint1a:pointPlayer_a point1b:pointPlayer_b point2a:linePointA point2b:linePointB intersectingPointX:&x intersectingPointY:&y])
                {
                    [intersectingPoints addObject:[Intersection intersectionWithX:x Y:y point1a:pointPlayer_a point1b:pointPlayer_b point2a:linePointA point2b:linePointB]];
                    intersectionsCount++;
                }
            }
        }
        
        // -- Arc-segment intersections --
        
        BOOL outsideShapeFromInwardArcs = NO;
        BOOL insideShapeFromOutwardArcs = NO;
        for (Line *line in levelLines)
        {
            if ([line respondsToSelector:@selector(isPointInsideSegment:)] && [line respondsToSelector:@selector(inward)])
            {
                NSValue *valPlayer0 = [playerPoints objectAtIndex:0];
                CGPoint playerPoint = CGPointMake(playerPosition.x + [valPlayer0 CGPointValue].x, playerPosition.y + [valPlayer0 CGPointValue].y);
                
                BOOL insideSegment = [(ArcLine*)line isPointInsideSegment:playerPoint];
                BOOL inward = [(ArcLine*)line inward];
                
                if (insideSegment)
                {
                    if (inward)
                    {
                        outsideShapeFromInwardArcs = YES;
                        break;
                    }
                    else
                    {
                        insideShapeFromOutwardArcs = YES;
                    }
                }
            }
        }
        
        
        [(View*)self.view setIntersectingPoints:intersectingPoints];
        [(View*)self.view setIntersectingLines:intersectingLines];
        
        if (foundIntersection || (!insideShapeFromOutwardArcs && (intersectionsCount %2 == 0 || outsideShapeFromInwardArcs)))
        {
            NSValue *valPlayer0 = [playerPoints objectAtIndex:0];
            CGPoint playerPoint = CGPointMake(playerPosition.x + [valPlayer0 CGPointValue].x, playerPosition.y + [valPlayer0 CGPointValue].y);
            
            [self.resultLabel setText:[NSString stringWithFormat:@"outside"
                                       "\nfoundIntersection: %d, intersectionsCount: %d"
                                       "\n, outsideShapeFromInwardArcs: %d, insideShapeFromOutwardArcs: %d"
                                       "\npp %.02f, %.02f"
                                       , foundIntersection, intersectionsCount
                                       , outsideShapeFromInwardArcs, insideShapeFromOutwardArcs
                                       , playerPoint.x, playerPoint.y]];
            [self.resultLabel setBackgroundColor:[UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:1.0]];
        }
        else
        {
            NSValue *valPlayer0 = [playerPoints objectAtIndex:0];
            CGPoint playerPoint = CGPointMake(playerPosition.x + [valPlayer0 CGPointValue].x, playerPosition.y + [valPlayer0 CGPointValue].y);
            
            [self.resultLabel setText:[NSString stringWithFormat:@"inside"
                                       "\nfoundIntersection: %d, intersectionsCount: %d"
                                       "\n, outsideShapeFromInwardArcs: %d, insideShapeFromOutwardArcs: %d"
                                       "\npp %.02f, %.02f", foundIntersection, intersectionsCount
                                       , outsideShapeFromInwardArcs, insideShapeFromOutwardArcs
                                       , playerPoint.x, playerPoint.y]];
            [self.resultLabel setBackgroundColor:[UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:1.0]];
        }
    }
}

- (BOOL) checkCornersWithPlayerPoint:(CGPoint) playerPoint
                              point2a:(CGPoint) point2a point2b:(CGPoint) point2b
                   intersectingPoints:(NSMutableArray*) intersectingPoints
                   intersectingLines:(NSMutableArray*) intersectingLines
                        intersectionX:(double) x intersectionY:(double) y
{
    BOOL found = NO;
    for (Intersection *intersection in intersectingPoints)
    {
        if (intersection.intersectionX >= x - TOLL*2 && intersection.intersectionX <= x + TOLL*2
            && intersection.intersectionY >= y - TOLL*2 && intersection.intersectionY <= y + TOLL*2)
        {
            CGPoint playerFullLength_a = CGPointMake(0.0, playerPoint.y);
            CGPoint playerFullLength_b = CGPointMake(self.view.frame.size.width, playerPoint.y);
            
            if (intersection.linePoint2a.x == point2b.x && intersection.linePoint2a.y == point2b.y)
            {
                double xA = 0.0;
                double yA = 0.0;
                if ([Line intersectionsPoint1a:playerFullLength_a point1b:playerFullLength_b
                                       point2a:intersection.linePoint2b point2b:point2a
                            intersectingPointX:&xA intersectingPointY:&yA])
                {
                    found = YES;
                }
                
                [intersectingLines addObject:[Intersection intersectionWithX:xA Y:yA
                                                                     point1a:playerFullLength_a point1b:playerFullLength_b
                                                                     point2a:intersection.linePoint2b point2b:point2a]];
                
            }
            else if (intersection.linePoint2b.x == point2a.x && intersection.linePoint2b.y == point2a.y)
            {
                double xA = 0.0;
                double yA = 0.0;
                if ([Line intersectionsPoint1a:playerFullLength_a point1b:playerFullLength_b
                                       point2a:intersection.linePoint2a point2b:point2b
                            intersectingPointX:&xA intersectingPointY:&yA])
                {
                    found = YES;
                }
                [intersectingLines addObject:[Intersection intersectionWithX:xA Y:yA
                                                                     point1a:playerFullLength_a point1b:playerFullLength_b
                                                                     point2a:intersection.linePoint2a point2b:point2b]];
            }
            
            if (found)
            {
                break;
            }
        }
    }
    
    return found;
}

#pragma mark - memory man

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

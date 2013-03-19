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

@interface ViewController ()
{
    float _prevRotation;
    CGPoint _beginPan;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setView:[[View alloc] init]];
    
    CGFloat offset = 100.0;
    CGFloat mult = 5.0;
    
    NSArray *levelPoints = [NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:CGPointMake(25.0 * mult + offset,  0.0 * mult + offset)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(50.0 * mult + offset, 25.0 * mult + offset)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(37.5 * mult + offset, 37.5 * mult + offset)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(50.0 * mult + offset, 50.0 * mult + offset)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(100.0 * mult + offset, 0.0 * mult + offset)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(112.5 * mult + offset, 12.5 * mult + offset)]
                       ,    [NSValue valueWithCGPoint:CGPointMake(50.0 * mult + offset, 75.0 * mult + offset)]
                       ,    [NSValue valueWithCGPoint:CGPointMake( 0.0 * mult + offset, 25.0 * mult + offset)]
                       , nil];
    
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
            [levelLines addObject:[ArcLine lineWithPointA:pointA pointB:pointB radius:89.0 chord: chord angle:(3.0 * M_PI)/4]];
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
    
    [(View*)self.view setRotation:thisRotate * 2];
    
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
        
        BOOL foundIntersection = NO;
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
                if ([line intersectionsPointB:pointPlayer_a pointA:pointPlayer_b intersectingPointX:&x intersectingPointY:&y]) //([self intersectionsPoint1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b intersectingPointX:&x intersectingPointY:&y])
                {
                    [intersectingPoints addObject:[Intersection intersectionWithX:x Y:y point1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b]];
                    
                    foundIntersection = YES;
                    break;
                }
            }
            
            if (foundIntersection)
            {
                break;
            }
        }
        
        
        NSInteger intersectionsCount = 0;
        if (!foundIntersection)
        {
            NSValue *valPlayer0 = [playerPoints objectAtIndex:0];
            CGPoint playerPoint = CGPointMake(playerPosition.x + [valPlayer0 CGPointValue].x, playerPosition.y + [valPlayer0 CGPointValue].y);
            
            CGPoint pointPlayer_a = CGPointMake(0.0, playerPoint.y);
            CGPoint pointPlayer_b = playerPoint;
            
            for (Line *line in levelLines)
            {
                CGPoint point2a = line.pointA;
                CGPoint point2b = line.pointB;
                
                double x = 0.0;
                double y = 0.0;
                if ([line intersectionsPointB:pointPlayer_a pointA:pointPlayer_b intersectingPointX:&x intersectingPointY:&y]) //([self intersectionsPoint1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b  intersectingPointX:&x intersectingPointY:&y])
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

                    if (!found)
                    {
                        [intersectingPoints addObject:[Intersection intersectionWithX:x Y:y point1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b]];
                        intersectionsCount++;
                    }
                }
            }
        }
        
        [(View*)self.view setIntersectingPoints:intersectingPoints];
        [(View*)self.view setIntersectingLines:intersectingLines];
        
        if (foundIntersection || intersectionsCount %2 == 0)
        {
            NSValue *valPlayer0 = [playerPoints objectAtIndex:0];
            CGPoint playerPoint = CGPointMake(playerPosition.x + [valPlayer0 CGPointValue].x, playerPosition.y + [valPlayer0 CGPointValue].y);
            
            [self.resultLabel setText:[NSString stringWithFormat:@"outside\nfoundIntersection: %d, intersectionsCount: %d\npp %.02f, %.02f", foundIntersection, intersectionsCount, playerPoint.x, playerPoint.y]];
            [self.resultLabel setBackgroundColor:[UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:1.0]];
        }
        else
        {
            NSValue *valPlayer0 = [playerPoints objectAtIndex:0];
            CGPoint playerPoint = CGPointMake(playerPosition.x + [valPlayer0 CGPointValue].x, playerPosition.y + [valPlayer0 CGPointValue].y);
            
            [self.resultLabel setText:[NSString stringWithFormat:@"inside\nfoundIntersection: %d, intersectionsCount: %d\npp %.02f, %.02f", foundIntersection, intersectionsCount, playerPoint.x, playerPoint.y]];
            [self.resultLabel setBackgroundColor:[UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:1.0]];
        }
    }
}

#pragma mark - memory man

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  ViewController.m
//  TestLineDrawing
//
//  Created by Richard Adem on 8/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "ViewController.h"
#import "View.h"

@interface ViewController ()
{
    float _prevRotation;
    CGPoint _beginPan;
}
@property (nonatomic, strong) UILabel *resultLabel;
@end

const double toll = 0.4;

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
    [(View*)self.view setLevelPoints:levelPoints];
    
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
    [(View*)self.view setPlayerPoints:playerPoints];
    
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
    
//    NSLog(@"rotation: %.02f, prevRotation: %.02f |||| rotation: %.02f", gestureRecognizer.rotation, _prevRotation, [(View*)self.view rotation]);
    
    [self.view setNeedsDisplay];
    [self checkInOutPlayer];
}

- (void) panGestureAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint newCenter = [gestureRecognizer translationInView:self.view];
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        _beginPan.x = [(View*)self.view tapPoint].x;
        _beginPan.y = [(View*)self.view tapPoint].y;
        
        
        
    }
    newCenter = CGPointMake(_beginPan.x + newCenter.x, _beginPan.y + newCenter.y);
    
    
    [(View*)self.view setTapPoint:newCenter];
    
//    NSLog(@"new centre: %.02f, %.02f", newCenter.x, newCenter.y);
    
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
    NSArray *levelPoints = [(View*)self.view levelPoints];
    NSArray *playerPoints = [(View*)self.view playerPoints];
    
    if (levelPoints && [levelPoints count] > 1 && playerPoints && [playerPoints count] > 0)
    {
        CGPoint tapPoint = [(View*)self.view tapPoint];
        NSMutableArray *intersectingPoints = [NSMutableArray arrayWithCapacity:[levelPoints count]];
        
        BOOL foundIntersection = NO;
        for (NSInteger playerIndex = 1; playerIndex < [playerPoints count] + 1; ++playerIndex)
        {
            NSInteger indexA = playerIndex-1;
            NSInteger indexB = playerIndex == [playerPoints count] ? 0 : playerIndex;
            
            NSValue *valPlayer_a = [playerPoints objectAtIndex:indexA];
            CGPoint pointPlayer_a = CGPointMake(tapPoint.x + [valPlayer_a CGPointValue].x, tapPoint.y + [valPlayer_a CGPointValue].y);
            NSValue *valPlayer_b = [playerPoints objectAtIndex:indexB];
            CGPoint pointPlayer_b = CGPointMake(tapPoint.x + [valPlayer_b CGPointValue].x, tapPoint.y + [valPlayer_b CGPointValue].y);
            
            for (NSInteger levelIndex = 1; levelIndex < [levelPoints count] + 1; ++levelIndex)
            {
                NSInteger indexA = levelIndex-1;
                NSInteger indexB = levelIndex == [levelPoints count] ? 0 : levelIndex;
                
                NSValue *val2a = [levelPoints objectAtIndex:indexA];
                CGPoint point2a = [val2a CGPointValue];
                NSValue *val2b = [levelPoints objectAtIndex:indexB];
                CGPoint point2b = [val2b CGPointValue];
                
                double x = 0.0;
                double y = 0.0;
                if ([self intersectionsPoint1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b intersectingPointX:&x intersectingPointY:&y])
                {
                    
                    BOOL found = NO;
//                    for (NSValue *val in intersectingPoints)
//                    {
//                        CGPoint addedPoint = [val CGPointValue];
//                        if (addedPoint.x >= x - toll && addedPoint.x <= x + toll
//                            && addedPoint.y >= y - toll && addedPoint.y <= y + toll)
//                        {
//                            found = YES;
//                            break;
//                        }
//                    }
//
                    if (!found)
                    {
                        [intersectingPoints addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
                        NSLog(@"intersection: %.02f, %.02f", x, y);
                    }
                    
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
            CGPoint playerPoint = CGPointMake(tapPoint.x + [valPlayer0 CGPointValue].x, tapPoint.y + [valPlayer0 CGPointValue].y);
            
            CGPoint pointPlayer_a = CGPointMake(0.0, playerPoint.y);
            CGPoint pointPlayer_b = playerPoint;
            
            NSLog(@" ------ pp 0 start: ");
            for (NSInteger levelIndex = 1; levelIndex < [levelPoints count] + 1; ++levelIndex)
            {
                NSInteger indexA = levelIndex-1;
                NSInteger indexB = levelIndex == [levelPoints count] ? 0 : levelIndex;
                
                NSValue *val2a = [levelPoints objectAtIndex:indexA];
                CGPoint point2a = [val2a CGPointValue];
                NSValue *val2b = [levelPoints objectAtIndex:indexB];
                CGPoint point2b = [val2b CGPointValue];
                
                double x = 0.0;
                double y = 0.0;
                if ([self intersectionsPoint1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b  intersectingPointX:&x intersectingPointY:&y])
                {
                    BOOL found = NO;
                    //                    for (NSValue *val in intersectingPoints)
                    //                    {
                    //                        CGPoint addedPoint = [val CGPointValue];
                    //                        if (addedPoint.x >= x - toll && addedPoint.x <= x + toll
                    //                            && addedPoint.y >= y - toll && addedPoint.y <= y + toll)
                    //                        {
                    //                            found = YES;
                    //                            break;
                    //                        }
                    //                    }
                    //
                    if (!found)
                    {
                        [intersectingPoints addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
                        NSLog(@"intersection: %.02f, %.02f", x, y);
                    }
                    intersectionsCount++;
                }
            }
            NSLog(@" ------ pp 0 end ");
        }
        
        [(View*)self.view setIntersectingPoints:intersectingPoints];
        
        if (foundIntersection || intersectionsCount %2 == 0)
        {
            NSValue *valPlayer0 = [playerPoints objectAtIndex:0];
            CGPoint playerPoint = CGPointMake(tapPoint.x + [valPlayer0 CGPointValue].x, tapPoint.y + [valPlayer0 CGPointValue].y);
            
            [self.resultLabel setText:[NSString stringWithFormat:@"outside\nfoundIntersection: %d, intersectionsCount: %d\npp %.02f, %.02f", foundIntersection, intersectionsCount, playerPoint.x, playerPoint.y]];
            [self.resultLabel setBackgroundColor:[UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:1.0]];
        }
        else
        {
            NSValue *valPlayer0 = [playerPoints objectAtIndex:0];
            CGPoint playerPoint = CGPointMake(tapPoint.x + [valPlayer0 CGPointValue].x, tapPoint.y + [valPlayer0 CGPointValue].y);
            
            [self.resultLabel setText:[NSString stringWithFormat:@"inside\nfoundIntersection: %d, intersectionsCount: %d\npp %.02f, %.02f", foundIntersection, intersectionsCount, playerPoint.x, playerPoint.y]];
            [self.resultLabel setBackgroundColor:[UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:1.0]];
        }
    }
}

// http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=geometry2
- (BOOL) intersectionsPoint1a:(CGPoint) point1a point1b:(CGPoint) point1b
                      point2a:(CGPoint) point2a point2b:(CGPoint) point2b
           intersectingPointX:(double*) intersectingPointX
           intersectingPointY:(double*) intersectingPointY
{
    double A1 = point1b.y - point1a.y;
    double B1 = point1a.x - point1b.x;
    double C1 = A1 * point1a.x + B1 * point1a.y;
    
    double A2 = point2b.y - point2a.y;
    double B2 = point2a.x - point2b.x;
    double C2 = A2 * point2a.x + B2 * point2a.y;
    
    double det = A1*B2 - A2*B1;
    
    double x, y;
    if(det == 0){
        return YES;
    }else{
        x = (B2*C1 - B1*C2)/det;
        y = (A1*C2 - A2*C1)/det;
        
        
    }
    
    BOOL onLineX1 = MIN(point1a.x, point1b.x) <= x + toll && x - toll <= MAX(point1a.x, point1b.x);
    BOOL onLineY1 = MIN(point1a.y, point1b.y) <= y + toll && y - toll <= MAX(point1a.y, point1b.y);
    BOOL onLineX2 = MIN(point2a.x, point2b.x) <= x + toll && x - toll <= MAX(point2a.x, point2b.x);
    BOOL onLineY2 = MIN(point2a.y, point2b.y) <= y + toll && y - toll <= MAX(point2a.y, point2b.y);
    
    *intersectingPointX = x;
    *intersectingPointY = y;
    
    if (onLineX1 && onLineY1 && onLineX2 && onLineY2)
    {
        return YES;
    }
    return NO;
}

#pragma mark - memory man

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

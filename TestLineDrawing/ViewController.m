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
@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    NSArray *playerPoints = [NSArray arrayWithObjects:
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
    [self.resultLabel setFrame:CGRectMake(20, 900, 500, 100)];
    [self.resultLabel setText:@"###"];
    [self.view addSubview:self.resultLabel];
}

#pragma mark - events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
    [(View*)self.view setTapPoint:location];
    
    [self.view setNeedsDisplay];
    [self checkInOutPlayer];
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
    [(View*)self.view setTapPoint:location];
    
    [self.view setNeedsDisplay];
    [self checkInOutPlayer];
}

#pragma mark - calculations
// these should go into some other class

- (void) checkInOutTapPoint
{
    NSArray *points = [(View*)self.view levelPoints];
    if (points && [points count] > 1)
    {
        CGPoint tapPoint = [(View*)self.view tapPoint];
        CGPoint point1a = CGPointMake(0.0, tapPoint.y);
        CGPoint point1b = tapPoint;
        
        NSMutableArray *linesIntersecting = [NSMutableArray arrayWithCapacity:[points count]];
        NSMutableArray *intersectingPoints = [NSMutableArray arrayWithCapacity:[points count]];
        NSInteger intersectionsCount = 0;
        for (NSInteger i = 1; i < [points count] + 1; ++i)
        {
            NSInteger indexA = i-1;
            NSInteger indexB = i == [points count] ? 0 : i;
            
            NSValue *val2a = [points objectAtIndex:indexA];
            CGPoint point2a = [val2a CGPointValue];
            NSValue *val2b = [points objectAtIndex:indexB];
            CGPoint point2b = [val2b CGPointValue];
            
            if ([self intersectionsPoint1a:point1a point1b:point1b point2a:point2a point2b:point2b intersectingPoints:intersectingPoints])
            {
                intersectionsCount++;
                [linesIntersecting addObject:[NSNumber numberWithBool:YES]];
            }
            else
            {
                [linesIntersecting addObject:[NSNumber numberWithBool:NO]];
            }
        }
        
        [(View*)self.view setLinesIntersecting:linesIntersecting];
        [(View*)self.view setIntersectingPoints:intersectingPoints];
        
        if (intersectionsCount %2 == 0)
        {
            [self.resultLabel setText:[NSString stringWithFormat:@"outside, count: %d", intersectionsCount]];
        }
        else
        {
            [self.resultLabel setText:[NSString stringWithFormat:@"inside, count: %d", intersectionsCount]];
        }
    }
}

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
                
                if ([self intersectionsPoint1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b intersectingPoints:intersectingPoints])
                {
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
            
            
            for (NSInteger levelIndex = 1; levelIndex < [levelPoints count] + 1; ++levelIndex)
            {
                NSInteger indexA = levelIndex-1;
                NSInteger indexB = levelIndex == [levelPoints count] ? 0 : levelIndex;
                
                NSValue *val2a = [levelPoints objectAtIndex:indexA];
                CGPoint point2a = [val2a CGPointValue];
                NSValue *val2b = [levelPoints objectAtIndex:indexB];
                CGPoint point2b = [val2b CGPointValue];
                
                if ([self intersectionsPoint1a:pointPlayer_a point1b:pointPlayer_b point2a:point2a point2b:point2b intersectingPoints:intersectingPoints])
                {
                    intersectionsCount++;
                }
            }
        }
        
        [(View*)self.view setIntersectingPoints:intersectingPoints];
        
        if (foundIntersection || intersectionsCount %2 == 0)
        {
            [self.resultLabel setText:[NSString stringWithFormat:@"outside, foundIntersection: %d, intersectionsCount: %d", foundIntersection, intersectionsCount]];
        }
        else
        {
            [self.resultLabel setText:[NSString stringWithFormat:@"inside, foundIntersection: %d, intersectionsCount: %d", foundIntersection, intersectionsCount]];
        }
    }
}

// http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=geometry2
- (BOOL) intersectionsPoint1a:(CGPoint) point1a point1b:(CGPoint) point1b
                      point2a:(CGPoint) point2a point2b:(CGPoint) point2b
           intersectingPoints:(NSMutableArray*) intersectingPoints
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
    
    BOOL onLineX1 = MIN(point1a.x, point1b.x) <= x && x <= MAX(point1a.x, point1b.x);
    BOOL onLineY1 = MIN(point1a.y, point1b.y) <= y && y <= MAX(point1a.y, point1b.y);
    BOOL onLineX2 = MIN(point2a.x, point2b.x) <= x && x <= MAX(point2a.x, point2b.x);
    BOOL onLineY2 = MIN(point2a.y, point2b.y) <= y && y <= MAX(point2a.y, point2b.y);
    
    if (onLineX1 && onLineY1 && onLineX2 && onLineY2)
    {
        [intersectingPoints addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
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

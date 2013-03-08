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
    
    NSArray *points = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:CGPointMake(250 + offset, 0 + offset)]
                       , [NSValue valueWithCGPoint:CGPointMake(500 + offset, 250 + offset)]
                       , [NSValue valueWithCGPoint:CGPointMake(250 + offset, 500 + offset)]
                       , [NSValue valueWithCGPoint:CGPointMake(0 + offset, 250 + offset)]
                       , nil];
    [(View*)self.view setPoints:points];
    
    self.resultLabel = [[UILabel alloc] init];
    [self.resultLabel setFrame:CGRectMake(20, 600, 500, 100)];
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
    [self checkInOut];
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
    [(View*)self.view setTapPoint:location];
    
    [self.view setNeedsDisplay];
    [self checkInOut];
}

#pragma mark - calculations
// these should go into some other class

- (void) checkInOut
{
    //for (NSValue *val in [(View*)self.view points])
    NSArray *points = [(View*)self.view points];
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

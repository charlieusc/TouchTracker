//
//  BNRDrawView.m
//  BNRTouchTracker
//
//  Created by YangJialin on 8/11/16.
//  Copyright © 2016 YangJialin. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView()

@property(nonatomic, strong) NSMutableDictionary *linesInProgress;
@property(nonatomic, strong) NSMutableArray *finishedLines;
@property(nonatomic, strong) NSMutableArray *finishedCircles;
@property(nonatomic, strong) NSMutableArray *circlesIndex;

@end

@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        NSString *path = [self lineArchivePath];
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedCircles = [[NSMutableArray alloc] init];
        self.finishedLines = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(!self.finishedLines){
            self.finishedLines = [[NSMutableArray alloc] init];
        }
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)strokeCircleWithFirstPoint:(BNRLine *)first SecondPoint:(BNRLine *)second
{
    CGPoint center;
    center.x = 0.5 * (first.end.x+second.end.x);
    center.y = 0.5 * (first.end.y+second.end.y);
    float radius = 0.5 * sqrtf(powf(first.end.x - second.end.x, 2) + powf(first.end.y - second.end.y, 2));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(center.x + radius, center.y)];
    [path addArcWithCenter:center
                    radius:radius
                startAngle:0.0
                  endAngle:M_PI*2.0
                 clockwise:YES];
    path.lineWidth = 10;
    [path stroke];
}

- (void)drawRect:(CGRect)rect
{
    for(BNRLine *line in self.finishedLines){
        [line.lineColor set];
        [self strokeLine:line];
    }
    
    for(int i=0; i+1<[self.finishedCircles count]; i+=2){
        BNRLine *first = self.finishedCircles[i];
        BNRLine *second = self.finishedCircles[i+1];
        [[UIColor blackColor] set];
        [self strokeCircleWithFirstPoint:first SecondPoint:second];
    }
    
    [[UIColor redColor] set];
    if([self.linesInProgress count] == 2){
        [self strokeCircleWithFirstPoint:self.linesInProgress.allValues[0] SecondPoint:self.linesInProgress.allValues[1]];
    }else{
        for(NSValue *key in self.linesInProgress){
            [self strokeLine:self.linesInProgress[key]];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for(UITouch *t in touches){
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for(UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        line.end = [t locationInView:self];
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if([touches count] != 2){
        for(UITouch *t in touches){
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            BNRLine *line = self.linesInProgress[key];
            
            float dx = line.end.x - line.begin.x;
            float dy = (line.end.y - line.begin.y);
            CGFloat theta;
            if(dy == 0){
                theta = M_PI/2;
            }else{
                theta = atanf(dx/dy);
            }
            if(theta<0) theta+=M_PI;
            CGFloat paraR = sinf(theta);
            CGFloat paraG = cosf(theta);
            CGFloat paraB = 0.5;
            line.lineColor = [UIColor colorWithRed:paraR green:paraG blue:paraB alpha:1];
            
            [self.finishedLines addObject:line];
            [self.linesInProgress removeObjectForKey:key];
        }
    }else{
        BNRLine *first = self.linesInProgress.allValues[0];
        BNRLine *second = self.linesInProgress.allValues[1];
        [self.finishedCircles addObject:first];
        [self.finishedCircles addObject:second];
        [self.linesInProgress removeAllObjects];
    }
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for(UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}


- (NSString *)lineArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"lines.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self lineArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.finishedLines toFile:path];
}




















@end

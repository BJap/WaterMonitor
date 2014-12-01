//
//  Watercooler.m
//  WaterMonitor
//
//  Created by Robert Jap on 11/29/14.
//  Copyright (c) 2014 Robert Jap. All rights reserved.
//

#import "Watercooler.h"

static NSUInteger defaultCapacity = 5;

static NSString * const kCapacity = @"capacity";
static NSString * const kVolume = @"volume";
static NSString * const kCount = @"count";
static NSString * const kMaxDispensed = @"maxDispensed";

@interface Watercooler()

// Note: Explicitly defining the default readwrite for code understanding

@property (nonatomic, readwrite) NSUInteger maximumCapacity;
@property (nonatomic, readwrite) NSUInteger currentVolume;
@property (nonatomic, readwrite) NSUInteger dispensedCount;
@property (nonatomic, readwrite) NSUInteger maximumDispensed;

@end

@implementation Watercooler

- (id)init
{
    return [self initWithMaxCapacity:defaultCapacity currentVolume:defaultCapacity dispensedCount:0 maxmimumDispensed:0];
}

- (id)initWithCoder:(NSCoder *)coder
{
    NSUInteger capacity = [[coder decodeObjectForKey:kCapacity] unsignedIntegerValue];
    NSUInteger volume = [[coder decodeObjectForKey:kVolume] unsignedIntegerValue];
    NSUInteger count = [[coder decodeObjectForKey:kCount] unsignedIntegerValue];
    NSUInteger maxDispensed = [[coder decodeObjectForKey:kMaxDispensed] unsignedIntegerValue];
    
    return [self initWithMaxCapacity:capacity currentVolume:volume dispensedCount:count maxmimumDispensed:maxDispensed];;
}

// Designated initializer
- (id)initWithMaxCapacity:(NSUInteger)capacity currentVolume:(NSUInteger)volume dispensedCount:(NSUInteger)count maxmimumDispensed:(NSUInteger)maxDispensed
{
    self = [super init];
    
    if (self)
    {
        [self setMaximumCapacity:capacity];
        [self setCurrentVolume:volume];
        [self setDispensedCount:count];
        [self setMaximumDispensed:maxDispensed];
    }
    
    return self;
}

+ (instancetype)coolerWithMaxCapacity:(NSUInteger)capacity
{
    return [[self alloc] initWithMaxCapacity:capacity currentVolume:capacity dispensedCount:0 maxmimumDispensed:0];
}

- (BOOL)isEmpty
{
    return (self.currentVolume == 0);
}

- (NSNumber *)averageDispensed
{
    NSNumber *average = 0;
    
    if (self.dispensedCount != 0)
    {
        float waterDispensed = self.maximumCapacity - self.currentVolume;
        
        average = [NSNumber numberWithFloat:waterDispensed / self.dispensedCount];
    }
    
    return average;
}

- (NSUInteger)dispenseWater:(NSUInteger)water
{
    NSUInteger waterDispensed = MIN(water, self.currentVolume);
    
    if (waterDispensed > 0)
    {
        self.currentVolume -= waterDispensed;
        self.dispensedCount++;
            
        [self setMaximumDispensed:MAX(self.maximumDispensed, water)];
    }
    
    return waterDispensed;
}

- (void)refill
{
    [self setCurrentVolume:self.maximumCapacity];
    [self setDispensedCount:0];
    [self setMaximumDispensed:0];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[NSNumber numberWithUnsignedInteger:self.maximumCapacity] forKey:kCapacity];
    [coder encodeObject:[NSNumber numberWithUnsignedInteger:self.currentVolume] forKey:kVolume];
    [coder encodeObject:[NSNumber numberWithUnsignedInteger:self.dispensedCount] forKey:kCount];
    [coder encodeObject:[NSNumber numberWithUnsignedInteger:self.maximumDispensed] forKey:kMaxDispensed];
}

@end

//
//  Watercooler.h
//  WaterMonitor
//
//  Created by Robert Jap on 11/29/14.
//  Copyright (c) 2014 Robert Jap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Watercooler : NSObject <NSCoding>

// The maximum capacity, in liters, of the watercooler
@property (nonatomic, readonly) NSUInteger maximumCapacity;

// The current amount of water, in liters, in the watercooler
@property (nonatomic, readonly) NSUInteger currentVolume;

// How many times the watercooler has been dispensed since last refill
@property (nonatomic, readonly) NSUInteger dispensedCount;

// The maximum amount of water, in liters, dispensed in a single use since last refill
@property (nonatomic, readonly) NSUInteger maximumDispensed;


/*! Empty initializer.
 * \returns The watercooler with default maximum capacity
 */
- (id)init;

/*! Unarchive initializer.
 * \param coder The values recovered from dearchiving
 * \returns The watercooler with the specified restore state
 */
- (id)initWithCoder:(NSCoder *)coder;

/*! Capacity factory method.
 * \param capacity The maximum capacity, in liters, of the water cooler
 * \returns The watercooler with specified maximum capacity
 */
+ (instancetype)coolerWithMaxCapacity:(NSUInteger)capacity;

/*! The empty status of the watercooler.
 * \returns Whether or not the watercooler is empty
 */
- (BOOL)isEmpty;

/*! The average amount of water dispensed since the last refill.
 * \returns The average water dispensed
 */
- (NSNumber *)averageDispensed;

/*! Dispenses water.
 * \param water The amount of water, in liters, to dispense
 * \return The actual amount of water dispensed (if more than available is requested)
 */
- (NSUInteger)dispenseWater:(NSUInteger)water;

/*! Refills the watercooler.
 */
- (void)refill;

// -the maximum amount dispensed on a single use since the last refill

@end

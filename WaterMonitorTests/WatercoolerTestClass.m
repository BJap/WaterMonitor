//
//  WatercoolerTestClass.m
//  WaterMonitor
//
//  Created by Robert Jap on 11/29/14.
//  Copyright (c) 2014 Robert Jap. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Watercooler.h"

@interface WatercoolerTestClass : XCTestCase

@end

@implementation WatercoolerTestClass

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDefaultInitializer
{
    Watercooler *watercooler = [[Watercooler alloc] init];
    NSUInteger defaultCapacity = 5;
    
    XCTAssertEqual(watercooler.maximumCapacity, defaultCapacity, "The default maximum capacity is not correctly set");
    XCTAssertFalse(watercooler.isEmpty, "The watercooler should be full upon creation");
    XCTAssertEqual(watercooler.dispensedCount, 0, "The dispensed count should be '0' upon creation");
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 0, "The average dispensed count should be '0' upon creation");
    XCTAssertEqual(watercooler.maximumDispensed, 0, "The maximum dispensed count should be '0' upon creation");
}

- (void)testDefaultFactoryMethod
{
    Watercooler *watercooler = [Watercooler new];
    NSUInteger defaultCapacity = 5;
    
    XCTAssertEqual(watercooler.maximumCapacity, defaultCapacity, "The maximum capacity is not correctly set");
    XCTAssertFalse(watercooler.isEmpty, "The watercooler should be full upon creation");
    XCTAssertEqual(watercooler.dispensedCount, 0, "The dispensed count should be '0' upon creation");
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 0, "The average dispensed count should be '0' upon creation");
    XCTAssertEqual(watercooler.maximumDispensed, 0, "The maximum dispensed count should be '0' upon creation");
}

- (void)testCapacityFactoryMethod
{
    NSUInteger testCapacity = 50;
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:testCapacity];
    
    XCTAssertEqual(watercooler.maximumCapacity, testCapacity, "The maximum capacity is not correctly set");
    XCTAssertFalse(watercooler.isEmpty, "The watercooler should be full upon creation");
    XCTAssertEqual(watercooler.dispensedCount, 0, "The dispensed count should be '0' upon creation");
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 0, "The average dispensed count should be '0' upon creation");
    XCTAssertEqual(watercooler.maximumDispensed, 0, "The maximum dispensed count should be '0' upon creation");
}

- (void)testArchivability
{
    NSUInteger testCapacity = 40;
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:testCapacity];
    
    [watercooler dispenseWater:17];
    [watercooler dispenseWater:13];
    
    XCTAssertEqual(watercooler.maximumCapacity, testCapacity, "The maximum capacity is not correctly set for archive testing");
    XCTAssertFalse(watercooler.isEmpty, "The watercooler should be partially full for archive testing");
    XCTAssertEqual(watercooler.dispensedCount, 2, "The dispensed count should be '2' for archive testing");
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 15.0, "The average dispensed count should be '15.0' for archive testing");
    XCTAssertEqual(watercooler.maximumDispensed, 17, "The maximum dispensed count should be '17' for archive testing");
    
    NSData *encodedCooler = [NSKeyedArchiver archivedDataWithRootObject:watercooler];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"cooler";
    
    [defaults setObject:encodedCooler forKey:key];
    [defaults synchronize];
    
    encodedCooler = [defaults objectForKey:key];
    watercooler = [NSKeyedUnarchiver unarchiveObjectWithData:encodedCooler];
    
    XCTAssertEqual(watercooler.maximumCapacity, testCapacity, "The maximum capacity is not correctly restored");
    XCTAssertFalse(watercooler.isEmpty, "The watercooler should be partially full after restoration");
    XCTAssertEqual(watercooler.dispensedCount, 2, "The dispensed count should be '2' after restoration");
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 15.0, "The average dispensed count should be '15.0' after restoration");
    XCTAssertEqual(watercooler.maximumDispensed, 17, "The maximum dispensed count should be '17' after restoration");
    
    [defaults removeObjectForKey:key];
}

- (void)testDispenseWater
{
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:10];
    
    [watercooler dispenseWater:7];
    
    XCTAssertEqual(watercooler.currentVolume, 3, "The watercooler did not correctly dispense once");
    
    [watercooler dispenseWater:2];
    
    XCTAssertEqual(watercooler.currentVolume, 1, "The watercooler did not correctly dispense a second time");
}

- (void)testDispenseMoreWaterThanCurrent
{
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:10];
    
    XCTAssertEqual([watercooler dispenseWater:14], 10, "The watercooler did not correctly dispense the actual amount it had less than requested");
}

- (void)testDispenseFromEmptyWatercooler
{
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:0];
    
    XCTAssertEqual([watercooler dispenseWater:8], 0, "The watercooler did not correctly dispense zero liters of water");
}

- (void)testRefill
{
    NSUInteger testCapacity = 20;
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:testCapacity];
    
    XCTAssertEqual(watercooler.currentVolume, testCapacity, "The watercooler did not begin with the correct volume");
    
    [watercooler dispenseWater:8];
    
    XCTAssertEqual(watercooler.currentVolume, 12, "The watercooler cannot be refilled since it did not correctly dispense");
    
    [watercooler refill];
    
    XCTAssertEqual(watercooler.currentVolume, testCapacity, "The watercooler did not refill correctly");
}

- (void)testEmptyIndicator
{
    NSUInteger testCapacity = 30;
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:testCapacity];
    
    XCTAssertFalse(watercooler.isEmpty, "The watercooler should not be empty upon creation");
    
    [watercooler dispenseWater:testCapacity];
    
    XCTAssertEqual(watercooler.currentVolume, 0, "The watercooler did not dispense all water contents to test if empty");
    
    XCTAssertTrue(watercooler.isEmpty, "The watercooler should be empty when the complete water content is dispensed");
    
    [watercooler refill];
    
    XCTAssertFalse(watercooler.isEmpty, "The watercooler should not be empty upon refill");
    
    [watercooler dispenseWater:10];
    
    XCTAssertFalse(watercooler.isEmpty, "The watercooler should not be empty when partially full of water");
}

- (void)testDispensedCount
{
    NSUInteger testCapacity = 30;
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:testCapacity];
    
    XCTAssertEqual(watercooler.dispensedCount, 0, "The watercooler should have a '0' dispense count upon creation since there is full volume");
    
    [watercooler dispenseWater:5];
    
    XCTAssertEqual(watercooler.dispensedCount, 1, "The watercooler did not count dispenses correctly upon first dispense");
    
    [watercooler dispenseWater:13];
    
    XCTAssertEqual(watercooler.dispensedCount, 2, "The watercooler did not count dispenses correctly upon second dispense");
    
    [watercooler dispenseWater:12];
    
    XCTAssertEqual(watercooler.dispensedCount, 3, "The watercooler did not count dispenses correctly upon third dispense");
    
    [watercooler dispenseWater:0];
    
    XCTAssertEqual(watercooler.dispensedCount, 3, "The watercooler did not count dispenses correctly upon attempted dispense of '0' liters");
    
    [watercooler refill];
    
    XCTAssertEqual(watercooler.dispensedCount, 0, "The watercooler should not have a reset '0' dispense count upon refill");
}

- (void)testAverageDispensed
{
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:30];
    
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 0.0, "The average dispensed didn't correctly initialize to '0.0' for testing");
    
    [watercooler dispenseWater:6];
    
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 6.0, "The average dispensed didn't correctly change for first dispense");
    
    [watercooler dispenseWater:2];
    
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 4.0, "The average dispensed didn't correctly change for second dispense");
    
    [watercooler dispenseWater:10];
    
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 6.0, "The average dispensed didn't correctly change for third dispense");
    
    [watercooler dispenseWater:0];
    
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 6.0, "The average dispensed didn't correctly remain unchanged upon dispense of '0' liters");
    
    [watercooler refill];
    
    XCTAssertEqual(watercooler.averageDispensed.floatValue, 0.0, "The average dispensed didn't correctly reset to '0.0' after refill");
}

- (void)testMaximumDispensed
{
    Watercooler *watercooler = [Watercooler coolerWithMaxCapacity:25];
    
    XCTAssertEqual(watercooler.maximumDispensed, 0, "The maximum dispensed didn't correctly initialize to '0' for testing");
    
    [watercooler dispenseWater:4];
    
    XCTAssertEqual(watercooler.maximumDispensed, 4, "The maximum dispensed didn't correctly change to great than zero for first dispense");
    
    [watercooler dispenseWater:6];
    
    XCTAssertEqual(watercooler.maximumDispensed, 6, "The maximum dispensed didn't correctly increase for greater number second dispense");
    
    [watercooler dispenseWater:2];
    
    XCTAssertEqual(watercooler.maximumDispensed, 6, "The maximum dispensed didn't correctly remain the same for smaller number third dispense");
    
    [watercooler dispenseWater:6];
    
    XCTAssertEqual(watercooler.maximumDispensed, 6, "The maximum dispensed didn't correctly remain the same for equal number fourth dispense");
    
    [watercooler refill];
    
    XCTAssertEqual(watercooler.maximumDispensed, 0, "The maximum dispensed didn't correctly reset to '0' after refill");
}

@end

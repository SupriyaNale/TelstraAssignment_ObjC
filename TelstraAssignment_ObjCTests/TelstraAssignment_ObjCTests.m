//
//  TelstraAssignment_ObjCTests.m
//  TelstraAssignment_ObjCTests
//
//  Created by Yash on 16/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface TelstraAssignment_ObjCTests : XCTestCase
{
    ViewController *viewControllerObj;
}
@end

@implementation TelstraAssignment_ObjCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    viewControllerObj = [storyBoard instantiateViewControllerWithIdentifier:@"ViewController"];
    XCTAssertNotNil(viewControllerObj, @"ViewController not initiated properly");
    
    [viewControllerObj performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [viewControllerObj performSelectorOnMainThread:@selector(viewDidLoad) withObject:nil waitUntilDone:YES];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testThatViewConformsToTableViewDelegate {
    XCTAssertTrue([viewControllerObj conformsToProtocol:@protocol(UITableViewDelegate)],@"ViewController conforms to UITableViewDelegate");
}

- (void)testThatViewConformsToTableViewDatasource {
    XCTAssertTrue([viewControllerObj conformsToProtocol:@protocol(UITableViewDataSource)],@"ViewController conforms to UITableViewDataSource");
}


- (void)testThatViewLoads {
    XCTAssertNotNil(viewControllerObj, "ViewController View not initiated properly");
}


- (void)testThatTableViewLoads {
    XCTAssertNotNil(viewControllerObj.tableView, "TableView not initiated");
}


@end

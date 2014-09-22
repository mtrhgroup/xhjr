//
//  NewsTest.m
//  NewsTest
//
//  Created by apple on 13-4-7.
//
//

#import "NewsTest.h"
#import "XinHuaViewController.h"
@implementation NewsTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
   XinHuaViewController *controller= [[XinHuaViewController alloc]init];
    [controller loadView];
    STAssertFalse(controller.toVipBtn.enabled, @"vip enabled is NO");
    
    STAssertNil(nil, @"nil test OK");
}

@end

//
//  LATruckListNavController.m
//  LunchAddict
//
//  Created by SPEROWARE on 30/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LATruckListNavController.h"

@interface LATruckListNavController ()

@end

@implementation LATruckListNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

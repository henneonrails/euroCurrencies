//
//  CAHViewController.m
//  EuroCurrenciesExample
//
//  Created by Holger Hänisch on 29.01.14.
//  Copyright (c) 2014 Holger Hänisch. All rights reserved.
//

#import "CAHViewController.h"
#import "CAHEuroCurrencies.h"

@interface CAHViewController ()

@end

@implementation CAHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // standart initializer here
    CAHEuroCurrencies *euroManager = [[CAHEuroCurrencies alloc] initWithCurrency:@"GBP"];
    
    //here we only get a result if this conversion rate has been downloaded before and
    //therfore is stored in the UserDefaults
    NSLog(@"early access to conversion rate: %@", euroManager.conversionRateAsString);
    
    //call getConversionRate with callback. It waits until a conversion rate is downloaded
    [euroManager getConversionRate:^(float conversionRateAsFloat) {
        NSLog(@"Conversion Rata: %f", conversionRateAsFloat);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

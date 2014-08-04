//
//  CAHEuroCurrencies.h
//  EuroRechner GBP
//
//  Created by Holger Hänisch on 28.01.14.
//  Copyright (c) 2014 Holger Hänisch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CAHEuroCurrenciesCallback)(float conversionRateAsFloat);

/**
 *  Class for getting conversion rates published by the ecb (once a day)
 example:
 
 CAHEuroCurrencies *euroCurrenciesManager = [[CAHEuroCurrencies alloc] initWithCurrency:@"GBP"];
 [self.euroCurrenciesManager getConversionRate:^(float rate) {
 XLog(@"conversionRateAsFloat %f", rate);
 //now you have access to the properties conversionRateAsString
 //and conversionRateAsFloat also.
 }];
 
 after the init call the currency rate is also saved to the user defaults. So
 it is faster to get the values by properties. Or think of not having a internet
 connection.
 */
@interface CAHEuroCurrencies : NSObject

/**
 *  Initializise Class with a ISO currency value to get it's actual conversion rate. The
 *  rate is loaded online from the European Central Bank. Updated daily.
 *  @param CurrencyAbbreviation ISO String for currency you like to convert
 */
-(instancetype)initWithCurrency:(NSString*)CurrencyAbbreviation;

/**
 *  After initialize you can now access the conversion rate in the callback block
 *
 *  @param callback is called when the rate is loaded from web and it passes
 *            the float with the conversion rate
 */
-(void)getConversionRate:(CAHEuroCurrenciesCallback)callback;

/**
 *  values are only available after calling the initWithCurrency. This takes a while because
 *  of loading from web. If you want your value as soon as possible, call the
 *  getConversionRate:callback methode. The callback is called when there is a value
 *  loaded from web.
 *  The rates are also saved in the UserDefaults. So after calling once a currency rate
 *  it is possible to get the old rate by reading these properties.
 */
@property (nonatomic, readonly)NSString *conversionRateAsString;
@property (nonatomic, readonly)float conversionRateAsFloat;
@property (nonatomic, readonly)NSDate *dateOfConversionRate;

/**
 *  simple conversion helper for converting a float after initializing this class with
 *  initWithCurrency:(NSString *)currencyAbbreviation
 *  and waiting for the callback in
 *  getConversionRate:(CAHEuroCurrenciesCallback)callback
 *
 *  @param currencyAmount the amount to convert (e.g. 10$)
 *
 *  @return the amount converted to euros
 */
-(float)convertToEuro:(float)currencyAmount;

@end

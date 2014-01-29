//
//  CAHEuroCurrencies.m
//  EuroRechner GBP
//
//  Created by Holger Hänisch on 28.01.14.
//  Copyright (c) 2014 Holger H√§nisch. All rights reserved.
//

#import "CAHEuroCurrencies.h"
#define kECB @"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
#define kChangedDate @"Date"

@interface CAHEuroCurrencies ()
@property (nonatomic, strong)NSString *isoCurrencySymbol;
@property (nonatomic, strong)NSString *stringToParse;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfig;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong)NSString *conversionRateAsString;
@property float conversionRateAsFloat;
@property (nonatomic, strong)CAHEuroCurrenciesCallback callback;
@end

@implementation CAHEuroCurrencies

-(instancetype)initWithCurrency:(NSString *)CurrencyAbbreviation {
    self = [super init];
    if (self) {
        self.isoCurrencySymbol = CurrencyAbbreviation;
        self.sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfig];
        [self getXML];
    }
    return self;
}

-(float)convertToEuro:(float)currencyAmount {
    float euroValue = 0.0;
    euroValue = currencyAmount / self.conversionRateAsFloat;
    return euroValue;
}

-(float)conversionRateAsFloat {
    if (_conversionRateAsFloat == 0.0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _conversionRateAsFloat = [defaults floatForKey:self.isoCurrencySymbol];
    }
    return _conversionRateAsFloat;
}

-(NSString *)conversionRateAsString {
    if (!_conversionRateAsString) {
        _conversionRateAsString = [NSString stringWithFormat:@"%f", self.conversionRateAsFloat];
    }
    return _conversionRateAsString;
}

#pragma mark - string parsing

-(NSNumber *)parseString:(NSString *)string {
    NSArray *array = [string componentsSeparatedByString:@"<"];
    NSString *substring;
    for (NSString *string in array) {
        if ([string rangeOfString:self.isoCurrencySymbol].location != NSNotFound) {
            XLog(@"currency %@", string);
            NSRange range = [string rangeOfString:@"rate='"];
            range.location += 6;
            substring = [string substringWithRange:range];
            XLog(@"substring %@",substring);
        }
    }
    if ([substring floatValue] > 0.0) {
        NSNumber *number = [NSNumber numberWithFloat:[substring floatValue]];
        return number;
    } else {
        return nil;
    }
}

-(void)handleSearchResult:(NSData *)data {
    NSString *receivedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSNumber *value = [self parseString:receivedData];
    _conversionRateAsFloat = [value floatValue];
    self.callback(self.conversionRateAsFloat);
    [self saveConversionRateToUserDefaults];
}

#pragma mark - networking

-(void)getXML {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = [NSURL URLWithString:kECB];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
                [self handleSearchResult:data];
        } else {
            NSString *body = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
            NSLog(@"Received HTTP %ld:  %@", (long)httpResponse.statusCode, body);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"Received an error from the server"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            });
        }//else
        }]; //completion handler
    [task resume];
}

-(void)getConversionRate:(CAHEuroCurrenciesCallback)callback {
    self.callback = callback;
}

-(BOOL)saveConversionRateToUserDefaults {
    if (self.isoCurrencySymbol && self.conversionRateAsFloat)  {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:self.conversionRateAsFloat forKey:self.isoCurrencySymbol];
        [defaults synchronize];
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)loadConversionRateFromUserDefaults:(NSString *)currencySymbol
{
    if (self.conversionRateAsFloat) {
        return NO;
    }
    if (currencySymbol) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.conversionRateAsFloat = [defaults floatForKey:currencySymbol];
    }
    if (self.conversionRateAsFloat) {
        return YES;
    } else {
        return NO;
    }
}
@end

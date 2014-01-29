euroCurrencies
==============

Roundup
-------
With this small class you are able to load a currency value based on 1 Euro. 

Detail
------
The data is loaded from the ecb (european central bank). The currency data is updated only once a day. You have to pass the [ISO 4217](http://en.wikipedia.org/wiki/ISO_4217) value for the currency.

Usage
-----
First initialize the class. In this example we use Pound sterling.

```objective-c
CAHEuroCurrencies *euroManager = [[CAHEuroCurrencies alloc] initWithCurrency:@"GBP"];
```
then you are able to get the convert value by calling

```objective-c
[euroManager getConversionRate:^(float conversionRateAsFloat) {
        NSLog(@"Conversion rate: %f", conversionRateAsFloat);
    }];

```
the block is only called when the currency value is loaded. So you might have to wait. It is also possible to call these properties:

```objective-c
@property (nonatomic, readonly)NSString *conversionRateAsString;
@property (nonatomic, readonly)float conversionRateAsFloat;
```

but they might be nil if you haven't called `getConversionRate` before. If you have ever loaded the value of the currency, then the last value is stored in the user defaults. And you can get immediate access to the properties.

Currency
--------
iso 4217 | advertised
-------- | ----------
USD | United States dollar
JPY | Japanese yen
BGN | Bulgarian lev
CZK | Czech koruna
DKK | Danish krone
GBP | Pound sterling
HUF | Hungarian forint
LTL | Lithuanian litas
PLN | Polish złoty
RON | Romanian new leu
SEK | Swedish krona
CHF | Swiss franc
NOK | Norwegian krone
HRK | Croatian kuna
RUB | Russian ruble
TRY | Turkish lira
AUD | Australian dollar
BRL | Brazilian real
CAD | Canadian dollar
CNY | Chinese yuan
HKD | Hong Kong dollar
IDR | Indonesian rupiah
ILS | Israeli new shekel
INR | Indian rupee
KRW | South Korean won
MXN | Mexican peso
MYR | Malaysian ringgit
NZD | New Zealand dollar
PHP | Philippine peso
SGD | Sudanese pound
THB | Thai baht
ZAR | South African rand


//
//  CAHDetailViewController.h
//  CAHEuroCurrencies
//
//  Created by Holger Hänisch on 29.01.14.
//  Copyright (c) 2014 Holger Hänisch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAHDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

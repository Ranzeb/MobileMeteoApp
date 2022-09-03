//
//  FirstViewController.h
//  Meteo
//
//  Created by Gabriele Ranzieri on 03/09/2019.
//  Copyright © 2019 Gabriele Ranzieri. All rights reserved.
//

#import <UIKit/UIKit.h>
//UITextField *_nameTextField;
//UITextField *_originTextField;
//UITextView *_descriptionTextView;

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UIScrollViewDelegate>
//@property (strong, nonatomic) UILabel *scoreLabel;

@property (strong, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UIImageView *imgBgView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *greyOverlay;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarReal;


@end


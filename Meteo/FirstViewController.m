//
//  FirstViewController.m
//  Meteo
//
//  Created by Gabriele Ranzieri on 03/09/2019.
//  Copyright © 2019 Gabriele Ranzieri. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@interface FirstViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;
@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *rangeTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *hiloLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *btnHeart;
@property (strong, nonatomic) IBOutlet UIView *header;
@property (nonatomic) BOOL preferenceChecked;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic) BOOL hidesSearchBarWhenScrolling;


@end

@implementation FirstViewController{
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    NSArray *dictionaries;
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
    NSInteger rowNo;
}


- (IBAction)tappedRightButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];

    [self.tabBarController setSelectedIndex:selectedIndex + 1];
}

- (IBAction)tappedLeftButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];

    [self.tabBarController setSelectedIndex:selectedIndex - 1];
}



- (void)viewDidLoad {
    [super viewDidLoad];
 
   
   
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    
    
    self.navigationItem.title = @"Weather";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    _greyOverlay.hidden = true;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self->locationManager requestWhenInUseAuthorization];
    
    
    [locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view.
    /*
    NSDictionary *json = [self sendHTTPGet: @"Parma,IT"];
    NSString *errorCode = [json objectForKey:@"cod"];
    
    if([errorCode  isEqual: @"404"]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"City not found"
                                                                       message:@"Please enter a correct city"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    
    }else{
    
    _cityName = [json objectForKey:@"name"];
    
    NSString *timezone = [json objectForKey:@"dt"];
    
    NSMutableArray *weather = [json objectForKey:@"weather"];
    
    NSDictionary *idWeather = weather[0];
    
    NSString *weatherDescription = [idWeather objectForKey:@"description"];
    NSString *iconId = [idWeather objectForKey:@"icon"];
    

    
    //    NSString *weatherDescription = [weather objectForKey:@"description"];
    
    NSDictionary *main = [json objectForKey:@"main"];
    
    NSString *temp = [main objectForKey:@"temp"];
    NSString *tempMin = [main objectForKey:@"temp_min"];
    NSString *tempMax = [main objectForKey:@"temp_max"];
    
    int tempCelsius = [temp intValue];
    (void)(tempCelsius -= 273),15;
    
    int tempMinCelsius = [tempMin intValue];
    (void)(tempMinCelsius -= 273),15;
    
    int tempMaxCelsius = [tempMax intValue];
    (void)(tempMaxCelsius -= 273),15;

    
    NSString *tempFinale =  [NSString stringWithFormat:@"%d",tempCelsius];
    
    
    NSDictionary *sys = [json objectForKey:@"sys"];
    
    NSString *country = [sys objectForKey:@"country"];
    
    
    
    
    
    
    NSString *strMaxCelsius = [NSString stringWithFormat:@"%d",tempMaxCelsius];
    NSString *strRangeTemp = [NSString stringWithFormat:@"%d",tempMinCelsius];
    strRangeTemp = [strRangeTemp stringByAppendingString:@"° / "];
    
    strRangeTemp = [strRangeTemp stringByAppendingString:strMaxCelsius];
    
    strRangeTemp = [strRangeTemp stringByAppendingString:@"°"];
    

    //    Calcolo l'orario della città selezionata
    
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:[timezone doubleValue]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSString  *finalate = [dateFormatter stringFromDate:myDate];

    */

   
    _cityName = @"Loading..";
    NSString *tempFinale = @"0";
    NSString *strRangeTemp =@"0°/0°";
    NSString *country = @"";
    NSString *weatherDescription = @"";
    NSString *iconId = @"";
    
    self.view.backgroundColor = [UIColor redColor];
    
    // 1
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIImage *background = [UIImage imageNamed:@"background.jpg"];
    
    // 2
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    
    // 4
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.tableView setContentOffset:CGPointMake(0,self.searchBar.frame.size.height - self.tableView.contentOffset.y+35) animated:YES];
    [self.view addSubview:self.tableView];
    
    
    
    
    
    // 1
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
//    NSLog(@"Currently, width: %.2f, height: %.2f",
//          
//          [[UIScreen mainScreen] bounds].size.width,
//          [[UIScreen mainScreen] bounds].size.height);
    // 2
    CGFloat inset = 20;
    // 3
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 50;
    // 4
    CGRect hiloFrame = CGRectMake(inset,
                                  headerFrame.size.height - hiloHeight -100,
                                  headerFrame.size.width - (2 * inset),
                                  hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset,
                                         headerFrame.size.height - (temperatureHeight + hiloHeight)-100,
                                         headerFrame.size.width - (2 * inset),
                                         temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset,
                                  temperatureFrame.origin.y - iconHeight,
                                  iconHeight,
                                  iconHeight+20
                                  );
    
    CGRect heartFrame = CGRectMake(inset,
                                  hiloFrame.origin.x + 35,
                                  iconHeight,
                                  20
                                  );
    
   
    // 5
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    
    // 1
    _searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    _searchBar.placeholder  = @"Search a city (es. Parma,IT)";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    self.navigationItem.searchController = self.searchController;
    
    self.navigationItem.hidesSearchBarWhenScrolling = true;
    
    _header = [[UIView alloc] initWithFrame:headerFrame];
    _header.backgroundColor = [UIColor clearColor];
//    self.tableView.tableHeaderView = _searchBar;
//    self.tableView.tableHeaderView = nil;

    self.tableView.tableFooterView = _header;

    // 2
    // bottom left
    tempFinale = [tempFinale stringByAppendingString:@"°"];
    _temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    _temperatureLabel.backgroundColor = [UIColor clearColor];
    _temperatureLabel.textColor = [UIColor blackColor];
    _temperatureLabel.text = tempFinale;
    _temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [_header addSubview:_temperatureLabel];
    
    // bottom left
    _hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    _hiloLabel.backgroundColor = [UIColor clearColor];
    _hiloLabel.textColor = [UIColor blackColor];
    _hiloLabel.text = strRangeTemp;
    _hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [_header addSubview:_hiloLabel];
    
    
    
   
    

    // top
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 30)];
    _cityLabel.backgroundColor = [UIColor clearColor];
    _cityLabel.textColor = [UIColor blackColor];
    
    _cityName = [_cityName stringByAppendingString:@","];
    _cityName = [_cityName stringByAppendingString:country];
    _cityLabel.text = _cityName;
    _cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    [_header addSubview:_cityLabel];
    

    
    // top under cityLabel
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 50)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.text = @"";
    _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_header addSubview:_timeLabel];
    
    _conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    _conditionsLabel.backgroundColor = [UIColor clearColor];
    _conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    _conditionsLabel.textColor = [UIColor blackColor];
    _conditionsLabel.text = weatherDescription;
    [_header addSubview:_conditionsLabel];
    
    // 3
    // bottom left
    
   
    
    
   
    _iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    _iconView.image = [UIImage imageNamed:iconId];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.backgroundColor = [UIColor clearColor];
    [_header addSubview:_iconView];
    
    _btnHeart = [[UIImageView alloc] initWithFrame:heartFrame];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
   
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Cities" inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@ ", _cityName]];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];

    if(results == nil || [results count] == 0) {
        _btnHeart.image = [UIImage imageNamed:@"notFavorite.png"];
        // we need to put this true or false, based on db information
        _preferenceChecked = false;
    }
    else{
        _btnHeart.image = [UIImage imageNamed:@"favorite.png"];
        // we need to put this true or false, based on db information
        _preferenceChecked = true;
        
    }
    _btnHeart.contentMode = UIViewContentModeScaleAspectFit;
    _btnHeart.backgroundColor = [UIColor clearColor];
    [_header addSubview:_btnHeart];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [_btnHeart setUserInteractionEnabled:YES];
    [_btnHeart addGestureRecognizer:singleTap];
//    }
}




// here it is the function in which we need to add city to the preferredList
-(void)tapDetected{
    if(_preferenceChecked == false){
     _btnHeart.image = [UIImage imageNamed:@"favorite.png"];
     _preferenceChecked = true;
        // Save Data
     appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
     context = appDelegate.persistentContainer.viewContext;
        
     
     NSManagedObject *entityObj = [NSEntityDescription insertNewObjectForEntityForName:@"Cities" inManagedObjectContext:context];
     [entityObj setValue:_cityName forKey:@"name"];
     [appDelegate saveContext];
      
        
        
        
    }else{
        _btnHeart.image = [UIImage imageNamed:@"notFavorite.png"];
        _preferenceChecked = false;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"Cities" inManagedObjectContext:self->context]];
            
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@ ", self->_cityName]];
            
            NSError* error = nil;
            NSArray* results = [self->context executeFetchRequest:fetchRequest error:&error];
            for (id currentObj in results) {
                
                [self->context deleteObject:currentObj];
                [self->appDelegate saveContext];
            }
           
        });
       
}
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    //executes when you scroll the scrollView
//    self.navigationItem.hidesSearchBarWhenScrolling = TRUE;
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // execute when you drag the scrollView
    //Grafica
    
    
    self.tableView.tableHeaderView = _searchBar;
    
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = false;
    searchBar.text = @"";
    [self.view endEditing:YES];
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = true;
//    [self.view setBackgroundColor: (id)[[UIColor colorWithWhite:0.0 alpha:0.30]CGColor]];
     
    _greyOverlay.hidden = true;
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *str = searchBar.text;
    
    str = [str stringByReplacingOccurrencesOfString:@" "
                                         withString:@"+"];
    
    NSDictionary *json;
    if([str isEqual:@"CurrentPosition"]){
        NSDictionary *jsonCurrentPosition = [self sendHTTPGet: str];
        
        NSString *cityToResearch = [jsonCurrentPosition objectForKey:@"name"];
        
        cityToResearch = [cityToResearch stringByReplacingOccurrencesOfString:@" "
                                             withString:@"+"];
        
        json = [self sendHTTPGet:cityToResearch];
        
    }else{
        json = [self sendHTTPGet: str];
    }
    
   
    
    NSString *errorCode = [json objectForKey:@"cod"];
    
    
    if([errorCode  isEqual: @"404"]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"City not found"
                                                                       message:@"Please enter a correct city"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        
    
    _cityName = [json objectForKey:@"name"];

   
    
    
    
    NSString *timezone = [json objectForKey:@"dt"];
    
    NSMutableArray *weather = [json objectForKey:@"weather"];
    
    NSDictionary *idWeather = weather[0];
    
    NSString *weatherDescription = [idWeather objectForKey:@"description"];
    NSString *iconId = [idWeather objectForKey:@"icon"];
    
   
    
    //    NSString *weatherDescription = [weather objectForKey:@"description"];
    
    NSDictionary *main = [json objectForKey:@"main"];
    
    NSString *temp = [main objectForKey:@"temp"];
    NSString *tempMin = [main objectForKey:@"temp_min"];
    NSString *tempMax = [main objectForKey:@"temp_max"];
    
    int tempCelsius = [temp intValue];
    (void)(tempCelsius -= 273),15;
    
    int tempMinCelsius = [tempMin intValue];
        (void)(tempMinCelsius -= 273),15;
    
    int tempMaxCelsius = [tempMax intValue];
        (void)(tempMaxCelsius -= 273),15;

    
    NSString *tempFinale =  [NSString stringWithFormat:@"%d",tempCelsius];
    
    
    NSDictionary *sys = [json objectForKey:@"sys"];
    
    NSString *country = [sys objectForKey:@"country"];
    

    NSString *strMaxCelsius = [NSString stringWithFormat:@"%d",tempMaxCelsius];
    NSString *strRangeTemp = [NSString stringWithFormat:@"%d",tempMinCelsius];
    strRangeTemp = [strRangeTemp stringByAppendingString:@"° / "];
    
    strRangeTemp = [strRangeTemp stringByAppendingString:strMaxCelsius];
    
    strRangeTemp = [strRangeTemp stringByAppendingString:@"°"];
    
    
    
    
    
    
 
    [self.tableView removeFromSuperview];
    //    Calcolo l'orario della città selezionata
    
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:[timezone doubleValue]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSString  *finalate = [dateFormatter stringFromDate:myDate];
    
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.tableView setContentOffset:CGPointMake(0,self.searchBar.frame.size.height - self.tableView.contentOffset.y) animated:YES];
    [self.view addSubview:self.tableView];
    
    
    
    
    
    // 1
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    //    NSLog(@"Currently, width: %.2f, height: %.2f",
    //
    //          [[UIScreen mainScreen] bounds].size.width,
    //          [[UIScreen mainScreen] bounds].size.height);
    // 2
    CGFloat inset = 20;
    // 3
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 50;
    // 4
    CGRect hiloFrame = CGRectMake(inset,
                                  headerFrame.size.height - hiloHeight -100,
                                  headerFrame.size.width - (2 * inset),
                                  hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset,
                                         headerFrame.size.height - (temperatureHeight + hiloHeight)-100,
                                         headerFrame.size.width - (2 * inset),
                                         temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset,
                                  temperatureFrame.origin.y - iconHeight,
                                  iconHeight,
                                  iconHeight+20
                                  );
    
    CGRect heartFrame = CGRectMake(inset,
                                   hiloFrame.origin.x + 35,
                                   iconHeight,
                                   20
                                   );
    
    
    // 5
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    
    // 1
    _searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    _searchBar.placeholder  = @"Search a city (es. Parma,IT)";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    self.navigationItem.searchController = self.searchController;
    
    self.navigationItem.hidesSearchBarWhenScrolling = true;
    
    _header = [[UIView alloc] initWithFrame:headerFrame];
    _header.backgroundColor = [UIColor clearColor];
    //    self.tableView.tableHeaderView = _searchBar;
    //    self.tableView.tableHeaderView = nil;
    
    self.tableView.tableFooterView = _header;
    
    // 2
    // bottom left
    tempFinale = [tempFinale stringByAppendingString:@"°"];
    _temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    _temperatureLabel.backgroundColor = [UIColor clearColor];
    _temperatureLabel.textColor = [UIColor blackColor];
    _temperatureLabel.text = tempFinale;
    _temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [_header addSubview:_temperatureLabel];
    
    // bottom left
    _hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    _hiloLabel.backgroundColor = [UIColor clearColor];
    _hiloLabel.textColor = [UIColor blackColor];
    _hiloLabel.text = strRangeTemp;
    _hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [_header addSubview:_hiloLabel];
    
    
    
    
    
    
    // top
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 30)];
    _cityLabel.backgroundColor = [UIColor clearColor];
    _cityLabel.textColor = [UIColor blackColor];
    
    _cityName = [_cityName stringByAppendingString:@","];
    _cityName = [_cityName stringByAppendingString:country];
    _cityLabel.text = _cityName;
    _cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    [_header addSubview:_cityLabel];
    
    
    
    // top under cityLabel
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 50)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.text = @"";
    _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_header addSubview:_timeLabel];
    
    _conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    _conditionsLabel.backgroundColor = [UIColor clearColor];
    _conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    _conditionsLabel.textColor = [UIColor blackColor];
    _conditionsLabel.text = weatherDescription;
    [_header addSubview:_conditionsLabel];
    
    // 3
    // bottom left
    
    
    
    
    
    _iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    _iconView.image = [UIImage imageNamed:iconId];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.backgroundColor = [UIColor clearColor];
    [_header addSubview:_iconView];
    
    _btnHeart = [[UIImageView alloc] initWithFrame:heartFrame];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Cities" inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@ ", _cityName]];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if(results == nil || [results count] == 0) {
        _btnHeart.image = [UIImage imageNamed:@"notFavorite.png"];
        // we need to put this true or false, based on db information
        _preferenceChecked = false;
    }
    else{
        _btnHeart.image = [UIImage imageNamed:@"favorite.png"];
        // we need to put this true or false, based on db information
        _preferenceChecked = true;
        
    }
    _btnHeart.contentMode = UIViewContentModeScaleAspectFit;
    _btnHeart.backgroundColor = [UIColor clearColor];
    [_header addSubview:_btnHeart];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [_btnHeart setUserInteractionEnabled:YES];
    [_btnHeart addGestureRecognizer:singleTap];

    searchBar.showsCancelButton = false;
    searchBar.text = @"";
    self.tableView.tableHeaderView = nil;
    [self.view endEditing:YES];
    }
    
    //  check if the city is in preferites
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Cities" inManagedObjectContext:context]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@ ", _cityName]];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];

    if(results == nil || [results count] == 0) {
        _btnHeart.image = [UIImage imageNamed:@"notFavorite.png"];
        // we need to put this true or false, based on db information
        _preferenceChecked = false;
    }
    else{
        _btnHeart.image = [UIImage imageNamed:@"favorite.png"];
        // we need to put this true or false, based on db information
        _preferenceChecked = true;
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// 1
#pragma mark - UITableViewDataSource

// 2
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // 3
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    // TODO: Setup the cell
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Determine cell height based on screen
    return 44;
}



- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}


-(NSDictionary *) sendHTTPGet:(NSString*)city {
    
    /*   NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=f77df9c25ef4eb5cd3851aec67bffc7c"]];
     */
    
    NSString *stringUrl;
    if([city  isEqual: @"CurrentPosition"]){
        
        
        stringUrl = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial",latitude,longitude];
        
        
        stringUrl = [stringUrl stringByAppendingString:@"&APPID=f77df9c25ef4eb5cd3851aec67bffc7c"];
        
      
    }else{
    
    
        stringUrl = @"https://api.openweathermap.org/data/2.5/weather?q=";
        
        stringUrl = [stringUrl stringByAppendingString:city];
        
        stringUrl = [stringUrl stringByAppendingString:@"&APPID=f77df9c25ef4eb5cd3851aec67bffc7c"];
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:stringUrl]];
    
    //MEGLIO USARE NSSession come ho fatto per scaricare!
    
    NSData *theData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:nil
                                                        error:nil];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:theData
                                                         options:0
                                                           error:nil];

    
    return json;
    }



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    
    longitude = location.coordinate.longitude;
    latitude = location.coordinate.latitude;
    
    NSDictionary *jsonCurrentPosition = [self sendHTTPGet: @"CurrentPosition"];
    NSString *errorCode = [jsonCurrentPosition objectForKey:@"cod"];
    
    if([errorCode  isEqual: @"404"]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"City not found"
                                                                       message:@"Please enter a correct city"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        NSString *cityToResearch = [jsonCurrentPosition objectForKey:@"name"];
        
        NSDictionary *sysCurrent = [jsonCurrentPosition objectForKey:@"sys"];
        
        NSString *countryCurrent = [sysCurrent objectForKey:@"country"];
        
        cityToResearch = [cityToResearch stringByAppendingString:@","];
        cityToResearch = [cityToResearch stringByAppendingString:countryCurrent];
        NSDictionary *json = [self sendHTTPGet:cityToResearch];
        _cityName = [json objectForKey:@"name"];
        
        NSString *timezone = [json objectForKey:@"dt"];
        
        NSMutableArray *weather = [json objectForKey:@"weather"];
        
        NSDictionary *idWeather = weather[0];
        
        NSString *weatherDescription = [idWeather objectForKey:@"description"];
        NSString *iconId = [idWeather objectForKey:@"icon"];
        
        
        
        //    NSString *weatherDescription = [weather objectForKey:@"description"];
        
        NSDictionary *main = [json objectForKey:@"main"];
        
        NSString *temp = [main objectForKey:@"temp"];
        NSString *tempMin = [main objectForKey:@"temp_min"];
        NSString *tempMax = [main objectForKey:@"temp_max"];
        

        int tempCelsius = [temp intValue];
        (void)(tempCelsius -= 273),15;
        
        int tempMinCelsius = [tempMin intValue];
        (void)(tempMinCelsius -= 273),15;
        
        int tempMaxCelsius = [tempMax intValue];
        (void)(tempMaxCelsius -= 273),15;
        
        
        NSString *tempFinale =  [NSString stringWithFormat:@"%d",tempCelsius];
        
        
        NSDictionary *sys = [json objectForKey:@"sys"];
        
        NSString *country = [sys objectForKey:@"country"];
        
        
        
        
        
        
        NSString *strMaxCelsius = [NSString stringWithFormat:@"%d",tempMaxCelsius];
        NSString *strRangeTemp = [NSString stringWithFormat:@"%d",tempMinCelsius];
        strRangeTemp = [strRangeTemp stringByAppendingString:@"° / "];
        
        strRangeTemp = [strRangeTemp stringByAppendingString:strMaxCelsius];
        
        strRangeTemp = [strRangeTemp stringByAppendingString:@"°"];
        
        
        //    Calcolo l'orario della città selezionata
        
        NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:[timezone doubleValue]];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm a";
        NSString  *finalate = [dateFormatter stringFromDate:myDate];
        
        _timeLabel.text = finalate;

        _cityName = [_cityName stringByAppendingString:@","];
        _cityName = [_cityName stringByAppendingString:country];
        _cityLabel.text = _cityName;
        _conditionsLabel.text = weatherDescription;
        
        tempFinale = [tempFinale stringByAppendingString:@"°"];
        _temperatureLabel.text = tempFinale;
        
        _hiloLabel.text = strRangeTemp;
        
        _iconView.image = [UIImage imageNamed:iconId];

        appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        context = appDelegate.persistentContainer.viewContext;
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Cities" inManagedObjectContext:context]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@ ", _cityName]];
        
        NSError* error = nil;
        NSArray* results = [context executeFetchRequest:fetchRequest error:&error];

        if(results == nil || [results count] == 0) {
            _btnHeart.image = [UIImage imageNamed:@"notFavorite.png"];
            // we need to put this true or false, based on db information
            _preferenceChecked = false;
        }
        else{
            _btnHeart.image = [UIImage imageNamed:@"favorite.png"];
            // we need to put this true or false, based on db information
            _preferenceChecked = true;
            
        }
        
    
    }
}

@end

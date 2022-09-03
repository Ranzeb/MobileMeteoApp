//
//  SecondViewController.m
//  
//
//  Created by Gabriele Ranzieri on 08/09/2019.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>



@interface SecondViewController (){
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    NSArray *dictionaries;
    NSArray *tableData;
    NSArray *devices;
    NSMutableArray *cities;
    CLLocationManager *locationManager;
    
}
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *rangeTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *hiloLabel;
@property (strong, nonatomic) IBOutlet UIView *header;

@end

@implementation SecondViewController{
    double latitude;
    double longitude;
}


-(void)onTapDone:(UIBarButtonItem*)item{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Export List"
                                                                   message:@"Do you want to export you favorite cities?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            NSMutableString *buffer = [NSMutableString string];
            
            for (NSUInteger i = 0; i < self->cities.count; i++) {
                NSString *value = self->cities[i];
                
                if (i > 0) {
                    [buffer appendString:@"\n"];
                    
                }
                
                [buffer appendString:value];
                
            }
            
            NSData *data = [buffer dataUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"preferiti.csv"];
            [data writeToFile:appFile atomically:YES];
            NSString *message = @"Favorite list\n was saved correctly";
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            int duration = 2; // duration in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
                                                              
        }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:defaultAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)onTapCancel:(UIBarButtonItem*)item{
    
}

- (void)loadPreferences{
    // Do any additional setup after loading the view.
    
    
    
//    self.view.backgroundColor = [UIColor redColor];
    
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
    self.tableView.separatorColor = [UIColor colorWithWhite:5 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    //Get Context
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Cities" inManagedObjectContext:context]];
  
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    cities = [NSMutableArray arrayWithObjects:@"str1", nil];
    [cities removeObjectAtIndex:0];
    
    int i =0;
    for (id currentObj in results) {
        
        [cities addObject:[currentObj valueForKey:@"name"]];

        i++;
        [appDelegate saveContext];
        
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [self loadPreferences];
    
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

   
    UIBarButtonItem* exportBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onTapDone:)];
    self.navigationItem.rightBarButtonItem = exportBtn;

    
   self.navigationItem.title = @"Favorite";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
   [self loadPreferences];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self->locationManager requestWhenInUseAuthorization];
    
    
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    
    longitude = location.coordinate.longitude;
    latitude = location.coordinate.latitude;
    
    NSString *stringUrl = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial",latitude,longitude];
    
    stringUrl = [stringUrl stringByAppendingString:@"&APPID=f77df9c25ef4eb5cd3851aec67bffc7c"];
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:stringUrl]];
    
    //MEGLIO USARE NSSession come ho fatto per scaricare!
    
    NSData *theData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:nil
                                                        error:nil];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:theData
                                                         options:0
                                                           error:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 1
#pragma mark - UITableViewDataSource

// 2
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    return cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    
//    Now we need to fetch https request to get data from JSON and populate cell
    
    // Do any additional setup after loading the view.
    cities[indexPath.row] = [cities[indexPath.row] stringByReplacingOccurrencesOfString:@" "
                                         withString:@"+"];
    NSDictionary *json = [self sendHTTPGet: cities[indexPath.row]];
    
    
    _cityName = [json objectForKey:@"name"];
    
    NSString *timezone = [json objectForKey:@"dt"];
    
    NSMutableArray *weather = [json objectForKey:@"weather"];
    
    NSDictionary *idWeather = weather[0];
    
    NSString *iconId = [idWeather objectForKey:@"icon"];
    
    
    
    //    NSString *weatherDescription = [weather objectForKey:@"description"];
    
    NSDictionary *main = [json objectForKey:@"main"];
    
    NSString *temp = [main objectForKey:@"temp"];
    
    int tempCelsius = [temp intValue];
    (void)(tempCelsius -= 273),15;
    
    NSString *tempFinale =  [NSString stringWithFormat:@"%d",tempCelsius];
    
    
    NSDictionary *sys = [json objectForKey:@"sys"];
    
    NSString *country = [sys objectForKey:@"country"];
    
    
    //    Calcolo l'orario della città selezionata
    
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:[timezone doubleValue]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSString  *finalate = [dateFormatter stringFromDate:myDate];
    
    
    
    
    //Grafica
    
    
    
    self.view.backgroundColor = [UIColor redColor];
    
    // 1
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    
    iconId = [iconId stringByAppendingString:@".png"];
  
//    FINISH
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.textLabel.text= [cities[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    
    cell.textLabel.numberOfLines = 1;
    
    _cityName = [_cityName stringByAppendingString:@","];
    _cityName = [_cityName stringByAppendingString:country];
    _cityLabel.text = _cityName;
    
    tempFinale = [tempFinale stringByAppendingString:@"°"];
    
    UIImage *imageIcon = [UIImage imageNamed:iconId] ;
    cell.imageView.image = imageIcon;
    

    cell.textLabel.text = _cityName;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    cell.detailTextLabel.text = tempFinale;
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
   
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Determine cell height based on screen
    return 60;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}




-(NSDictionary *) sendHTTPGet:(NSString*)city {
 
    NSString *stringUrl;

    stringUrl = @"https://api.openweathermap.org/data/2.5/weather?q=";
    
    stringUrl = [stringUrl stringByAppendingString:city];
        
    stringUrl = [stringUrl stringByAppendingString:@"&APPID=f77df9c25ef4eb5cd3851aec67bffc7c"];

    
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


@end

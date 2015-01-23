//
//  DEMOThirdViewController.m
//  RESideMenuStoryboardsExample
//
//  Created by Hill on 2014/9/22.
//  Copyright (c) 2014年 Roman Efimov. All rights reserved.
//

#import "DEMOThirdViewController.h"
#import "MBPointTableViewCell.h"

static CGRect MapOriginalFrame;
static CGFloat offset = -50.0f;

NSArray *fakeTitles1;
NSArray *fakeTitles2;
NSArray *fakeTitles3;
NSArray *fakeTitles4;

@implementation DEMOThirdViewController 
- (IBAction)pushViewController:(id)sender{
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.title = @"Pushed Controller";
    viewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (_currentPageIndex) {
        case 0:
        default:
            return [fakeTitles1 count];
            break;
            
        case 1:
            return [fakeTitles2 count];
            break;
            
        case 2:
            return [fakeTitles3 count];
            break;

    }
    
}

- (CGFloat)horizontalOffset{
    return 50.0f;
}

- (void)didTapHeaderImageView:(UIImageView *)imageView
{
    NSLog(@"The header imageview was tapped: %@", imageView.description);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self setHeaderImage:[UIImage imageNamed:@"meatballs.jpeg"]];
    [self setTitleText:_currentTitle];

    //    [self setSubtitleText:@"subtitle"];
    [self setLabelBackgroundGradientColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    
    
    [self.navigationItem setTitle:_currentTitle];
    

    
    MapOriginalFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
//    CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    self._mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self._mapView = [[MKMapView alloc] initWithFrame:MapOriginalFrame];
    [self.view insertSubview:self._mapView aboveSubview:self.tableView];
    
//    NSLog(@"currentPageIndex : %d", _currentPageIndex);
    
    fakeTitles1 = @[
                    @"FABRICA 椅子咖啡",
                    @"At Home Cafe 咖啡家",
                    @"大稻埕的老宅星巴克",
                    @"drip cafe 好滴咖啡",
                    @"花花，甲飽沒",
                    @"傳奇玫瑰花園廚坊",
                    @"Fika Fika Cafe 北歐風咖啡時光",
                    @"麵屋輝。源自大阪的好味道",
                    @"台北犁記 太陽餅...",
                    @"泰亞美食館 復北一館",
                    @"瞞著爹 (丼三店)",
                    @"哈古小館",
                    @"向餐廳 Hsiang The Brunch",
                    @"紅蜻蜓食事處@永康街",
                    @"四川吳抄手",
                    @"2F Lite 貳拂咖啡",
                    @"御奉Emperor Love ~大餅焗烤千層",
                    @"台北信義區。國父紀念館站...",
                    ];
    
    
    fakeTitles2 = @[
                    @"akuma caca可可設計人文咖啡",
                    @"【古亭】 露西小棧 ...",
                    @"Cafe Bastille 溫州店 ...",
                    @"【台北】有著意外好吃  CHEESE CAKE ...",
                    ];
    
    
    fakeTitles3 = @[
                    @"小器食堂",
                    @"中山捷運站。FAVVI@tube  ...",
                    @"富錦街~小普羅旺斯",
                    @"i.za house【南法鄉村風】",
                    @"【基隆】黑兔兔的散步生活屋",
                    ];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toPointDetail" sender:self];
    
//    PointDetailVC *secondViewController = [[PointDetailVC alloc] init];
//    secondViewController.data = _label.text;
//    secondViewController.delegate = self;
//    [self.navigationController pushViewController:secondViewController animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toPointDetail"]) {

        if([[segue destinationViewController] isKindOfClass:[PointDetailVC class]] ){
            
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MBPointCell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    MBPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"MBPointCellView" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MBPointCell"];
    }
    
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
            cell.textLabel.textColor = [UIColor blackColor];

    
    
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
//        cell.selectedBackgroundView = [[UIView alloc] init];
//    }
    
//    NSArray *fakeTitles1 = @[@"大稻埕的老宅星巴克",
//                             @"花花，甲飽沒",
//                             @"Fika Fika Cafe 北歐風咖啡時光",
//                             @"麵屋輝。源自大阪的好味道",
////                             @"",
//
//                             ];
    
    
//    /cell.textLabel.text = fakeTitles[indexPath.row];
    
    
    
    NSArray *fakeTitles;
    
    switch (_currentPageIndex) {
        case 0:
        default:
            fakeTitles = fakeTitles1;
            break;
            
        case 1:
            fakeTitles = fakeTitles2;
            break;
        case 2:
            fakeTitles = fakeTitles3;
            break;
            
    }
    
    NSMutableArray *images = [NSMutableArray array];
    for (NSUInteger i = 0; i < [fakeTitles count]; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@", [fakeTitles objectAtIndex:i]];
        [images addObject:imageName];
    }
    cell.textLabel.text = images[indexPath.row];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imgURL = @"http://blogs-images.forbes.com/antonyleather/files/2014/09/iphone-6-camera.jpg";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
        //set your image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.cellImage setImage:[UIImage imageWithData:data]];
        });    
    });
    
    return cell;
}


@end

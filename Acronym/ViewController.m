//
//  ViewController.m
//  Acronym
//
//  Created by Raidu on 09/12/15.
//  Copyright (c) 2015 Raidu. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"

@interface ViewController () {
    
    NSMutableArray *meaningsArray;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *acronymsTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Acronyms";
    
    meaningsArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SearchButtonAction:(id)sender {
    
    [self searchForAcronyms:self.textField.text];

}

- (void)searchForAcronyms: (NSString*)enteredText {
    
    [meaningsArray removeAllObjects];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";

    NetworkManager *manager = [NetworkManager sharedManager];
    [manager searchForAcronymsOnServer:enteredText completionBlock:^(NSArray *response) {
        
        [self handleData:response];
        [hud hide:YES];

    }];
}


#pragma mark Data handling Method

- (void)handleData:(NSArray*)info {
    
    for (int i=0 ; i < [info count]; i++) {
        
        NSDictionary *dict = [info objectAtIndex:i];
        NSArray *array = [dict objectForKey:@"lfs"];
        
        for (int i=0; i < [array count]; i++) {
            
            NSDictionary *dict = [array objectAtIndex:i];
            NSString *lfValue = [dict objectForKey:@"lf"];
            
            [meaningsArray addObject:lfValue];
        }
    }
    
    NSLog(@"%@",meaningsArray);
    [self.acronymsTableView reloadData];
}


#pragma mark TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [meaningsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = [meaningsArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


@end

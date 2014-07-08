//
//  ButtonVC.m
//  Day06
//
//  Created by techmaster on 6/27/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

#import "ButtonVC.h"

@interface ButtonVC ()
@property (weak, nonatomic) IBOutlet UIButton *anotherButton;
@property (weak, nonatomic) UIButton* button;
@end

@implementation ButtonVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Thêm động hàm hứng sự kiện khi người dùng tap vào nút
    [self.anotherButton addTarget:self
                      action:@selector(onAnotherButtonTap:)
            forControlEvents:UIControlEventTouchUpInside];
   /* [self.anotherButton setImage:[UIImage imageNamed:@"okButton"]
                        forState:UIControlStateNormal];*/
    
    [self createButton];
}
- (IBAction)onSimpleButtonTap:(id)sender {
    NSLog(@"Simple button is tapped!");
}

- (void) onAnotherButtonTap: (UIButton*) sender {
    NSLog(@"Another button is tapped!");
    NSLog(@"I can access to self.button at here %@", self.button);
}

- (void) createButton
{
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:@"Dynamic Button" forState:UIControlStateNormal];
    [self.button setTitle:@"Super Button" forState:UIControlStateHighlighted];
    self.button.frame = CGRectMake(20, 240, 280, 40);
    self.button.backgroundColor = [UIColor redColor];
  //  button.layer.borderColor = [UIColor blackColor].CGColor;
   // button.layer.borderWidth = 0.5f;
    self.button.layer.cornerRadius = 10.0f;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.button];
}
@end

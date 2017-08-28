//
//  HGTasksOfThreeVC.h
//  Hui10Game
//
//  Created by LY on 16/12/26.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "BaseViewController.h"

@interface HGTasksOfThreeVC : BaseViewController

@property(nonatomic)NSMutableArray *dataArrL;
@property(nonatomic)NSMutableArray *dataArrM;
@property(nonatomic)NSMutableArray *dataArrR;

//21  22 23
@property (weak, nonatomic) IBOutlet UITableView *leftView;
@property (weak, nonatomic) IBOutlet UITableView *middleView;
@property (weak, nonatomic) IBOutlet UITableView *rightView;




@end

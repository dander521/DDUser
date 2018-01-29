//
//  DTNtificationCenter.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTNtificationCenter.h"

@implementation DTNtificationCenter

/** 注册成功 */
NSString * const kNotificationRegisterSuccess = @"kNotificationRegisterSuccess";
/** 登录成功 */
NSString * const kNotificationLoginSuccess = @"kNotificationLoginSuccess";
/** 退出登录成功 */
NSString * const kNotificationLoginOutSuccess = @"kNotificationLoginOutSuccess";
/** 购买物品变化 */
NSString * const kNotificationGoodsDataChange = @"kNotificationGoodsDataChange";

#pragma mark - AliPay

/** 支付宝付款成功 */
NSString *  const kNSNotificationAliPaySuccess = @"kNSNotificationAliPaySuccess";
/** 微信付款成功 */
NSString *  const kNSNotificationWXPaySuccess = @"kNSNotificationWXPaySuccess";
/** 微信付款成功 */
NSString *  const kNSNotificationWXPayFail = @"kNSNotificationWXPayFail";
/** 提现成功 */
NSString *  const kNSNotificationWithdrawSuccess = @"kNSNotificationWithdrawSuccess";
/** 申诉成功 */
NSString *  const kNSNotificationAppealSuccess = @"kNSNotificationAppealSuccess";

/** 订单支付成功 */
NSString *  const kNSNotificationOrderPaySuccess = @"kNSNotificationOrderPaySuccess";

/** 订单使用成功 */
NSString *  const kNSNotificationOrderUseSuccess = @"kNSNotificationOrderUseSuccess";

/** 订单评价成功 */
NSString *  const kNSNotificationOrderCommentSuccess = @"kNSNotificationOrderCommentSuccess";
@end

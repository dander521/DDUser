//
//  DTNtificationCenter.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/30.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTNtificationCenter : NSObject

/** 注册成功 */
extern NSString * const kNotificationRegisterSuccess;
/** 登录成功 */
extern NSString * const kNotificationLoginSuccess;
/** 退出登录成功 */
extern NSString * const kNotificationLoginOutSuccess;
/** 购买物品变化 */
extern NSString * const kNotificationGoodsDataChange;

#pragma mark - AliPay

/** 支付宝付款成功 */
extern NSString *  const kNSNotificationAliPaySuccess;

/** 微信付款成功 */
extern NSString *  const kNSNotificationWXPaySuccess;

/** 微信付款失败 */
extern NSString *  const kNSNotificationWXPayFail;

/** 提现成功 */
extern NSString *  const kNSNotificationWithdrawSuccess;

/** 申诉成功 */
extern NSString *  const kNSNotificationAppealSuccess;

/** 订单支付成功 */
extern NSString *  const kNSNotificationOrderPaySuccess;

/** 订单使用成功 */
extern NSString *  const kNSNotificationOrderUseSuccess;

/** 订单评价成功 */
extern NSString *  const kNSNotificationOrderCommentSuccess;

@end

//
//  RCHttpApiConst.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/24.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCHttpApiConst : NSObject

/** http host */
extern NSString * const httpHost;
extern NSString * const imageHost;

/** register */
extern NSString * const registerInterface;
/** login */
extern NSString * const loginInterface;
/** retrieve */
extern NSString * const retrieveInterface;
/** bindAli */
extern NSString * const bindAplipay;
extern NSString * const unBindAplipay;
/** balance */
extern NSString * const getBalance;
/** personalInfo */
extern NSString * const personalInfo;


/** setPersonalInfo */
extern NSString * const setPersonalInfo;
/** first category info */
extern NSString * const firstCategory;
/** second category info */
extern NSString * const secondCategory;
/** get pincode */
extern NSString * const pincodeMsg;
/** withdraw info */
extern NSString * const withdrawInfo;


/** apply withdraw */
extern NSString * const withdrawApply;
/** appeal order upload pic */
extern NSString * const orderCommentPicUp;
/** advertisement company */
extern NSString * const advertisementCompany;
/** feed back */
extern NSString * const feedback;
extern NSString * const commentReply;
/** about us */
extern NSString * const aboutUs;


/** upload more than one pic */
extern NSString * const multiPicUpload;
/** merchantList */
extern NSString * const merchantList;
/** merchantDetail */
extern NSString * const merchantDetail;
/** goodsList */
extern NSString * const goodsList;
/** merchantDetail */
extern NSString * const goodsDetail;

/** commitOrder */
extern NSString * const commitOrder;
/** orderInfo */
extern NSString * const orderInfo;
/** orderRefund */
extern NSString * const orderRefund;
/** orderComment */
extern NSString * const orderComment;
/** orderComplaint */
extern NSString * const orderComplaint;

/** cancel complaint */
extern NSString * const orderCancelComplaint;
/** save shop */
extern NSString * const saveShop;
/** my save info */
extern NSString * const mySaveInfo;
/** goods comment info */
extern NSString * const goodsCommentInfo;
/** balance detail */
extern NSString * const balanceDetail;
/** banner info */
extern NSString * const bannerInfo;
/** pay order */
extern NSString * const payOrder;
/** order comment detail */
extern NSString * const orderCommentDetail;

/** order pay code */
extern NSString * const orderPayCode;
/** get red packet */
extern NSString * const getRedPacket;

/** messageList */
extern NSString * const messageList;

/** get order status */
extern NSString * const getOrderStatus;
/** get paper */
extern NSString * const getPaper;
/** pay to merchant */
extern NSString * const payToMerchant;
/** search merchant */
extern NSString * const searchMerchant;

extern NSString * const contactUs;
extern NSString * const shareContent;

extern NSString * const cancelOrder;

@end

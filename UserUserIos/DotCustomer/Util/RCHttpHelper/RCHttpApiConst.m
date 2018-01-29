//
//  RCHttpApiConst.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/24.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "RCHttpApiConst.h"

@implementation RCHttpApiConst

/** http host */
NSString * const httpHost = @"http://www.diandiancangku.com/ddckback";
NSString * const imageHost = @"http://www.diandiancangku.com/img";

/** register */
NSString * const registerInterface = @"user/registerUser";
/** login */
NSString * const loginInterface = @"user/loginUser";
/** retrieve */
NSString * const retrieveInterface = @"user/forgetPwd";
/** bindAli */
NSString * const bindAplipay = @"user/bindZFB";

NSString * const unBindAplipay = @"user/unBindZFB";
/** balance */
NSString * const getBalance = @"user/balanceInfo";
/** personalInfo */
NSString * const personalInfo = @"user/personal";
/** setPersonalInfo */
NSString * const setPersonalInfo = @"user/personalSave";
/** first category info */
NSString * const firstCategory = @"common/firstType";
/** second category info */
NSString * const secondCategory = @"common/twoType";
/** get pincode */
NSString * const pincodeMsg = @"common/sendSms";


/** withdraw info */
NSString * const withdrawInfo = @"withdrawals/info";
/** apply withdraw */
NSString * const withdrawApply = @"withdrawals/apply";
/** appeal order upload pic */
NSString * const orderCommentPicUp = @"common/upload";
/** advertisement company */
NSString * const advertisementCompany = @"common/notice";
/** feed back */
NSString * const feedback = @"common/opinion";
NSString * const commentReply = @"comment/reply";

/** about us */
NSString * const aboutUs = @"common/aboutUs";
/** upload more than one pic */
NSString * const multiPicUpload = @"common/uploads";
/** merchantList */
NSString * const merchantList = @"shop/searchNearShops";
/** merchantDetail */
NSString * const merchantDetail = @"shop/shopDetail";
/** goodsList */
NSString * const goodsList = @"product/getProduct";
/** merchantDetail */
NSString * const goodsDetail = @"product/productDetail";


/** commitOrder */
NSString * const commitOrder = @"order/apply";
/** orderInfo */
NSString * const orderInfo = @"order/user/list";
/** orderRefund */
NSString * const orderRefund = @"order/refundApply";
/** orderComment */
NSString * const orderComment = @"comment/add";
/** orderComplaint */
NSString * const orderComplaint = @"order/user/complaint";

/** cancel complaint */
NSString * const orderCancelComplaint = @"order/cancelComplaint";
/** save shop */
NSString * const saveShop = @"shop/changeCollection";
/** my save info */
NSString * const mySaveInfo = @"shop/collection";
/** goods comment info */
NSString * const goodsCommentInfo = @"comment/user/list";
/** balance detail */
NSString * const balanceDetail = @"user/balanceDetail";
/** banner info */
NSString * const bannerInfo = @"common/banners";
/** pay order */
NSString * const payOrder = @"order/orderPay";
/** order comment detail */
NSString * const orderCommentDetail = @"comment/details";

/** order pay code */
NSString * const orderPayCode = @"order/getCode";
/** get red packet */
NSString * const getRedPacket = @"order/receivePacket";

/** messageList */
NSString * const messageList = @"message/list";

/** get order status */
NSString * const getOrderStatus = @"order/getOrderStatus";
/** get paper */
NSString * const getPaper = @"paper/receive";
/** pay to merchant */
NSString * const payToMerchant = @"pay/payToSaler";
/** search merchant */
NSString * const searchMerchant = @"product/searchProducts";

NSString * const contactUs = @"common/contactUs";
NSString * const shareContent = @"common/share";

NSString * const cancelOrder = @"order/cancelOrder";

@end

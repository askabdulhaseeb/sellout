import '../../../../../core/enums/core/status_type.dart';
import '../../../auth/signin/data/models/address_model.dart';
import '../../domain/entities/order_entity.dart';
import 'order_payment_detail_model.dart';
import 'shipping_detail_model.dart';


class OrderModel extends OrderEntity {
  OrderModel({
    required super.orderId,
    required super.buyerId,
    required super.sellerId,
    required super.postId,
    required super.orderStatus,
    required super.orderType,
    required super.price,
    required super.totalAmount,
    required super.quantity,
    required super.createdAt,
    required super.updatedAt,
    required super.businessId,
    required super.paymentDetail,
    required super.shippingAddress,
    super.size,
    super.color,
    super.listId,
    super.isBusinessOrder,
    super.transactionId,
    super.trackId,
    super.deliveryPaidBy,
    super.shippingDetails,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Parse shipping_detail first to extract shipping address if not at top level
    final Map<String, dynamic>? shippingDetailJson =
        json['shipping_detail'] as Map<String, dynamic>?;
    final ShippingDetailModel? shippingDetail = shippingDetailJson != null
        ? ShippingDetailModel.fromJson(shippingDetailJson)
        : null;

    // Try to get shipping address from top level, otherwise from shipping_detail.addresses.to_address
    AddressModel shippingAddress;
    if (json['shipping_address'] != null) {
      shippingAddress =
          AddressModel.fromJson(json['shipping_address'] as Map<String, dynamic>);
    } else if (shippingDetailJson != null &&
        shippingDetailJson['addresses'] != null) {
      final Map<String, dynamic> addresses =
          shippingDetailJson['addresses'] as Map<String, dynamic>;
      if (addresses['to_address'] != null) {
        shippingAddress =
            AddressModel.fromJson(addresses['to_address'] as Map<String, dynamic>);
      } else {
        shippingAddress = AddressModel.fromJson(<String, dynamic>{});
      }
    } else {
      shippingAddress = AddressModel.fromJson(<String, dynamic>{});
    }

    return OrderModel(
      orderId: json['order_id'] as String? ?? '',
      buyerId: json['buyer_id'] as String? ?? '',
      sellerId: json['seller_id'] as String? ?? '',
      postId: json['post_id'] as String? ?? '',
      orderStatus: StatusType.fromJson(json['order_status'] as String? ?? 'pending'),
      orderType: json['order_type'] as String? ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      totalAmount: (json['total_amount'] is num)
          ? (json['total_amount'] as num).toDouble()
          : 0.0,
      quantity: json['quantity'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      paymentDetail: OrderPaymentDetailModel.fromJson(
        json['payment_detail'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      shippingAddress: shippingAddress,
      businessId: json['business_id'] as String? ?? '',
      size: json['size'] as String?,
      color: json['color'] as String?,
      listId: json['list_id'] as String?,
      isBusinessOrder: json['is_business_order'] as bool?,
      transactionId: json['transaction_id'] as String?,
      trackId: json['track_id'] as String?,
      deliveryPaidBy: json['delivery_paid_by'] as String?,
      shippingDetails: shippingDetail,
    );
  }

  factory OrderModel.fromEntity(OrderEntity e) {
    return OrderModel(
      orderId: e.orderId,
      buyerId: e.buyerId,
      sellerId: e.sellerId,
      postId: e.postId,
      orderStatus: e.orderStatus,
      orderType: e.orderType,
      price: e.price,
      totalAmount: e.totalAmount,
      quantity: e.quantity,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      paymentDetail: OrderPaymentDetailModel.fromEntity(e.paymentDetail),
      shippingAddress: AddressModel.fromEntity(e.shippingAddress),
      businessId: e.businessId,
      size: e.size,
      color: e.color,
      listId: e.listId,
      isBusinessOrder: e.isBusinessOrder,
      transactionId: e.transactionId,
      trackId: e.trackId,
      deliveryPaidBy: e.deliveryPaidBy,
      shippingDetails: e.shippingDetails != null
          ? ShippingDetailModel.fromEntity(e.shippingDetails!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'order_id': orderId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'post_id': postId,
      'order_status': orderStatus.json,
      'order_type': orderType,
      'price': price,
      'total_amount': totalAmount,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'payment_detail': (paymentDetail as OrderPaymentDetailModel).toJson(),
      'shipping_address': (shippingAddress as AddressModel).toJson(),
      'business_id': businessId,
      'size': size,
      'color': color,
      'list_id': listId,
      'is_business_order': isBusinessOrder,
      'transaction_id': transactionId,
      'track_id': trackId,
      'delivery_paid_by': deliveryPaidBy,
      'shipping_detail': shippingDetails != null
          ? (shippingDetails as ShippingDetailModel).toJson()
          : null,
    };
  }
}

//payload example
// {"orders":[{"quantity":1,"last_update_meta":{"actor":{"user_id":"de528e11-0d96-49fe-b890-3c0b1809fcf9-U","business_id":null,"role":null},"tracking_number":null,"source":"api","at":"2025-12-11T14:45:41.614Z","object_id":null,"last_event":null},
//"size":"3","list_id":"clothes-foot","created_at":"2025-12-11T12:55:56.333Z","buyer_id":"d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U","is_business_order":false,"transaction_id":"1a494837-4135-48c9-8124-27387452f2ba","track_id":"6d3dbd7c-e5f5-4ac0-bce6-13d2dfcc780c",
//"payment_detail":{"original_price":500,"quantity":1,"method":"stripe","transaction_charge_currency":"GBP","transaction_charge_per_item":16.32,"payment_indent_id":"pi_3Sd9PBIeMnUz3LGX23ekBVAD","converted_delivery_price":0,"core_delivery_price":0,"converted_price":500,"net_charge_per_item":483.68,
//"buyer_currency":"GBP","seller_id":"de528e11-0d96-49fe-b890-3c0b1809fcf9-U","post_currency":"GBP","status":"completed","timestamp":"2025-12-11T12:55:56.259Z"},"updated_at":"2025-12-11T20:21:26.648Z",
//"delivery_paid_by":"seller","seller_id":"de528e11-0d96-49fe-b890-3c0b1809fcf9-U","post_id":"328264f1-8a2a-403d-8ccf-21ea666115be-PL","order_type":"general",
//"shipping_detail":{"postage":[{"parcel":{"length":"24","width":"16.5","distanceUnit":"cm","weight":"2.00","massUnit":"kg","height":"0.5"},"provider":"sendcloud","converted_buffer_amount":0,"service_name":"DHL Parcel Dropoff - Next Day","rate_object_id":"7093","native_currency":"GBP","converted_currency":"GBP","native_buffer_amount":0,"core_amount":0,"shipment_id":null,"service_token":"dhl_parcel_dropoff_-_next_day_0-5kg"}],
//"fast_delivery":{"available":false,"message":null,"requested":false},
//"addresses":{"from_address":{"country":"united kingdom","city":"London","address_1":"nawab colony","phone_number":"+443086136025","state":"England","postal_code":"SW1A 2AA","recipient_name":"ahmer"},
//"to_address":{"country":"United Kingdom","city":"London","address_1":"Nawab colony mina channu","address_category":"home","phone_number":"+44 23456754321","state":"England","recipient_name":"ahmer","postal_code":"SW1A 2AA","is_default":true}}},
//"order_id":"Test-ORD-06c3b0d8-adb3-42a1-97f1-ea4759f05431","price":500,"color":"#FF69B4","total_amount":500,"order_status":"processing"}]}

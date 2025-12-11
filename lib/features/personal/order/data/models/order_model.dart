import '../../../../../core/enums/core/status_type.dart';
import '../../../auth/signin/data/models/address_model.dart';
import '../../domain/entities/order_entity.dart';
import 'order_payment_detail_model.dart';
import '../../domain/entities/order_entity.dart' as entity;

class ShippingDetailModel {
  ShippingDetailModel({
    required this.postage,
    this.fastDelivery,
    this.fromAddress,
    this.toAddress,
  });

  factory ShippingDetailModel.fromJson(Map<String, dynamic> json) {
    return ShippingDetailModel(
      postage:
          (json['postage'] as List?)
              ?.map((e) => PostageModel.fromJson(e))
              .toList() ??
          [],
      fastDelivery: json['fast_delivery'] != null
          ? FastDeliveryModel.fromJson(json['fast_delivery'])
          : null,
      fromAddress: json['addresses']?['from_address'] != null
          ? AddressModel.fromJson(json['addresses']['from_address'])
          : null,
      toAddress: json['addresses']?['to_address'] != null
          ? AddressModel.fromJson(json['addresses']['to_address'])
          : null,
    );
  }

  factory ShippingDetailModel.fromEntity(entity.ShippingDetailEntity e) {
    return ShippingDetailModel(
      postage: e.postage.map((p) => PostageModel.fromEntity(p)).toList(),
      fastDelivery: e.fastDelivery != null
          ? FastDeliveryModel.fromEntity(e.fastDelivery!)
          : null,
      fromAddress: e.fromAddress != null
          ? AddressModel.fromEntity(e.fromAddress!)
          : null,
      toAddress: e.toAddress != null
          ? AddressModel.fromEntity(e.toAddress!)
          : null,
    );
  }
  final List<PostageModel> postage;
  final FastDeliveryModel? fastDelivery;
  final AddressModel? fromAddress;
  final AddressModel? toAddress;

  entity.ShippingDetailEntity toEntity() {
    return entity.ShippingDetailEntity(
      postage: postage.map((p) => p.toEntity()).toList(),
      fastDelivery: fastDelivery?.toEntity(),
      fromAddress: fromAddress,
      toAddress: toAddress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postage': postage.map((e) => e.toJson()).toList(),
      'fast_delivery': fastDelivery?.toJson(),
      'addresses': {
        'from_address': fromAddress?.toShippingJson(),
        'to_address': toAddress?.toShippingJson(),
      },
    };
  }
}

class PostageModel {
  PostageModel({
    this.parcel,
    this.provider,
    this.convertedBufferAmount,
    this.serviceName,
    this.rateObjectId,
    this.nativeCurrency,
    this.convertedCurrency,
    this.nativeBufferAmount,
    this.coreAmount,
    this.shipmentId,
    this.serviceToken,
  });

  factory PostageModel.fromJson(Map<String, dynamic> json) {
    return PostageModel(
      parcel: json['parcel'],
      provider: json['provider'],
      convertedBufferAmount: json['converted_buffer_amount'],
      serviceName: json['service_name'],
      rateObjectId: json['rate_object_id'],
      nativeCurrency: json['native_currency'],
      convertedCurrency: json['converted_currency'],
      nativeBufferAmount: json['native_buffer_amount'],
      coreAmount: json['core_amount'],
      shipmentId: json['shipment_id'],
      serviceToken: json['service_token'],
    );
  }

  factory PostageModel.fromEntity(entity.PostageEntity e) {
    return PostageModel(
      parcel: e.parcel,
      provider: e.provider,
      convertedBufferAmount: e.convertedBufferAmount,
      serviceName: e.serviceName,
      rateObjectId: e.rateObjectId,
      nativeCurrency: e.nativeCurrency,
      convertedCurrency: e.convertedCurrency,
      nativeBufferAmount: e.nativeBufferAmount,
      coreAmount: e.coreAmount,
      shipmentId: e.shipmentId,
      serviceToken: e.serviceToken,
    );
  }
  final Map<String, dynamic>? parcel;
  final String? provider;
  final num? convertedBufferAmount;
  final String? serviceName;
  final String? rateObjectId;
  final String? nativeCurrency;
  final String? convertedCurrency;
  final num? nativeBufferAmount;
  final num? coreAmount;
  final String? shipmentId;
  final String? serviceToken;

  entity.PostageEntity toEntity() {
    return entity.PostageEntity(
      parcel: parcel,
      provider: provider,
      convertedBufferAmount: convertedBufferAmount,
      serviceName: serviceName,
      rateObjectId: rateObjectId,
      nativeCurrency: nativeCurrency,
      convertedCurrency: convertedCurrency,
      nativeBufferAmount: nativeBufferAmount,
      coreAmount: coreAmount,
      shipmentId: shipmentId,
      serviceToken: serviceToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parcel': parcel,
      'provider': provider,
      'converted_buffer_amount': convertedBufferAmount,
      'service_name': serviceName,
      'rate_object_id': rateObjectId,
      'native_currency': nativeCurrency,
      'converted_currency': convertedCurrency,
      'native_buffer_amount': nativeBufferAmount,
      'core_amount': coreAmount,
      'shipment_id': shipmentId,
      'service_token': serviceToken,
    };
  }
}

class FastDeliveryModel {
  FastDeliveryModel({this.available, this.message, this.requested});

  factory FastDeliveryModel.fromJson(Map<String, dynamic> json) {
    return FastDeliveryModel(
      available: json['available'],
      message: json['message'],
      requested: json['requested'],
    );
  }

  factory FastDeliveryModel.fromEntity(entity.FastDeliveryEntity e) {
    return FastDeliveryModel(
      available: e.available,
      message: e.message,
      requested: e.requested,
    );
  }
  final bool? available;
  final String? message;
  final bool? requested;

  entity.FastDeliveryEntity toEntity() {
    return entity.FastDeliveryEntity(
      available: available,
      message: message,
      requested: requested,
    );
  }

  Map<String, dynamic> toJson() {
    return {'available': available, 'message': message, 'requested': requested};
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
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
    required super.paymentDetail,
    required super.shippingAddress,
    required super.businessId,
    this.shippingDetailModel,
    super.size,
    super.color,
    super.listId,
    super.isBusinessOrder,
    super.transactionId,
    super.trackId,
    super.deliveryPaidBy,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final shippingDetailJson = json['shipping_detail'] as Map<String, dynamic>?;
    return OrderModel(
      orderId: json['order_id'] ?? '',
      buyerId: json['buyer_id'] ?? '',
      sellerId: json['seller_id'] ?? '',
      postId: json['post_id'] ?? '',
      orderStatus: StatusType.fromJson(json['order_status'] ?? 'pending'),
      orderType: json['order_type'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      totalAmount: (json['total_amount'] is num)
          ? (json['total_amount'] as num).toDouble()
          : 0.0,
      quantity: json['quantity'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
      paymentDetail: OrderPaymentDetailModel.fromJson(
        json['payment_detail'] ?? <String, dynamic>{},
      ),
      shippingAddress: AddressModel.fromJson(
        json['shipping_detail']?['addresses']?['to_address'] ??
            <String, dynamic>{},
      ),
      businessId: json['business_id'] ?? '',
      size: json['size'],
      color: json['color'],
      listId: json['list_id'],
      isBusinessOrder: json['is_business_order'],
      transactionId: json['transaction_id'],
      trackId: json['track_id'],
      deliveryPaidBy: json['delivery_paid_by'],
      shippingDetailModel: shippingDetailJson != null
          ? ShippingDetailModel.fromJson(shippingDetailJson)
          : null,
    );
  }

  factory OrderModel.fromEntity(entity.OrderEntity e) {
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
      shippingDetailModel: e.shippingDetails != null
          ? ShippingDetailModel.fromEntity(e.shippingDetails!)
          : null,
    );
  }
  final ShippingDetailModel? shippingDetailModel;
  entity.ShippingDetailEntity? get shippingDetail =>
      shippingDetailModel?.toEntity();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'order_id': orderId,
      'business_id': businessId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'post_id': postId,
      'order_status': orderStatus.json,
      'order_type': orderType,
      'price': price,
      'total_amount': totalAmount,
      'quantity': quantity,
      'payment_detail': OrderPaymentDetailModel.fromEntity(
        paymentDetail,
      ).toJson(),
      'shipping_detail':
          shippingDetailModel?.toJson() ??
          <String, dynamic>{
            'addresses': <String, Map<String, dynamic>>{
              'to_address': AddressModel.fromEntity(
                shippingAddress,
              ).toShippingJson(),
            },
          },
      'size': size,
      'color': color,
      'list_id': listId,
      'is_business_order': isBusinessOrder,
      'transaction_id': transactionId,
      'track_id': trackId,
      'delivery_paid_by': deliveryPaidBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

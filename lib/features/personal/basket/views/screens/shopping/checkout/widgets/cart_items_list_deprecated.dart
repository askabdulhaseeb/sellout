// Deprecated: This file is kept for backward compatibility only.
// All cart functionality has been moved to the cart/ folder with clean structure.
//
// New folder structure:
// checkout/widgets/cart/
// ├── models/
// │   └── seller_group.dart         (Data model for seller groups)
// ├── components/
// │   ├── cart_delivery_pickup_toggle.dart   (Toggle widget)
// │   ├── cart_seller_header.dart            (Seller info header)
// │   └── cart_item_tile.dart                (Individual item tile)
// ├── cart_list.dart                (Main CartItemsList widget)
// └── index.dart                     (Barrel exports)

export 'cart/index.dart';

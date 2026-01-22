# Cart Feature Structure

This folder contains the clean, organized implementation of the shopping cart feature.

## Folder Structure

```
checkout/widgets/cart/
├── models/
│   └── seller_group.dart              # Data model representing a seller and their items
├── components/
│   ├── cart_delivery_pickup_toggle.dart    # Toggle widget for delivery/pickup options
│   ├── cart_seller_header.dart             # Seller header with info and toggle
│   └── cart_item_tile.dart                 # Individual cart item display
├── cart_list.dart                      # Main CartItemsList widget (entry point)
├── index.dart                          # Barrel file for clean exports
└── README.md                           # This file
```

## Files Explanation

### Models
- **seller_group.dart**: Contains `SellerGroup` class that groups cart items by seller

### Components
- **cart_delivery_pickup_toggle.dart**: `CartDeliveryPickupToggle` - Allows selection between delivery and pickup
- **cart_seller_header.dart**: `CartSellerHeader` - Displays seller info, item count, and delivery/pickup toggle
- **cart_item_tile.dart**: `CartItemTile` - Shows individual cart item with product image, title, price, and toggle

### Main Widget
- **cart_list.dart**: `CartItemsList` - Main stateful widget that groups items by seller and renders the full cart

## Usage

### Import all exports
```dart
import 'cart/index.dart';

// Now you can use:
// - CartItemsList
// - CartDeliveryPickupToggle
// - CartSellerHeader
// - CartItemTile
// - SellerGroup
```

### Or import specific components
```dart
import 'cart/cart_list.dart';
import 'cart/components/cart_delivery_pickup_toggle.dart';
```

## Deprecated Files

- `cart_items_list.dart` in the parent `widgets/` folder is deprecated
- All old code has been reorganized into the `cart/` subfolder
- The old `delivery_pickup_toggle.dart` file is superseded by `cart/components/cart_delivery_pickup_toggle.dart`

## Component Responsibilities

### CartItemsList
- Fetches and groups cart items by seller
- Displays empty state
- Renders seller groups with headers and item lists

### CartSellerHeader
- Shows seller's profile picture and name
- Displays item count
- Contains CartDeliveryPickupToggle for seller-level delivery/pickup selection

### CartItemTile
- Loads and displays product details
- Shows loading skeleton while fetching data
- Renders product image, title, and price
- Contains CartDeliveryPickupToggle for item-level delivery/pickup selection

### CartDeliveryPickupToggle
- Stateful widget with delivery/pickup toggle buttons
- Shows loading state during selection
- Colors only text and icons, not button background
- Uses theme colors for consistency

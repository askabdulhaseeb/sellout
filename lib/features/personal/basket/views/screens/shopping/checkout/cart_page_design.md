# Cart Page UI & Logic Design

## Overview
This document describes the design, data model, and logic for the cart/checkout page, replicating the attached reference image. It supports flexible postage and pickup selection at both the seller and product level.

---

## 1. Page Structure
- **Header Section**
  - "Post to" box at the top, showing the selected delivery address with an icon and dropdown arrow.
- **Your Items Section**
  - Title: "Your Items"
  - Subtitle: "Toggle pickup for each seller if needed" (right-aligned)
- **Seller Groups**
  - Each seller is shown in a card with:
    - Seller name (e.g., “Zubair Hussain”)
    - Item count (e.g., “3 items”)
    - Status (e.g., “(mixed)” if both delivery and pickup are present)
    - “All items:” label (right-aligned)
    - Delivery/Pickup toggle for the whole group
    - If pickup is selected for the group, a yellow warning bar: “Select pickup location for all items”
  - **Product List**
    - Each product is shown in a card with:
      - Product image (left)
      - Product name and price (center)
      - Delivery and pickup icons (right), with the selected one highlighted
      - If pickup is selected and no pickup point is set, a yellow warning bar: “Select pickup point”
    - Card background is highlighted (light green/yellow) if pickup is selected
  - **Seller Group Footer**
    - If any product in the group is missing a pickup point, a warning at the bottom: “Please select a pickup location for all items using pickup.”

---

## 2. User Interactions
- **Toggle Delivery/Pickup**
  - At the seller group level, toggles all products in the group.
  - At the product level, user can override the group setting for individual products.
- **Select Pickup Point**
  - If pickup is selected (group or product), user must select a pickup location.
  - If not set, show a warning and highlight the card.
- **Visual Feedback**
  - Use color highlights for selected pickup/delivery.
  - Show warning bars for missing pickup points.

---

## 3. Data Model Example
```dart
class CartPageData {
  final String deliveryAddress;
  final List<SellerGroup> sellerGroups;
}

class SellerGroup {
  final String sellerName;
  final int itemCount;
  final String status; // e.g., "mixed"
  final bool isPickupSelectedForAll;
  final List<ProductItem> products;
  final bool allPickupPointsSelected;
}

class ProductItem {
  final String imageUrl;
  final String name;
  final double price;
  final bool isPickupSelected;
  final bool hasPickupPoint;
  final String? pickupPointName;
}
```

---

## 4. UI Component Tree
- CartPage
  - PostToSection (address, icon, dropdown)
  - ItemsHeader (title, subtitle)
  - For each SellerGroup:
    - SellerGroupCard
      - SellerHeader (name, item count, status, toggle)
      - If pickup: GroupPickupWarningBar
      - For each ProductItem:
        - ProductCard
          - Image, name, price
          - Delivery/Pickup icons (toggleable)
          - If pickup and no point: PickupWarningBar
      - If any missing pickup: GroupFooterWarning

---

## 5. Design Notes
- Use consistent padding and card elevation.
- Use theme colors for highlights and warnings.
- All text should be localized.
- Icons should be clear and accessible.
- Responsive layout for different screen sizes.

---

## 6. Example UI Logic
- When toggling pickup for a seller, set all products to pickup.
- When toggling delivery/pickup for a product, override the group setting.
- If pickup is selected and no pickup point, show warning.
- If all products in a group are pickup and have points, hide group warning.

---

## 7. Next Steps
- Implement the widget tree as described.
- Connect the UI to the data model and business logic.
- Integrate the /cart/service-points API for pickup point selection.
- Test all user flows and edge cases.

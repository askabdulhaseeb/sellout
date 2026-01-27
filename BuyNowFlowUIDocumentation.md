
# Buy Now Flow UI Documentation
## Full Flow Design & Working

### Overview

The “Buy Now” flow is a 4-step modal process for purchasing an item, designed for mobile. It uses a stepper UI, clear sectioning, and actionable buttons. The flow is:

1. **Delivery Method Selection**
2. **Pickup Location Selection**
3. **Shipping Option Selection**
4. **Order Summary & Payment**

Each step is visually distinct, with a progress indicator and navigation controls.

---

### Step 1: Delivery Method Selection

- **UI:**  
  - Product card at the top (image, name, price).
  - Section: “How would you like to receive your order?”
  - Two options:  
    - Home Delivery (to address)  
    - Pickup Point (from a nearby location)
  - Each option is a card with icon, title, subtitle, and radio button.
  - **Buttons:** Cancel (left), Continue (right).

- **Working:**  
  - User selects one delivery method.
  - “Continue” is enabled only after selection.
  - “Cancel” closes the modal.

---


### Step 2: Pickup Location Selection (if Pickup Point chosen)

- **UI:**  
  - Section: “Find pickup locations”
  - Search radius pill buttons (500m, 1km, 2km, 5km).
  - “Search Again” button with location icon.
  - List of pickup locations (cards with logo, name, badges, address, radio button).
  - Billing Address section (address card with edit icon).
  - **Buttons:** Back (left), Continue (right).

- **Working:**  
  - User can change search radius to filter locations.
  - User selects a pickup location.
  - User can edit billing address.
  - “Continue” is enabled after location selection.

---

#### Technical Details

- The app fetches service points by calling the `/cart/service-points` endpoint (POST) with:
  - `postal_code`, `country`, `radius`, `post_id`, `quantity`
- The service point selection dialog (`ServicePointsDialog`) is reused from the basket/checkout flow.
- When a user selects a pickup location, its `service_point_id` is stored and included in the order payload.
- Example payload for order creation:
  ```json
  {
    "post_id": "579b75e5-564c-41bb-a97e-28625c786897-PL",
    "quantity": 1,
    "buyer_address": {
      "recipient_name": "10 Downing Street",
      "address_1": "1600 Vine Street",
      "city": "London",
      "state": "England",
      "phone_number": "+44 2079250918",
      "postal_code": "SW1A 2AA",
      "address_category": "home",
      "country": "GB",
      "is_default": true
    },
    "service_point_id": "13704859"
  }
  ```
- The UI disables the Continue button until a service point is selected.
- The same dialog and logic are used for both Buy Now and basket/checkout flows to avoid code duplication.

---

### Step 3: Shipping Option Selection

- **UI:**  
  - Product card at the top.
  - Section: “Select shipping option”
  - List of shipping options (cards with logo, title, service name, price, radio button).
  - **Buttons:** Back (left), Continue (right).

- **Working:**  
  - User selects a shipping service (e.g., DPD Ship to Shop).
  - “Continue” is enabled after selection.

---

### Step 4: Order Summary & Payment

- **UI:**  
  - Product card at the top.
  - Section: “Order Summary”
  - Pickup info (icon, label, value).
  - Shipping info (icon, label, value).
  - Price table (product, shipping, total).
  - Info box: “You’ll be redirected to our secure payment page…”
  - **Buttons:** Back (left), Pay Now (right, with card icon).

- **Working:**  
  - User reviews all details.
  - “Pay Now” redirects to payment gateway.
  - On success, user is shown confirmation (not shown in screenshots).

---

### Navigation & Interactions

- **Stepper:**  
  - Shows current step, filled for active, outlined for others.
  - “Continue” advances to next step.
  - “Back” returns to previous step.
- **Radio Buttons:**  
  - Only one option selectable per group.
- **Edit Address:**  
  - Pencil icon opens address selector/modal.
- **Pay Now:**  
  - Triggers payment process (redirect or in-app sheet).

---

### Visual & UX Details

- **Modal:** Rounded top corners, white, shadow, 16px padding.
- **Buttons:**  
  - Outlined (gray) for secondary actions.
  - Filled (red-green gradient) for primary actions.
- **Typography:**  
  - System font, clear hierarchy (bold for titles, color for prices).
- **Colors:**  
  - Red for price/total, blue for info, gray for secondary text.
- **Icons:**  
  - Material icons for all actions and info.

---

### Flow Summary

1. **User clicks “Buy Now”** on a product.
2. **Step 1:** Selects delivery method → Continue.
3. **Step 2:** (If Pickup) Selects location, edits billing address if needed → Continue.
4. **Step 3:** Selects shipping option → Continue.
5. **Step 4:** Reviews order summary → Pay Now.
6. **Redirected to payment** → Completes purchase.

---

**If you provide a video, more details about transitions, animations, or edge cases can be added. Let me know if you want a sequence diagram, state machine, or code structure for this flow!**

## General Layout

- **Container:** Modal sheet with rounded top corners (`borderRadius: 20px`), white background, and subtle drop shadow.
- **Padding:** All content inside has horizontal padding of `16px`.
- **Progress Indicator:** Horizontal stepper with 4 steps, current step filled, others outlined.
- **Header:**
  - **Back Arrow:** Left-aligned, circular button, light background.
  - **Title:** Centered, bold, "Buy Now".
  - **Close Button:** Right-aligned, circular, light background.

---

## Step 1: Delivery Method Selection

### Layout

- **Product Card:**
  - **Image:** Square, left-aligned, `56x56px`, rounded corners.
  - **Product Name:** Bold, `font-size: 18px`, black.
  - **Price:** Bold, `font-size: 18px`, red (`#D32F2F`).

- **Section Title:** "How would you like to receive your order?"  
  - **Font:** Medium, `font-size: 16px`, black, margin-top: `16px`.

- **Options:**
  - **Home Delivery:**  
    - Icon: Truck, left.
    - Title: "Home Delivery", bold, `font-size: 16px`.
    - Subtitle: "Delivered to your address", `font-size: 14px`, gray.
    - Radio button: right.
    - Card: Rounded corners, border, `height: 64px`, vertical center.
  - **Pickup Point:**  
    - Icon: Location, left.
    - Title: "Pickup Point", bold, `font-size: 16px`.
    - Subtitle: "Collect from a nearby location", `font-size: 14px`, gray.
    - Radio button: right.
    - Card: Rounded corners, border, `height: 64px`, vertical center.

- **Buttons:**
  - **Cancel:** Left, outlined, gray border, `font-size: 16px`.
  - **Continue:** Right, filled, red-green gradient, white text, `font-size: 16px`.

---

## Step 2: Pickup Location Selection

### Layout

- **Section Title:** "Find pickup locations"
  - **Font:** Medium, `font-size: 16px`, black.

- **Search Radius:** Horizontal pill buttons (`500m`, `1 km`, `2 km`, `5 km`), selected: red border and text, others: gray border and text.

- **Search Again:**  
  - Icon: Location, left.
  - Text: "Search Again", `font-size: 14px`, gray.

- **Pickup Locations List:**
  - **Card:** Rounded corners, border, vertical padding: `12px`.
  - **Logo:** Left, square, `32x32px`.
  - **Title:** Bold, "DPD" or "InPost", `font-size: 16px`.
  - **Badges:**  
    - "Parcel Shop" or "Locker", pill-shaped, light purple/blue background, `font-size: 12px`.
    - Distance badge: pill, light blue, right-aligned, `font-size: 12px`.
  - **Location Name:** Below title, `font-size: 14px`, black.
  - **Address:** Below, `font-size: 13px`, gray.
  - **Radio Button:** Left, vertical center.

- **Billing Address:**
  - **Section Title:** "Billing Address", bold, `font-size: 15px`.
  - **Address Card:** Rounded, light gray background, home icon left, address text, edit icon right.

- **Buttons:**  
  - **Back:** Left, outlined, gray border.
  - **Continue:** Right, filled, red-green gradient.

---

## Step 3: Shipping Option Selection

### Layout

- **Product Card:** (Same as above)
- **Section Title:** "Select shipping option", bold, `font-size: 16px`.
- **Shipping Options:**
  - **Card:** Rounded, border, vertical padding: `12px`.
  - **Logo:** Left, `32x32px`.
  - **Title:** Bold, "DPD", `font-size: 16px`.
  - **Service Name:** Below, "DPD Ship to Shop – Drop off at a DPD Pickup Shop", `font-size: 14px`, black.
  - **Price:** Right, bold, red, `font-size: 16px`.
  - **Radio Button:** Left, vertical center.

- **Buttons:**  
  - **Back:** Left, outlined, gray border.
  - **Continue:** Right, filled, red-green gradient.

---

## Step 4: Order Summary & Payment

### Layout

- **Product Card:** (Same as above)
- **Section Title:** "Order Summary", bold, `font-size: 16px`.
- **Pickup Info:**
  - **Icon:** Location, left.
  - **Label:** "Pickup from:", bold, `font-size: 14px`.
  - **Value:** Location name and address, `font-size: 14px`, black.

- **Shipping Info:**
  - **Icon:** Box, left.
  - **Label:** "Shipping:", bold, `font-size: 14px`.
  - **Value:** Service name, `font-size: 14px`, black.

- **Price Table:**
  - **Product:** Left, "Product", right, price, `font-size: 15px`.
  - **Shipping:** Left, "Shipping", right, price, `font-size: 15px`.
  - **Divider:** 1px, light gray.
  - **Total:** Left, "Total", bold, right, total price, bold, red, `font-size: 18px`.

- **Info Box:**  
  - **Icon:** Card, left.
  - **Text:** "You'll be redirected to our secure payment page to complete your purchase.", `font-size: 14px`, blue, light blue background, rounded corners, padding: `12px`.

- **Buttons:**  
  - **Back:** Left, outlined, gray border.
  - **Pay Now:** Right, filled, red-green gradient, card icon left, white text.

---

## Colors

- **Primary Red:** `#D32F2F`
- **Primary Green:** `#009688`
- **Gradient:** Linear, left to right, red to green.
- **Gray Text:** `#757575`
- **Light Gray Background:** `#F5F5F5`
- **Divider:** `#E0E0E0`
- **Info Blue:** `#1976D2`
- **Info Box BG:** `#E3F2FD`

---

## Typography

- **Font Family:** System default (San Francisco, Roboto, etc.)
- **Font Weights:** Regular, Medium, Bold as specified above.
- **Font Sizes:** 12px, 13px, 14px, 15px, 16px, 18px.

---

## Spacing

- **Horizontal Padding:** 16px
- **Vertical Spacing Between Sections:** 16px
- **Button Height:** 48px
- **Card Corner Radius:** 12px (main modal: 20px)
- **Badge Height:** 20px, horizontal padding: 8px

---

## Interactions

- **Stepper:** Tapping "Continue" advances to next step, "Back" returns to previous.
- **Radio Buttons:** Only one selectable per group.
- **Edit Address:** Pencil icon opens address selector.
- **Pay Now:** Opens payment sheet or redirects to payment page.

---

## Icons

- **Back Arrow:** Material, left.
- **Close:** Material, right.
- **Location:** Material, used for pickup and search.
- **Truck:** Material, for delivery.
- **Box:** Material, for shipping.
- **Card:** Material, for info box and "Pay Now".
- **Home:** Material, for address.

---

**Note:** All icons are vector, not images. All gradients, borders, and backgrounds are CSS/Flutter code, not images.

---

**This documentation is sufficient for a developer to rebuild the UI pixel-perfectly in Flutter, React Native, or any modern mobile framework.**

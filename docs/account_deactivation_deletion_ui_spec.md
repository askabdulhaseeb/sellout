# Account Deactivation & Deletion Screen – Pixel-Accurate UI Spec

## 1. Screen Structure
- **Background:** Solid white (#FFFFFF)
- **Safe Area:** All content respects system status bar and navigation bar
- **Scroll:** Content is vertically scrollable if needed

---

## 2. Header (AppBar)
- **Height:** 56 px
- **Background:** White (#FFFFFF)
- **Elevation/Shadow:** Subtle shadow (2-4 px)
- **Layout:** Horizontal row

### 2.1. Back Button
- **Icon:** Left chevron (Material Icons: chevron_left)
- **Size:** 24 x 24 px
- **Color:** #1A1A1A
- **Padding:** 16 px from left edge
- **Hit Area:** 48 x 48 px (Material standard)
- **Action:** Navigates back

### 2.2. Title Section
- **Layout:** Vertical column, left-aligned after back button
- **Main Title:**
  - Text: "Account Settings"
  - Font: 20 px, weight 600 (SemiBold), color #1A1A1A, letter spacing -0.5 px
- **Subtitle:**
  - Text: "Deactivate or delete account"
  - Font: 12 px, weight 400, color #666666, margin-top: 2 px

---

## 3. Warning Banner
- **Container:**
  - Height: auto (content-driven)
  - Margin-top: 16 px
  - Padding: 16 px (all sides)
  - Background: Linear gradient, 135° (top-left to bottom-right)
    - Start: #C41C3B
    - End: #B01832
  - Border-radius: 12 px
  - Shadow: 4 px, 30% opacity
  - No border
- **Content Layout:** Horizontal row, gap 12 px

### 3.1. Left Icon Section
- **Shield Icon:** Outlined shield (Material Icons: shield_outlined)
  - Size: 32 x 32 px, color #FFFFFF
  - Container: 40 x 40 px, centered
- **Warning Icon:** Overlay (Material Icons: warning)
  - Size: 16 x 16 px, color #FFD700
  - Position: Top-right corner of shield, margin -4 px

### 3.2. Right Text Section
- **Title:**
  - Text: "Account Deactivation & Deletion"
  - Font: 18 px, weight 600, color #FFFFFF, letter spacing -0.3 px
- **Description:**
  - Text: "Need a break or want to leave? You can temporarily deactivate your account or permanently delete it. Choose an option below to proceed."
  - Font: 13 px, weight 400, color #FFFFFF, opacity 95%

---

## 4. Option Cards
- **Layout:** Vertical column, gap 16 px, margin-top: 24 px

### 4.1. Deactivate Account Card
- **Container:**
  - Background: #F8F8F8
  - Border: 1 px solid #F5A623 (when selected), #E0E0E0 (default)
  - Border-radius: 12 px
  - Padding: 16 px
  - Shadow: none or very subtle (1 px)
  - Layout: Horizontal row, gap 12 px
- **Left Icon:**
  - Container: 44 x 44 px, background #E8F5E9, border-radius 8 px
  - Icon: pause_circle_outline, 24 x 24 px, color #388E3C
- **Right Content:**
  - **Title:** "Deactivate Account"
    - Font: 16 px, weight 600, color #1A1A1A
  - **Badge:** "Temporary"
    - Font: 11 px, weight 500, color #F5A623, background #FFF3E0, border-radius 4 px, padding 4 px horizontal, 2 px vertical
  - **Description:** "Take a break from SellOut. Your profile and data will be hidden but preserved. You can reactivate anytime and everything will be restored."
    - Font: 13 px, weight 400, color #555555, margin-top: 4 px
  - **Status Badges:** Row, gap 12 px, margin-top: 8 px
    - **Badge 1:** Icon check_circle, 16 x 16 px, color #4CAF50, text "Reversible", font 12 px, weight 500, color #4CAF50
    - **Badge 2:** Icon check_circle, 16 x 16 px, color #2196F3, text "Data preserved", font 12 px, weight 500, color #2196F3

### 4.2. Delete Account Card
- **Container:**
  - Background: #FFF5F5
  - Border: 1 px solid #D32F2F (when selected), #FFEBEE (default)
  - Border-radius: 12 px
  - Padding: 16 px
  - Shadow: none or very subtle (1 px)
  - Layout: Horizontal row, gap 12 px
- **Left Icon:**
  - Container: 44 x 44 px, background #FFEBEE, border-radius 8 px
  - Icon: delete_outline, 24 x 24 px, color #D32F2F
- **Right Content:**
  - **Title:** "Delete Account"
    - Font: 16 px, weight 600, color #1A1A1A
  - **Badge:** "Permanent"
    - Font: 11 px, weight 500, color #D32F2F, background #FFEBEE, border-radius 4 px, padding 4 px horizontal, 2 px vertical
  - **Description:** "Permanently delete your SellOut account and all associated data. This action cannot be undone. All your posts, messages, and profile will be gone forever."
    - Font: 13 px, weight 400, color #555555, margin-top: 4 px
  - **Status Badges:** Row, gap 12 px, margin-top: 8 px
    - **Badge 1:** Icon dangerous, 16 x 16 px, color #D32F2F, text "Irreversible", font 12 px, weight 500, color #D32F2F
    - **Badge 2:** Icon delete, 16 x 16 px, color #D32F2F, text "All data deleted", font 12 px, weight 500, color #D32F2F

---

## 5. Action Buttons (Initial State)
- **Layout:** Horizontal row, gap 12 px, margin-top: 32 px, margin-bottom: 24 px
- **Button 1:** "Cancel"
  - Flex: 1, height: 48 px, border-radius: 8 px
  - Border: 2 px solid #E0E0E0
  - Background: #FFFFFF
  - Font: 15 px, weight 600, color #666666
  - States: Default, hover (#F5F5F5), pressed (#EEEEEE), disabled (opacity 50%)
- **Button 2:** "Continue"
  - Flex: 1, height: 48 px, border-radius: 8 px
  - Background: #D0D0D0 (disabled), gradient #F5A623 → #D32F2F (enabled)
  - Font: 15 px, weight 600, color #FFFFFF
  - States: Disabled (opacity 60%), enabled (gradient, shadow 4 px), pressed (darker gradient, shadow 8 px)

---

## 6. Info Banner (Bottom)
- **Container:**
  - Margin-top: 24 px
  - Padding: 16 px
  - Background: #FFF8E1 (deactivation) or #FFEBEE (deletion)
  - Border-radius: 12 px
  - Layout: Horizontal row, gap 12 px
- **Icon:** info or warning, 24 x 24 px, color #F5A623 (deactivation) or #D32F2F (deletion)
- **Text:** 
  - Font: 13 px, weight 400, color #555555
  - Content: "Deactivation is temporary..." or "Account deletion is permanent and irreversible..."

---

## 7. Confirmation State (After Selection)
- **Banner:** Remains at top, unchanged
- **Confirmation Card:**
  - Container: Background #FFF8E1 (deactivation) or #FFEBEE (deletion), border-radius 12 px, padding 16 px, margin-top: 24 px
  - **Icon:** warning, 24 x 24 px, color #F5A623 (deactivation) or #D32F2F (deletion)
  - **Title:** "Confirm Deactivation" or "Confirm Account Deletion"
    - Font: 16 px, weight 600, color #F5A623 or #D32F2F
  - **Subtitle:** "Please review before proceeding"
    - Font: 13 px, weight 500, color #F5A623 or #D32F2F
  - **Description:** List of consequences, each with icon and text
    - Deactivation: green check_circle, 16 x 16 px, color #4CAF50, text color #555555
    - Deletion: red error, 16 x 16 px, color #D32F2F, text color #555555
  - **Buttons:** "Go Back" (white, border #E0E0E0, color #666666), "Deactivate Now" or "Delete Forever" (gradient or solid, color #F5A623 or #D32F2F, white text)
- **Info Banner:** Remains at bottom, unchanged

---

## 8. Spacing & Sizing
| Element                | Value      |
|------------------------|-----------|
| Screen Padding         | 16 px     |
| Section Gap            | 24 px     |
| Card Padding           | 16 px     |
| Card Gap               | 12 px     |
| Icon Size (Large)      | 24 x 24 px|
| Icon Size (Small)      | 16 x 16 px|
| Icon Container         | 44 x 44 px|
| Card Border Radius     | 12 px     |
| Button Height          | 48 px     |
| Button Border Radius   | 8 px      |
| Header Height          | 56 px     |
| Back Button Size       | 24 x 24 px|

---

## 9. Colors
| Element            | Color      | Usage                        |
|--------------------|------------|------------------------------|
| Primary Text       | #1A1A1A    | Titles, main content         |
| Secondary Text     | #555555    | Descriptions                 |
| Tertiary Text      | #666666    | Subtitles, labels            |
| Light Background   | #F8F8F8    | Card backgrounds             |
| Very Light Red     | #FFF5F5    | Delete card background       |
| Warning Red        | #C41C3B    | Banner background start      |
| Warning Red Dark   | #B01832    | Banner background end        |
| Error Red          | #D32F2F    | Error badges, icons          |
| Success Green      | #4CAF50    | Success indicators           |
| Success Light Green| #388E3C    | Deactivate icon              |
| Success BG Green   | #E8F5E9    | Deactivate icon background   |
| Info Blue          | #2196F3    | Info badges                  |
| Warning Amber      | #F5A623    | Temporary badge text         |
| Warning BG Amber   | #FFF3E0    | Temporary badge background   |
| Border Gray        | #E0E0E0    | Borders, dividers            |
| White              | #FFFFFF    | Base, buttons, text on color |
| Golden Yellow      | #FFD700    | Warning icon overlay         |

---

## 10. Typography
| Element            | Size | Weight | Color      |
|--------------------|------|--------|-----------|
| Header Title       | 20px | 600    | #1A1A1A   |
| Header Subtitle    | 12px | 400    | #666666   |
| Banner Title       | 18px | 600    | #FFFFFF   |
| Banner Description | 13px | 400    | #FFFFFF   |
| Card Title         | 16px | 600    | #1A1A1A   |
| Card Description   | 13px | 400    | #555555   |
| Badge Text         | 11px | 500    | Various   |
| Status Badge Text  | 12px | 500    | Various   |
| Button Text        | 15px | 600    | #FFFFFF/#666666 |

---

## 11. States & Interactions
- **Card Selection:** Selected card has colored border (#F5A623 for deactivate, #D32F2F for delete)
- **Button States:** Disabled, enabled, hover, pressed (see above)
- **Ripple Effects:** Material ripple on cards and buttons, color matches theme
- **Transitions:** Fade/slide for confirmation, button enable animation (200 ms, ease-out cubic)

---

## 12. Accessibility
- **Color Contrast:** All text meets WCAG AA (4.5:1)
- **Touch Targets:** All buttons/cards min 48 x 48 px
- **Text Scaling:** Supports up to 200%
- **Semantic Roles:** Cards as buttons, banners as alerts
- **Navigation:** Logical tab order, clear disabled states

---

## 13. Animation
- **Page Entry:** Fade in + slide up (300 ms, ease-out cubic)
- **Card Tap:** Opacity change + scale (150 ms, ease-out quad)
- **Button Press:** Scale + ripple (100 ms, linear)
- **Continue Button Enable:** Fade in gradient, shadow (200 ms, ease-out cubic)

---

## 14. Special Details
- **Banner Pattern:** Subtle geometric shapes in background (optional, can be omitted for code)
- **Icon Placement:** All icons centered in containers, overlay warning icon on shield
- **Shadows:** Banner (4 px, 30% opacity), cards (1 px, 10% opacity), buttons (2-8 px)
- **Borders:** 1 px on cards, 2 px on outline button

---

## 15. Edge Cases
- **Small Screens (<360 px):** Buttons stack vertically, full width
- **Medium Screens (360-600 px):** Buttons side by side
- **Large Screens (>600 px):** Max width 400-500 px, centered

---

This documentation provides all the details needed for a pixel-accurate mobile implementation. If you need component breakdowns or code samples for Flutter, Jetpack Compose, or SwiftUI, let me know!

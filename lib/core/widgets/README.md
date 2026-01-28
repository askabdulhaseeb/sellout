# lib/core/widgets Folder Structure & Organization Guide

## Current State
The `lib/core/widgets` folder contains a mix of general-purpose widgets, custom UI components, and some subfolders for grouped widgets (e.g., `calender/`, `loaders/`, `phone_number/`, `scaffold/`). However, many files are not grouped, making it harder to locate specific widgets quickly.

### Example of Current Files:
- attachment_slider.dart
- custom_elevated_button.dart
- custom_icon_button.dart
- custom_network_image.dart
- custom_radio_button_list_tile.dart
- editable_availablity_widget.dart
- empty_page_widget.dart
- expandable_text_widget.dart
- linear_rating_widget.dart
- location_field.dart
- password_textformfield.dart
- profile_photo.dart
- rating_display_widget.dart
- searchable_textfield.dart
- sellout_title.dart
- shadow_container.dart
- step_progress_indicator.dart
- video_widget.dart
- ...and more

## Suggestions for Better Classification
To improve discoverability and maintainability, consider grouping widgets into subfolders by their type or purpose. Here are some suggested categories and example groupings:

### 1. **Buttons**
- custom_elevated_button.dart
- custom_icon_button.dart
- location_input_button.dart

### 2. **Inputs & Forms**
- custom_textformfield.dart
- password_textformfield.dart
- custom_pin_input_field.dart
- custom_multi_selection_dropdown.dart
- custom_dropdown.dart
- searchable_textfield.dart
- phone_number/ (already a folder)

### 3. **Images & Media**
- custom_network_image.dart
- custom_memory_image.dart
- profile_photo.dart
- video_widget.dart
- attachment_slider.dart

### 4. **Indicators & Loaders**
- step_progress_indicator.dart
- linear_rating_widget.dart
- rating_display_widget.dart
- custom_shimmer_effect.dart
- loaders/ (already a folder)

### 5. **Toggles & Switches**
- custom_toggle_switch.dart
- custom_switch_list_tile.dart
- custom_radio_toggle_tile.dart
- custom_radio_button_list_tile.dart

### 6. **Text & Display**
- expandable_text_widget.dart
- limited_html_text.dart
- sellout_title.dart
- empty_page_widget.dart
- empty_page_widget_fresh.dart
- promo_widget.dart
- shadow_container.dart
- coming_soon_overlay.dart

### 7. **Calendar & Date**
- calender/ (already a folder)

### 8. **Scaffold & Layout**
- scaffold/ (already a folder)

### 9. **Other/Utility**
- in_dev_mode.dart
- app_snackbar.dart
- location_field.dart
- editable_availablity_widget.dart

## Example of Proposed Structure
```
widgets/
  buttons/
    custom_elevated_button.dart
    custom_icon_button.dart
    location_input_button.dart
  inputs/
    custom_textformfield.dart
    password_textformfield.dart
    custom_pin_input_field.dart
    custom_multi_selection_dropdown.dart
    custom_dropdown.dart
    searchable_textfield.dart
    phone_number/
  media/
    custom_network_image.dart
    custom_memory_image.dart
    profile_photo.dart
    video_widget.dart
    attachment_slider.dart
  indicators/
    step_progress_indicator.dart
    linear_rating_widget.dart
    rating_display_widget.dart
    custom_shimmer_effect.dart
    loaders/
  toggles/
    custom_toggle_switch.dart
    custom_switch_list_tile.dart
    custom_radio_toggle_tile.dart
    custom_radio_button_list_tile.dart
  text_display/
    expandable_text_widget.dart
    limited_html_text.dart
    sellout_title.dart
    empty_page_widget.dart
    empty_page_widget_fresh.dart
    promo_widget.dart
    shadow_container.dart
    coming_soon_overlay.dart
  calendar/
    calender/
  scaffold/
    scaffold/
  utils/
    in_dev_mode.dart
    app_snackbar.dart
    location_field.dart
    editable_availablity_widget.dart
```

## Recommendations
- Move files into subfolders as shown above for better organization.
- Use clear, descriptive folder names based on widget purpose.
- Add a README in each subfolder describing its contents.
- Update imports throughout the codebase after restructuring.

This structure will make it much easier to find, maintain, and extend widgets in your project.

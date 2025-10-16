//! A centralized class for managing consistent spacing, padding,borderRadius
//! and radius values throughout the app.

//? Usage :
// SizedBox(height: AppSpacing.vMd);
// Padding(padding: EdgeInsets.all(AppSpacing.md));
// BorderRadius.circular(AppSpacing.radiusMd);
class AppSpacing {
  const AppSpacing._();

  // Padding / Margin sizes
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Vertical spacing (SizedBox heights)
  static const double vXs = xs;
  static const double vSm = sm;
  static const double vMd = md;
  static const double vLg = lg;
  static const double vXl = xl;

  // Horizontal spacing (SizedBox widths)
  static const double hXs = xs;
  static const double hSm = sm;
  static const double hMd = md;
  static const double hLg = lg;
  static const double hXl = xl;

  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;
}

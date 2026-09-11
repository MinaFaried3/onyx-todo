/// UI domain barrel - Design system, theme, widgets, responsive layout, animations & dialogs.
///
/// Import this file to access internal UI components:
/// ```dart
/// import 'package:onyx_todo/core/ui/ui.dart';
/// ```
library;

// ─── Design System ────────────────────────────────────────────────────────────
export 'color_manager.dart';
export 'decoration_manager.dart';
export 'font_manager.dart';
export 'responsive_manager.dart';
export 'styles_manager.dart';
export 'theme_manager.dart';
export 'values_manager.dart';

// ─── Responsive ───────────────────────────────────────────────────────────────
export 'responsive/break_points.dart';
export 'responsive/responsive_extension.dart';
export 'responsive/widgets/adaptive_Visibility.dart';
export 'responsive/widgets/adaptive_builder.dart';
export 'responsive/widgets/adaptive_padding.dart';
export 'responsive/widgets/flex_wrap.dart';
export 'responsive/widgets/flexible_fitted.dart';
export 'responsive/widgets/flexible_wrap.dart';

// ─── General Widgets ──────────────────────────────────────────────────────────
export 'widgets/app_bar_back_button.dart';
export 'widgets/app_elevation.dart';
export 'widgets/app_svg.dart';
export 'widgets/check_state.dart';
export 'widgets/conditional_builder.dart';
export 'widgets/custom_app_bar.dart';
export 'widgets/custom_cached_network_image.dart';
export 'widgets/custom_error_widget.dart';
export 'widgets/dialog.dart';
export 'widgets/otp_input_field.dart';
export 'widgets/retry.dart';
export 'widgets/space.dart';

// ─── Buttons ──────────────────────────────────────────────────────────────────
export 'widgets/buttons/back_button.dart';
export 'widgets/buttons/button.dart';
export 'widgets/buttons/buttons_methods.dart';
export 'widgets/buttons/circle_button.dart';
export 'widgets/buttons/loading_button.dart';
export 'widgets/buttons/outlined_button.dart';
export 'widgets/buttons/text_button.dart';

// ─── Bottom Sheets ────────────────────────────────────────────────────────────
export 'widgets/bottom_sheets/bottom_sheet.dart';
export 'widgets/bottom_sheets/custom_bottom_sheet.dart';
export 'widgets/bottom_sheets/image_picker_sheet.dart';

// ─── Dialogs ──────────────────────────────────────────────────────────────────
export 'widgets/dialog/custom_dialog.dart';

// ─── Snackbar ─────────────────────────────────────────────────────────────────
export 'widgets/custom_snackbar/custom_snack_bar.dart';
export 'widgets/custom_snackbar/snack_bar_service.dart';

// ─── Lists ────────────────────────────────────────────────────────────────────
export 'widgets/lists/horizontal_pagination_list.dart';
export 'widgets/lists/pagination_list.dart';
export 'widgets/lists/pagination_list_with_tabs.dart';

// ─── Bottom Nav Bar ───────────────────────────────────────────────────────────
export 'widgets/app_bottom_nav_bar/app_bottom_nav_bar.dart';

// ─── Animations — Route ───────────────────────────────────────────────────────
export 'widgets/animation/route/fade_page_route.dart';
export 'widgets/animation/route/rotate_page_route.dart';
export 'widgets/animation/route/scale_page_route.dart';
export 'widgets/animation/route/size_page_route.dart';
export 'widgets/animation/route/slide_page_route.dart';

// ─── Animations — Widget ──────────────────────────────────────────────────────
export 'widgets/animation/widget/fade_transition_widget.dart';
export 'widgets/animation/widget/positioned_transition_widget.dart';
export 'widgets/animation/widget/rotation_transition_widget.dart';
export 'widgets/animation/widget/sized_transition_widget.dart';
export 'widgets/animation/widget/slidable_widget.dart';
export 'widgets/animation/widget/text_tramsition_widget.dart';

// ─── Animations — Lottie & Indicators ─────────────────────────────────────────
export 'widgets/animation/lottie_animation/loading_indicator.dart';
export 'widgets/animation/lottie_animation/success_indicators.dart';

// ─── Lifecycle ────────────────────────────────────────────────────────────────
export 'widgets/general/app_lifecycle.dart';
export 'widgets/general/widget_lifecycle.dart';

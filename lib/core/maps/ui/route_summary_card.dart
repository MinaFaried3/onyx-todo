import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';

/// **RouteSummaryCard**
///
/// **When to use**:
/// Use this card at the bottom of the map screen when a route is computed or a ride is offered.
///
/// **Why to use**:
/// - Summarizes route details: distance, duration, and a customizable action button.
/// - Matches premium glassmorphism/shadow styling for Uber-like user interfaces.
/// - Highly customizable: text styling, action button colors, padding, and titles.
class RouteSummaryCard extends StatelessWidget {
  /// Distance text (e.g., "5.4 km").
  final String distance;

  /// Duration text (e.g., "12 min").
  final String duration;

  /// Title above the summary (e.g. "Trip Details" or "Incoming Ride Request").
  final String? title;

  /// Icon next to the details.
  final IconData leadingIcon;

  /// Text on the primary action button.
  final String actionButtonText;

  /// Callback when the primary button is tapped.
  final void Function() onActionPressed;

  /// Background color of the card.
  final Color backgroundColor;

  /// Shadow color.
  final Color shadowColor;

  /// Primary color for the action button.
  final Color primaryButtonColor;

  /// Text color for the action button.
  final Color primaryButtonTextColor;

  const RouteSummaryCard({
    super.key,
    required this.distance,
    required this.duration,
    required this.actionButtonText,
    required this.onActionPressed,
    this.title,
    this.leadingIcon = Icons.directions_car,
    this.backgroundColor = ColorsManager.white,
    this.shadowColor = Colors.black12,
    this.primaryButtonColor = ColorsManager.bluePrimary,
    this.primaryButtonTextColor = ColorsManager.whiteTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            // Handle bar to simulate bottom sheet handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: ColorsManager.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  color: ColorsManager.greyTextColor,
                  fontSize: 12,
                  fontWeight: .w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
            ],

            Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorsManager.lightBlueSecondary,
                  radius: 22,
                  child: Icon(leadingIcon, color: ColorsManager.bluePrimary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        duration,
                        style: const TextStyle(
                          color: ColorsManager.darkTextColor,
                          fontSize: 20,
                          fontWeight: .bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          color: ColorsManager.greyTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Action Button
            ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryButtonColor,
                foregroundColor: primaryButtonTextColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                actionButtonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: .w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onyx_todo/core/maps/model/response/places_api_new/autocomplete_new_response.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';

/// **PlaceAutocompleteSearchField**
///
/// **When to use**:
/// Use this widget when the user needs to search for locations (e.g., origin, destination, intermediate stopovers).
///
/// **Why to use**:
/// - Built-in debounce mechanism to prevent calling Google Places API on every single keystroke.
/// - Self-contained suggestions rendering.
/// - Custom styling matching premium dark/light interfaces.
/// - Exposes clean callbacks for prediction selection and query changes.
class PlaceAutocompleteSearchField extends StatefulWidget {
  /// Hint text inside the input field.
  final String hintText;

  /// Callback when a prediction is selected from the suggestion list.
  final void Function(PlacePrediction prediction) onPlaceSelected;

  /// Callback to execute custom API call for suggestions.
  /// Typically calls `MapsCubit.autocomplete(query)`.
  final FutureOr<void> Function(String query) onQueryChanged;

  /// List of suggestions fetched from the API.
  final List<Suggestion> suggestions;

  /// Background color of the input field.
  final Color fillColor;

  /// Border radius of the input field.
  final double borderRadius;

  /// Left-side icon prefixing the field.
  final Widget? prefixIcon;

  /// Time to wait before executing query callback in milliseconds (default 500ms).
  final int debounceMs;

  const PlaceAutocompleteSearchField({
    super.key,
    required this.hintText,
    required this.onPlaceSelected,
    required this.onQueryChanged,
    required this.suggestions,
    this.fillColor = ColorsManager.lightGreyBgSecondary,
    this.borderRadius = 12.0,
    this.prefixIcon = const Icon(Icons.location_on, color: ColorsManager.redPrimary),
    this.debounceMs = 500,
  });

  @override
  State<PlaceAutocompleteSearchField> createState() => _PlaceAutocompleteSearchFieldState();
}

class _PlaceAutocompleteSearchFieldState extends State<PlaceAutocompleteSearchField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  void _onChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: widget.debounceMs), () {
      widget.onQueryChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        // Styled Input Box
        Container(
          decoration: BoxDecoration(
            color: widget.fillColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            style: const TextStyle(
              color: ColorsManager.darkTextColor,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              prefixIcon: widget.prefixIcon,
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: ColorsManager.greyTextSecondary, size: 20),
                      onPressed: () {
                        _controller.clear();
                        widget.onQueryChanged('');
                      },
                    )
                  : null,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: ColorsManager.greyTextSecondary,
                fontSize: 14,
              ),
              border: InputBorder.none,
            ),
          ),
        ),

        // Autocomplete Suggestion Dropdown List
        if (widget.suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              color: ColorsManager.white,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.suggestions.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: ColorsManager.dividerColor,
              ),
              itemBuilder: (context, index) {
                final suggestion = widget.suggestions[index];
                final prediction = suggestion.placePrediction;

                return ListTile(
                  dense: true,
                  leading: const CircleAvatar(
                    backgroundColor: ColorsManager.lightGreyBgSecondary,
                    radius: 16,
                    child: Icon(Icons.place, size: 16, color: ColorsManager.greyTextColor),
                  ),
                  title: Text(
                    prediction.structuredFormat.mainText?.text ?? prediction.text.text ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorsManager.darkTextColor,
                      fontWeight: .w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    prediction.structuredFormat.secondaryText?.text ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorsManager.greyTextColor,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    // Update field text
                    _controller.text = prediction.text.text ?? '';
                    // Clear search
                    widget.onPlaceSelected(prediction);
                    // Dismiss keyboard
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}

---
name: fix-layout-issues
description: Step-by-step checklist and guides to resolve UI issues such as layout/render flex overflows, keyboard overlaps, viewport size constraint errors, and accessibility scaling breakage.
---

# Fix Layout Issues

Use this skill when you encounter Flutter layout bugs, UI clipping, overflow warning banners (yellow-black striped boxes), or when user keyboard interactions hide text inputs.

## Common Layout Problems & Solutions

### 1. RenderFlex Overflow (Yellow/Black lines)
- **Cause**: A child widget inside a `Row`, `Column`, or `Flex` wants to expand larger than the parent's constraints.
- **Solution**:
  - Wrap the overflowing child in an `Expanded` or `Flexible` widget to force it to size within the available space.
  - If a scrollable view is desired, wrap the layout in a `SingleChildScrollView` or use `ListView`.

```dart
// ❌ Overflowing Row
Row(
  children: [
    Image.asset('my_image.png'),
    Text('Very long text that will overflow the right side of the screen'),
  ],
)

// ✅ Fixed Row
Row(
  children: [
    Image.asset('my_image.png'),
    Expanded(
      child: Text('Very long text that wraps safely inside the row'),
    ),
  ],
)
```

### 2. Viewport Has Infinite Size Exceptions
- **Cause**: Placing an unbounded scrollable list (`ListView`, `GridView`) directly inside a `Column` or `Row` without boundaries.
- **Solution**:
  - Wrap the scrollable view in `Expanded` or `Flexible` if it's in a Flex container.
  - Set `shrinkWrap: true` and `physics: const NeverScrollableScrollPhysics()` if it should auto-size itself inside a scroll view.

```dart
// ❌ Viewport error
Column(
  children: [
    const Text('My Header'),
    ListView.builder(
      itemCount: 10,
      itemBuilder: (_, i) => Text('Item $i'),
    ),
  ],
)

// ✅ Fixed (if scrollable parent is not needed)
Column(
  children: [
    const Text('My Header'),
    Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, i) => Text('Item $i'),
      ),
    ),
  ],
)
```

### 3. Keyboard Overlapping Text Fields
- **Cause**: Input fields are placed low on the screen, and the soft keyboard covers them.
- **Solution**:
  - Ensure the parent `Scaffold` has `resizeToAvoidBottomInset: true` (default is true).
  - Wrap the content in a `SingleChildScrollView` to allow it to scroll when keyboard is open.
  - Query keyboard visibility using `context.isKeyboardOpen` or `context.keyboardHeight` from the responsive extensions if custom padding adjustment is required.

### 4. Text Scaling / Accessibility Breakage
- **Cause**: Large text fonts overlap or clip when a user increases the system font size.
- **Solution**:
  - Always use `context.sp(fontSize)` for your TextStyle sizes. This scales the font size responsively and clips it safely within the upper limit (1.3x) to prevent layouts from breaking.

```dart
Text(
  'My Label',
  style: TextStyle(
    fontSize: context.sp(14), // Resizes safely
  ),
)
```

## References
- Responsive & Layout Extensions: [responsive_extension.dart](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/ui/responsive/responsive_extension.dart)
- Shared UI Components: [lib/core/ui/widgets](file:///Users/minafaried/StudioProjects/Onyx_driver/lib/core/ui/widgets)

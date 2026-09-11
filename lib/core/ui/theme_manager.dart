/*
* todo
* make general theme manger have sizing values or decoration shapes
* make light , dark theme manger
* copy with the different colors only
**/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';
import 'package:onyx_todo/core/ui/font_manager.dart';
import 'package:onyx_todo/core/ui/styles_manager.dart';
import 'package:onyx_todo/core/ui/values_manager.dart';

class ThemeManger {

  static const ColorScheme colorScheme = ColorScheme(
    //primary main color for selected and elevated text and indicator
    primary: ColorsManager.redPrimary,
    //color of icons on primary color
    onPrimary: ColorsManager.lightGreyBgSecondary,
    //color of backgrounds like avatar of flouting buttons
    primaryContainer: ColorsManager.orangeSecondary,
    // color of icon on onPrimary
    onPrimaryContainer: ColorsManager.offWhite300,
    brightness: Brightness.dark,
    //color of background
    surface: ColorsManager.whiteTextColor,

    tertiary: ColorsManager.lightGreyBgSecondary,
    //back color for am or pm in time picker
    tertiaryContainer: ColorsManager.offWhite200,

    //color for am or pm in time picker
    onTertiaryContainer: ColorsManager.lightGreyBgSecondary,

    //outline color in date picker under the date and  dividers or decorative elements.
    outlineVariant: ColorsManager.lightGreyBgSecondary,

    //color of all borders and color of dot switch
    outline: ColorsManager.lightGreyBgSecondary,

    //input validation errors InputDecoration.errorText.
    error: ColorsManager.red700,

    //mix with surface color
    surfaceTint: null,

    //date title in date picker and icon button color ,and switching color of switch,and unselected checkbox
    onSurfaceVariant: ColorsManager.greyTextSecondary,
    //color of hour on time picker and back color of linear indicator, back ground of false switch
    surfaceContainerHighest: ColorsManager.orangeSecondary,
    //like snackBar for background
    inverseSurface: ColorsManager.redPrimary,
    shadow: ColorsManager.lightOffWhite,

    //unused
    //appbar back ground you make
    inversePrimary: ColorsManager.lightGreyBgSecondary,
    //colors of borders on background
    onSurface: ColorsManager.redPrimary,
    //secondary
    secondary: ColorsManager.yellow,
    secondaryContainer: ColorsManager.yellow300,
    onSecondary: ColorsManager.grey,
    onSecondaryContainer: ColorsManager.yellow1000,

    //error
    onError: ColorsManager.red300,
    errorContainer: ColorsManager.red400,
    onErrorContainer: ColorsManager.red900,
    //surface
    onInverseSurface: ColorsManager.grey400,
    //tertiary
    onTertiary: ColorsManager.lightGreyBgSecondary,
    //scrim
    // scrim: Colors.purple,
  );

  static const CardThemeData cardTheme = CardThemeData(
    color: ColorsManager.beige1,
    shadowColor: ColorsManager.grey1,
    elevation: 4,
  );

  static const IconThemeData iconThemeData = IconThemeData(
    color: ColorsManager.darkTextColor,
  );

  static ActionIconThemeData actionIconThemeData = ActionIconThemeData(
    backButtonIconBuilder: (BuildContext context) => IconButton(
      icon: Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => context.safePop(),
      color: ColorsManager.darkTextColor,
    ),
  );

  static SystemUiOverlayStyle whiteStatusBarStyle = const SystemUiOverlayStyle(
    statusBarColor: ColorsManager.whiteBgColor,
    // iOS
    statusBarBrightness: Brightness.light,
    // iOS
    statusBarIconBrightness: Brightness.dark,
    //Android
    systemNavigationBarColor: ColorsManager.whiteBgColor,
    //Android
    systemNavigationBarIconBrightness: Brightness.dark, // Android
  );

  static SystemUiOverlayStyle whiteRedStatusBarStyle = SystemUiOverlayStyle(
    statusBarColor: ColorsManager.whiteRedBgColor,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: ColorsManager.whiteRedBgColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle lightBlueStatusBarStyle = SystemUiOverlayStyle(
    statusBarColor: ColorsManager.lightBlueGreyBgColor,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: ColorsManager.lightBlueGreyBgColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle getCustomStatusBar({
    required Color color,
    bool isStatusIconsLight = true,
  }) {
    Brightness brightness = isStatusIconsLight
        ? Brightness.dark
        : Brightness.light;

    return SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarColor: color,
      systemNavigationBarIconBrightness: brightness,
    );
  }

  static final AppBarTheme appBarTheme = AppBarTheme(
    systemOverlayStyle: whiteStatusBarStyle,
    iconTheme: iconThemeData,
    actionsIconTheme: iconThemeData,
    color: ColorsManager.whiteBgColor,
    elevation: 0,
    // shadowColor: ColorManager.lightPrimary,
    titleTextStyle: get600SemiBoldStyle(fontSize: 18),
  );

  static const ButtonThemeData buttonThemeData = ButtonThemeData(
    shape: StadiumBorder(),
    disabledColor: ColorsManager.grey1,
    buttonColor: ColorsManager.paleVioletRed,
    splashColor: ColorsManager.beige1,
  );

  static final TextButtonThemeData textButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: const WidgetStatePropertyAll(ColorsManager.whiteBgColor),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(AppPadding.p0)),
      textStyle: WidgetStatePropertyAll(
        get700BoldStyle(color: ColorsManager.whiteTextColor, fontSize: 22),
      ),
    ),
  );

  static final OutlinedButtonThemeData outlinedButtonThemeData =
      OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(
            ColorsManager.errorColor,
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: ColorsManager.whiteBgColor),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          textStyle: WidgetStatePropertyAll(get600SemiBoldStyle(fontSize: 18)),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        ),
      );

  static const IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.all(AppPadding.p0)),
    ),
  );
  static final ElevatedButtonThemeData elevatedButtonThemeData =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: get400RegularStyle(
            color: ColorsManager.whiteBgColor,
            fontSize: 17,
          ),
          backgroundColor: ColorsManager.redPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  //todo
  static final TextTheme textTheme = TextTheme(
    //headlines
    headlineLarge: get800ExtraBoldStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 28,
    ),
    headlineMedium: get700BoldStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 26,
    ),
    headlineSmall: get600SemiBoldStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 20,
    ),

    //titles
    titleLarge: get600SemiBoldStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 28,
    ),
    titleMedium: get400RegularStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 26,
    ),
    titleSmall: get500MediumStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 20,
    ),

    //displays
    displayLarge: get400RegularStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 28,
    ),
    displayMedium: get500MediumStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 26,
    ),
    displaySmall: get300LightStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 20,
    ),

    //bodies
    bodyLarge: get400RegularStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 22,
    ),
    bodyMedium: get500MediumStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 15,
    ),
    bodySmall: get300LightStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 14,
    ),

    //labels
    labelLarge: get500MediumStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 28,
    ),
    labelMedium: get300LightStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 26,
    ),
    labelSmall: get200ExtraLightStyle(
      color: ColorsManager.blackTextSecondary,
      fontSize: 20,
    ),
  );

  static const BottomSheetThemeData bottomSheetThemeData = BottomSheetThemeData(
    backgroundColor: ColorsManager.white,
  );

  static const TextSelectionThemeData textSelectionThemeData =
      TextSelectionThemeData(
        cursorColor: ColorsManager.redPrimary,
        selectionColor: ColorsManager.bluePrimary25,
        selectionHandleColor: ColorsManager.redPrimary,
      );

  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    isDense: true,
    // content padding
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
    // hint style
    hintStyle: get400RegularStyle(
      color: ColorsManager.blackTextSecondary.withValues(alpha: 0.75),
      fontSize: 28,
    ),
    //align label
    alignLabelWithHint: true,
    labelStyle: get400RegularStyle(
      color: ColorsManager.blackTextSecondary.withValues(alpha: 0.75),
      fontSize: 20,
    ),
    errorStyle: get400RegularStyle(color: ColorsManager.red700, fontSize: 14),
    errorMaxLines: 0,

    //filled colors
    filled: true,
    fillColor: ColorsManager.lightBlueGreyBgColor,

    // enabled border style
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),

    // focused border style
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: ColorsManager.bluePrimary, width: 1_5),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),

    // error border style
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: ColorsManager.red700, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),

    // focused border style
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );
}

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // Cairo as the app-wide default font — covers Arabic & Latin
    fontFamily: FontConstants.cairoFontFamily,
    // main colors
    colorScheme: ThemeManger.colorScheme,
    primaryColor: ColorsManager.redPrimary,
    primaryColorLight: ColorsManager.errorColor,
    focusColor: ColorsManager.thistle,
    primaryColorDark: ColorsManager.mauva,
    disabledColor: ColorsManager.grey1,
    splashColor: ColorsManager.beige1,
    scaffoldBackgroundColor: ColorsManager.whiteBgColor,

    //todo
    badgeTheme: const BadgeThemeData(),
    datePickerTheme: const DatePickerThemeData(),
    timePickerTheme: const TimePickerThemeData(),
    listTileTheme: const ListTileThemeData(),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    dataTableTheme: const DataTableThemeData(),
    snackBarTheme: const SnackBarThemeData(),
    bannerTheme: const MaterialBannerThemeData(),
    // platform: TargetPlatform.android,

    // ripple effect color
    // cardView theme
    cardTheme: ThemeManger.cardTheme,
    // app bar theme
    appBarTheme: ThemeManger.appBarTheme,
    // action icon theme
    actionIconTheme: ThemeManger.actionIconThemeData,
    // button theme
    buttonTheme: ThemeManger.buttonThemeData,
    //icon button theme
    iconButtonTheme: ThemeManger.iconButtonThemeData,
    // text button theme
    textButtonTheme: ThemeManger.textButtonThemeData,
    // outlined button theme
    outlinedButtonTheme: ThemeManger.outlinedButtonThemeData,
    // elevated button theme
    elevatedButtonTheme: ThemeManger.elevatedButtonThemeData,

    bottomSheetTheme: ThemeManger.bottomSheetThemeData,

    iconTheme: ThemeManger.iconThemeData,

    textTheme: ThemeManger.textTheme,
    //text selection
    textSelectionTheme: ThemeManger.textSelectionThemeData,

    // input decoration theme (text form field)
    inputDecorationTheme: ThemeManger.inputDecorationTheme,
    // label style
  );
}

ThemeData getClickUpTheme({bool isDark = true}) {
  final bg = isDark ? ClickUpColors.darkBackground : ClickUpColors.lightBackground;
  final surface = isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard;

  return ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    fontFamily: FontConstants.cairoFontFamily,
    scaffoldBackgroundColor: bg,
    cardColor: surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ClickUpColors.primary,
      brightness: isDark ? Brightness.dark : Brightness.light,
      surface: surface,
    ),
  );
}

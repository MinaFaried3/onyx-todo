import 'package:flutter/material.dart';

/// Single source of truth for all brand colors.
/// Values extracted from the Figma design file.
///
/// Structure:
///   1. Figma palette  — raw hex values, named exactly as in Figma.
///   2. Semantic aliases — Material / feature names that point to palette entries.
///   3. Legacy aliases  — old names kept for backwards-compat; no new usages.
///
/// Rule: hex values live ONLY in section 1. Sections 2 & 3 contain no Color() literals
///       except where there is no matching palette entry.
abstract final class ColorsManager {
  // ══════════════════════════════════════════════════════════════════════════
  // 1 — FIGMA PALETTE  (one Color() per unique hex — no duplicates)
  // ══════════════════════════════════════════════════════════════════════════

  // ── Main (Burgundy / Plum) ───────────────────────────────────────────────
  static const main1 = Color(0xFF5B1F3A); // primary burgundy
  static const main2 = Color(0xFFA46DB4); // muted plum
  static const main3 = Color(0xFFA277BB); // soft lavender plum

  // ── Black / Dark ─────────────────────────────────────────────────────────
  static const black1 = Color(0xFF040D02); // near-black
  static const black2 = Color(0xFF564348); // dark plum-grey

  // ── Neutral ──────────────────────────────────────────────────────────────
  static const nutrailColor1 = Color(0xFF9D9D9D); // mid-grey
  static const nutrailColor2 = Color(0xFFF5F5F5); // off-white

  // ── Green ─────────────────────────────────────────────────────────────────
  static const green1 = Color(0xFFDDE8C8); // soft sage
  static const green2 = Color(0xFFF8FFEA); // very light mint
  static const green3 = Color(0xFFB4BEA0); // muted olive

  // ── Beg (Beige / Amber) ───────────────────────────────────────────────────
  static const beg1 = Color(0xFFF9DBAF); // warm amber
  static const beg2 = Color(0xFFF9E0B4); // pale yellow-cream
  static const beg3 = Color(0xFFFEF9C7); // light golden beige
  static const beg4 = Color(0xFFF8EDAF); // very light cream
  static const beg5 = Color(0xFFFEFDF1); // near-white beige

  // ── Secondary shades ──────────────────────────────────────────────────────
  static const secondry5 = Color(0xFFF7F4ED); // warm off-white

  // ── Error ─────────────────────────────────────────────────────────────────
  static const errorRaw = Color(0xFFC31E2E);
  static const errorContainerRaw = Color(0xFFFFDAD6);
  static const onErrorContainerRaw = Color(0xFF93000A);

  // ── Misc brand / utility ──────────────────────────────────────────────────
  static const interactiveBlue = Color(0xFF0F77F0);
  static const creamLighterRaw = Color(0xFFF5F0E8);
  static const oliveAccentRaw = Color(0xFFB4BEA0);
  static const amberPaleAltRaw = Color(0xFFFEFCE8);
  static const outlineRaw = Color(0x40000000);
  static const outlineVariantRaw = Color(0xFFD6C1C7);

  // ── Material surface scale ────────────────────────────────────────────────
  static const surfaceRaw = Color(0xFFF8F9FF);
  static const surfaceDimRaw = Color(0xFFD0DBEC);
  static const surfaceContainerLowestRaw = Color(0xFFFFFFFF);
  static const surfaceContainerLowRaw = Color(0xFFEFF4FF);
  static const surfaceContainerRaw = Color(0xFFE5EEFF);
  static const surfaceContainerHighRaw = Color(0xFFDFE9FB);
  static const surfaceContainerHighestRaw = Color(0xFFD9E3F5);
  static const surfaceTintRaw = Color(0xFF8D4864);
  static const inverseSurfaceRaw = Color(0xFF27313F);

  // ── Material primary extended ─────────────────────────────────────────────
  static const onPrimaryContainerRaw = Color(0xFFD685A4);
  static const inversePrimaryRaw = Color(0xFFFFB0CC);
  static const primaryFixedRaw = Color(0xFFFFD9E4);
  static const primaryFixedDimRaw = Color(0xFFFFB0CC);
  static const onPrimaryFixedRaw = Color(0xFF3B0420);
  static const onPrimaryFixedVariantRaw = Color(0xFF71314C);

  // ── Material secondary extended ───────────────────────────────────────────
  static const secondaryContainerRaw = Color(0xFFE2E0CD);
  static const onSecondaryContainerRaw = Color(0xFF646354);
  static const secondaryFixedRaw = Color(0xFFE5E3D0);
  static const secondaryFixedDimRaw = Color(0xFFC9C7B5);
  static const onSecondaryFixedRaw = Color(0xFF1C1C10);
  static const onSecondaryFixedVariantRaw = Color(0xFF474839);

  // ── Material tertiary ─────────────────────────────────────────────────────
  static const tertiaryRaw = Color(0xFF001E47);
  static const tertiaryContainerRaw = Color(0xFF00336F);
  static const onTertiaryContainerRaw = Color(0xFF649CFF);
  static const tertiaryFixedRaw = Color(0xFFD7E2FF);
  static const tertiaryFixedDimRaw = Color(0xFFACC7FF);
  static const onTertiaryFixedRaw = Color(0xFF001A40);
  static const onTertiaryFixedVariantRaw = Color(0xFF004491);

  // ── Keyboard ──────────────────────────────────────────────────────────────
  static const keyPrimaryDarkRaw = Color(0xFF646464);
  static const keySecondaryDarkRaw = Color(0xFF3F3F3F);
  static const keySecondaryLightRaw = Color(0xFFAEB3BE);
  static const keyLightFunctionalRaw = Color(0xFFADB3BC);

  // ── Utility ───────────────────────────────────────────────────────────────
  static const transparent = Colors.transparent;
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // ── Navigation & Onyxboard Layout Colors ──────────────────────────────────
  static const pageBackgroundBeige = Color(0xFFF5EFE8); // warm beige page bg
  static const borderBeige = Color(0xFFEAE0D8); // border / separator beige
  static const dividerBeige = Color(0xFFF0EDEA); // thin divider beige
  static const dividerGrey = Color(0xFFF0F0F0); // flyout bottom divider
  static const avatarBgBeige = Color(0xFFEFE8E2); // avatar background in flyout
  static const hoverBgBeige = Color(0xFFF0E8E0); // active item hover bg
  static const grey1E = Color(0xFF1E1E1E); // dark grey for main page titles
  static const grey33 = Color(0xFF333333); // dark grey for user info
  static const grey44 = Color(0xFF444444); // medium-dark grey for submenus
  static const grey55 = Color(0xFF555555); // medium grey for toggle icons
  static const grey66 = Color(0xFF666666); // medium grey for actions
  static const grey99 = Color(0xFF999999); // light-medium grey for subtitles

  // ══════════════════════════════════════════════════════════════════════════
  // 2 — SEMANTIC ALIASES  (no Color() literals — point to section 1 only)
  // ══════════════════════════════════════════════════════════════════════════

  // ── Primary ───────────────────────────────────────────────────────────────
  static const primary = main1;
  static const onPrimary = white;
  static const primaryContainer = main1;
  static const onPrimaryContainer = onPrimaryContainerRaw;
  static const inversePrimary = inversePrimaryRaw;
  static const primaryFixed = primaryFixedRaw;
  static const primaryFixedDim = primaryFixedDimRaw;
  static const onPrimaryFixed = onPrimaryFixedRaw;
  static const onPrimaryFixedVariant = onPrimaryFixedVariantRaw;

  // ── Secondary ─────────────────────────────────────────────────────────────
  static const secondary = black2;
  static const onSecondary = white;
  static const secondaryContainer = secondaryContainerRaw;
  static const onSecondaryContainer = onSecondaryContainerRaw;
  static const secondaryFixed = secondaryFixedRaw;
  static const secondaryFixedDim = secondaryFixedDimRaw;
  static const onSecondaryFixed = onSecondaryFixedRaw;
  static const onSecondaryFixedVariant = onSecondaryFixedVariantRaw;

  // ── Tertiary ──────────────────────────────────────────────────────────────
  static const tertiary = tertiaryRaw;
  static const onTertiary = white;
  static const tertiaryContainer = tertiaryContainerRaw;
  static const onTertiaryContainer = onTertiaryContainerRaw;
  static const tertiaryFixed = tertiaryFixedRaw;
  static const tertiaryFixedDim = tertiaryFixedDimRaw;
  static const onTertiaryFixed = onTertiaryFixedRaw;
  static const onTertiaryFixedVariant = onTertiaryFixedVariantRaw;

  // ── Error ─────────────────────────────────────────────────────────────────
  static const error = errorRaw;
  static const onError = white;
  static const errorContainer = errorContainerRaw;
  static const onErrorContainer = onErrorContainerRaw;

  // ── Surface ───────────────────────────────────────────────────────────────
  static const surface = surfaceRaw;
  static const surfaceDim = surfaceDimRaw;
  static const surfaceBright = surfaceRaw;
  static const surfaceContainerLowest = surfaceContainerLowestRaw;
  static const surfaceContainerLow = surfaceContainerLowRaw;
  static const surfaceContainer = surfaceContainerRaw;
  static const surfaceContainerHigh = surfaceContainerHighRaw;
  static const surfaceContainerHighest = surfaceContainerHighestRaw;
  static const surfaceVariant = surfaceContainerHighestRaw;
  static const surfaceTint = surfaceTintRaw;

  // ── On-colors ─────────────────────────────────────────────────────────────
  static const onSurface = black1;
  static const onSurfaceVariant = black2;
  static const inverseSurface = inverseSurfaceRaw;
  static const inverseOnSurface = surfaceRaw;
  static const background = surfaceRaw;
  static const onBackground = black1;

  // ── Outline ───────────────────────────────────────────────────────────────
  static const outline = outlineRaw;
  static const outlineVariant = outlineVariantRaw;

  // ── Brand extras ──────────────────────────────────────────────────────────
  static const midnight = black1;
  static const charcoal = black2;
  static const plumMuted = main2;
  static const amberPale = beg1;
  static const amberPaleAlt = amberPaleAltRaw;
  static const greenTint = green1;
  static const neutralLight = nutrailColor2;
  static const creamLighter = creamLighterRaw;
  static const termsLink = oliveAccentRaw;
  static const oliveAccent = oliveAccentRaw;

  // ── Keyboard ──────────────────────────────────────────────────────────────
  static const keyPrimaryDark = keyPrimaryDarkRaw;
  static const keySecondaryDark = keySecondaryDarkRaw;
  static const keySecondaryLight = keySecondaryLightRaw;
  static const keyLightSurface = white;
  static const keyDarkFunctional = keySecondaryDarkRaw;
  static const keyLightFunctional = keyLightFunctionalRaw;

  // ══════════════════════════════════════════════════════════════════════════
  // 3 — LEGACY ALIASES  (backwards-compat — no new usages; use section 2)
  // ══════════════════════════════════════════════════════════════════════════

  // ── Reds ──────────────────────────────────────────────────────────────────
  static const redPrimary         = main1;
  static const redPrimary22       = Color(0x225B1F3A);
  static const redPrimary75       = Color(0x755B1F3A);
  static const redPrimaryAA       = Color(0xaa5B1F3A);
  static const redPrimaryBolderBg = Color(0xFFFEE3E8);
  static const errorColor         = errorRaw;
  static const red300             = Color(0xFFFFB0BB);
  static const red400             = Color(0xFFFF6F84);
  static const red700             = Color(0xFFC14356);
  static const red900             = Color(0xFF7D212E);

  // ── Blues ─────────────────────────────────────────────────────────────────
  static const bluePrimary            = interactiveBlue;
  static const bluePrimary25          = Color(0x250F77F0);
  static const darkBlueTextSecondary  = Color(0xFF3D3C4B);
  static const lightBlueSecondary     = Color(0xFFE0EBFF);

  // ── Whites / Backgrounds ──────────────────────────────────────────────────
  static const whiteBgColor          = white;
  static const whiteTextColor        = white;
  static const whiteBlueBgColor      = surfaceContainerLowRaw;
  static const whiteRedBgColor       = Color(0xFFFEFAF1);
  static const lightBlueGreyBgColor  = surfaceContainerLowRaw;
  static const lightMintGreenBgColor = Color(0xFFF0FFF2);
  static const lightOffWhite         = Color(0xFFB6B3B0);

  // ── Greys ─────────────────────────────────────────────────────────────────
  static const grey               = Color(0xFF1F1F1F);
  static const grey1              = nutrailColor1;
  static const grey100            = Color(0xBCFFFFFF);
  static const grey200            = Color(0xFFEBEBEB);
  static const grey400            = Color(0xFFC2C2C2);
  static const greyTextColor      = nutrailColor1;
  static const greyTextSecondary  = Color(0xFFA0A0A0);
  static const lightGreyBgSecondary   = nutrailColor2;
  static const lightGreyTextSecondary = Color(0xFFB4B4B4);

  // ── Off-whites ────────────────────────────────────────────────────────────
  static const offWhite    = Color(0xFFCEC7BF);
  static const offWhite200 = Color(0xFFFBF7F2);
  static const offWhite300 = Color(0xFFE5DFD8);
  static const offWhite400 = Color(0xFFCEC7BF);
  static const offWhite500 = Color(0xFFB7B0A7);
  static const offWhite600 = Color(0xFFA1998F);
  static const offWhite700 = Color(0xFF8A8279);
  static const offWhite800 = Color(0xFF736C63);

  // ── Yellows / Oranges ─────────────────────────────────────────────────────
  static const yellow         = Color(0xFFF1B24A);
  static const yellow300      = Color(0xFFFFDA9E);
  static const yellow1000     = Color(0xFF472E05);
  static const yellowColor    = Color(0xFFFFE143);
  static const orangeSecondary = amberPale;

  // ── Greens ────────────────────────────────────────────────────────────────
  static const greenBg = green2;

  // ── Text ──────────────────────────────────────────────────────────────────
  static const darkTextColor           = black1;
  static const blackTextSecondary      = black1;
  static const blackTextLightSecondary = nutrailColor1;

  // ── Purples / Pinks ───────────────────────────────────────────────────────
  static const mauva         = Color(0xFF645577);
  static const paleVioletRed = Color(0xFFBA5874);
  static const thistle       = Color(0xFFA1859C);

  // ── Misc ──────────────────────────────────────────────────────────────────
  static const beige1       = beg1;
  static const dividerColor = Color(0xFFE9E9E9);
}

class GradientManager {
  static const List<double> startNowStops = [0.1, 0.6, 0.7];
}

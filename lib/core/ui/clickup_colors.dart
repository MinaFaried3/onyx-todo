import 'package:flutter/material.dart';

/// Modern ClickUp & Onyx Design System color tokens and surfaces.
abstract final class ClickUpColors {
  // ─── Brand Colors ────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF7B68EE); // ClickUp vibrant violet
  static const Color primaryDark = Color(0xFF5F55EE); // ClickUp deep indigo
  static const Color primaryLight = Color(0xFFEEEBFF); // Soft violet tint
  static const Color accentCyan = Color(0xFF00D2D3); // ClickUp Cyan
  static const Color accentPurple = Color(0xFFA855F7); // Accent purple

  // ─── Semantic Modern Feedback Colors (Replaces raw Flutter Colors.*) ─────────
  static const Color danger = Color(0xFFF43F5E); // Modern Rose/Red
  static const Color dangerBg = Color(0xFF4C0519); // Dark container
  static const Color dangerLight = Color(0xFFFFF1F2); // Light container

  static const Color success = Color(0xFF10B981); // Modern Emerald Green
  static const Color successBg = Color(0xFF064E3B); // Dark container
  static const Color successLight = Color(0xFFECFDF5); // Light container

  static const Color warning = Color(0xFFF59E0B); // Modern Amber
  static const Color warningBg = Color(0xFF78350F); // Dark container
  static const Color warningLight = Color(0xFFFFFBEB); // Light container

  static const Color info = Color(0xFF0EA5E9); // Modern Sky Blue
  static const Color infoBg = Color(0xFF0C4A6E); // Dark container
  static const Color infoLight = Color(0xFFF0F9FF); // Light container

  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  // ─── Neutral Palette ─────────────────────────────────────────────────────────
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF4F4F5);
  static const Color neutral200 = Color(0xFFE4E4E7);
  static const Color neutral300 = Color(0xFFD4D4D8);
  static const Color neutral400 = Color(0xFFA1A1AA);
  static const Color neutral500 = Color(0xFF71717A);
  static const Color neutral600 = Color(0xFF52525B);
  static const Color neutral700 = Color(0xFF3F3F46);
  static const Color neutral800 = Color(0xFF27272A);
  static const Color neutral900 = Color(0xFF18181B);

  // ─── Dark Theme Surfaces ─────────────────────────────────────────────────────
  static const Color darkSidebar = Color(0xFF1E1F21); // Navigation sidebar
  static const Color darkBackground = Color(0xFF252628); // Main workspace canvas
  static const Color darkCard = Color(0xFF2D2E30); // Task cards & panels
  static const Color darkCardHover = Color(0xFF343538); // Hover state
  static const Color darkBorder = Color(0xFF3C3E41); // Dividers and borders
  static const Color darkTextPrimary = Color(0xFFF0F1F3); // Main text
  static const Color darkTextSecondary = Color(0xFF9EA3AE); // Subdued text / labels

  // ─── Light Theme Surfaces ────────────────────────────────────────────────────
  static const Color lightSidebar = Color(0xFFF9FAFB);
  static const Color lightBackground = Color(0xFFF3F4F6);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardHover = Color(0xFFF8F9FB);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // ─── ClickUp Status Colors ───────────────────────────────────────────────────
  static const Color statusOpen = Color(0xFF94A3B8); // Slate 400
  static const Color statusInProgress = Color(0xFF38BDF8); // Sky 400
  static const Color statusBackendSolved = Color(0xFFA855F7); // Purple 500
  static const Color statusFrontendSolved = Color(0xFF14B8A6); // Teal 500
  static const Color statusQaTesting = Color(0xFFF59E0B); // Amber 500
  static const Color statusClosed = Color(0xFF10B981); // Emerald 500

  // ─── ClickUp Priority Colors ─────────────────────────────────────────────────
  static const Color priorityUrgent = Color(0xFFF43F5E); // Rose 500
  static const Color priorityHigh = Color(0xFFFB923C); // Orange 400
  static const Color priorityMedium = Color(0xFF38BDF8); // Sky 400
  static const Color priorityLow = Color(0xFF94A3B8); // Slate 400

  // ─── Syncfusion Charts Palette ───────────────────────────────────────────────
  static const List<Color> chartPalette = [
    primary,
    accentCyan,
    success,
    warning,
    danger,
    accentPurple,
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFFF97316), // Orange
    Color(0xFF6366F1), // Indigo
    Color(0xFF06B6D4), // Cyan
    Color(0xFF84CC16), // Lime
  ];
}

import 'package:flutter/material.dart';

/// Modern Onyx ERP Design System color tokens, semantic palettes, and surfaces.
abstract final class OnyxColors {
  // ─── Brand Colors ────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF7B68EE); // Onyx vibrant violet
  static const Color primaryDark = Color(0xFF5F55EE); // Onyx deep indigo
  static const Color primaryLight = Color(0xFFEEEBFF); // Soft violet tint
  static const Color accentCyan = Color(0xFF00D2D3); // Onyx Cyan
  static const Color accentPurple = Color(0xFFA855F7); // Accent purple
  static const Color teal = Color(0xFF0D9488); // Modern Teal
  static const Color purple = Color(0xFF9333EA); // Modern Purple

  // ─── Semantic Modern Feedback Colors ─────────────────────────────────────────
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
  static const Color darkSurface = Color(0xFF26272B); // Surface / elevated panels
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

  // ─── Task Status Colors ──────────────────────────────────────────────────────
  static const Color statusOpen = Color(0xFF6B7280); // Gray
  static const Color statusInProgress = Color(0xFF3B82F6); // Blue
  static const Color statusBackendSolved = Color(0xFF10B981); // Emerald
  static const Color statusFrontendSolved = Color(0xFF06B6D4); // Cyan
  static const Color statusQaTesting = Color(0xFFF59E0B); // Amber
  static const Color statusClosed = Color(0xFF10B981); // Emerald green

  // ─── Priority Colors ─────────────────────────────────────────────────────────
  static const Color priorityUrgent = Color(0xFFEF4444); // Bright Red
  static const Color priorityHigh = Color(0xFFF97316); // Bright Orange
  static const Color priorityMedium = Color(0xFF3B82F6); // Blue
  static const Color priorityLow = Color(0xFF9CA3AF); // Gray

  // ─── ClickUp Assignee Avatar Palette ──────────────────────────────────────
  static const Color avatarBlue = Color(0xFF3B82F6);
  static const Color avatarPurple = Color(0xFF8B5CF6);
  static const Color avatarGreen = Color(0xFF10B981);
  static const Color avatarOrange = Color(0xFFF97316);
  static const Color avatarTeal = Color(0xFF14B8A6);
  static const Color avatarPink = Color(0xFFEC4899);
  static const Color avatarIndigo = Color(0xFF6366F1);
  static const Color avatarAmber = Color(0xFFF59E0B);

  static const List<Color> avatarPalette = [
    avatarBlue,
    avatarPurple,
    avatarGreen,
    avatarOrange,
    avatarTeal,
    avatarPink,
    avatarIndigo,
    avatarAmber,
  ];

  static const List<Color> chartPalette = avatarPalette;

  static Color getAvatarColor(String seed) {
    if (seed.isEmpty) return avatarBlue;
    final hash = seed.codeUnits.fold<int>(0, (sum, c) => sum + c);
    return avatarPalette[hash % avatarPalette.length];
  }
}

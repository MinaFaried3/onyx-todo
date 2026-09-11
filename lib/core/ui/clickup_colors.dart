import 'package:flutter/material.dart';

/// ClickUp Design System color tokens and surfaces.
abstract final class ClickUpColors {
  // ─── Brand Colors ────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF7B68EE); // ClickUp vibrant violet
  static const Color primaryDark = Color(0xFF5F55EE); // ClickUp deep indigo
  static const Color primaryLight = Color(0xFFEEEBFF); // Soft violet tint
  static const Color accentCyan = Color(0xFF00D2D3); // ClickUp Cyan

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
  static const Color statusOpen = Color(0xFF87909E);
  static const Color statusInProgress = Color(0xFF2980B9);
  static const Color statusBackendSolved = Color(0xFF8E44AD);
  static const Color statusFrontendSolved = Color(0xFF16A085);
  static const Color statusQaTesting = Color(0xFFF39C12);
  static const Color statusClosed = Color(0xFF27AE60);

  // ─── ClickUp Priority Colors ─────────────────────────────────────────────────
  static const Color priorityUrgent = Color(0xFFE74C3C);
  static const Color priorityHigh = Color(0xFFE67E22);
  static const Color priorityMedium = Color(0xFF3498DB);
  static const Color priorityLow = Color(0xFF95A5A6);
}

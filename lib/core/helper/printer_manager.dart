import 'package:flutter/foundation.dart';
import 'package:onyx_todo/core/config/mode/app_mode.dart';

/// Log levels
enum LogLevel { debug, info, warning, error }

enum ConsoleColor {
  reset('\u001b[0m'),
  black('\u001b[30m'),
  red('\u001b[31m'),
  green('\u001b[32m'),
  yellow('\u001b[33m'),
  blue('\u001b[34m'),
  magenta('\u001b[35m'),
  cyan('\u001b[36m'),
  white('\u001b[37m'),
  brightBlack('\u001b[90m'),
  brightRed('\u001b[91m'),
  brightGreen('\u001b[92m'),
  brightYellow('\u001b[93m'),
  brightBlue('\u001b[94m'),
  brightMagenta('\u001b[95m'),
  brightCyan('\u001b[96m'),
  brightWhite('\u001b[97m'),
  blackBg('\u001b[40m'),
  redBg('\u001b[41m'),
  greenBg('\u001b[42m'),
  yellowBg('\u001b[43m'),
  blueBg('\u001b[44m'),
  magentaBg('\u001b[45m'),
  cyanBg('\u001b[46m'),
  whiteBg('\u001b[47m'),
  brightBlackBg('\u001b[100m'),
  brightRedBg('\u001b[101m'),
  brightGreenBg('\u001b[102m'),
  brightYellowBg('\u001b[103m'),
  brightBlueBg('\u001b[104m'),
  brightMagentaBg('\u001b[105m'),
  brightCyanBg('\u001b[106m'),
  brightWhiteBg('\u001b[107m');

  final String colorCode;

  const ConsoleColor(this.colorCode);
}

class _CallerInfo {
  final String? location;
  final String? methodName;

  const _CallerInfo({this.location, this.methodName});
}

class Printer {
  static final _fileLineRegex = RegExp(r'\((.*?):(\d+):\d+\)');
  static final _methodRegex = RegExp(r'(\w+(?:\.\w+)*)\s*\(');

  static const _separator = '────────────────────────────────';
  static const _shortSeparator = '────';

  static void log(
    dynamic object, {
    ConsoleColor color = ConsoleColor.magenta,
    bool useLog = false,
  }) {
    if (AppMode.prodReleaseMode) return;

    final colorCode = color.colorCode;

    String printedString =
        '$colorCode${object.toString()}${ConsoleColor.reset.colorCode}';

    if (useLog) {
      log(printedString);
      return;
    }

    debugPrint(printedString);
  }

  static void print(
    dynamic object, {
    ConsoleColor color = ConsoleColor.magenta,
    bool useLog = false,
    bool showCallerInfo = true,
  }) {
    if (AppMode.prodReleaseMode) return;

    final buffer = StringBuffer();
    final reset = ConsoleColor.reset.colorCode;
    final dim = ConsoleColor.brightBlack.colorCode;
    final methodColor = ConsoleColor.brightCyan.colorCode;

    if (showCallerInfo) {
      final caller = _getCallerInfo();

      buffer.writeln('$dim$_separator$reset');
      if (caller.location != null) {
        buffer.writeln('$dim📍 ${caller.location}$reset');
      }
      if (caller.methodName != null) {
        buffer.writeln('$methodColor(${caller.methodName})$reset');
      }
      buffer.writeln('$dim$_shortSeparator$reset');
    }

    buffer.writeln('${color.colorCode}${_formatObject(object)}$reset');
    buffer.write('$dim$_separator$reset');

    final printedString = buffer.toString();

    if (useLog) {
      log(printedString);
      return;
    }

    debugPrint(printedString);
  }

  static void printHint(dynamic object) {
    print(object, color: ConsoleColor.brightBlack, showCallerInfo: false);
  }

  static void logger(
    dynamic message, {
    LogLevel level = LogLevel.debug,
    String? tag,
  }) {
    final caller = _getCallerInfo();
    final emoji = _emoji(level);
    final label = level.name.toUpperCase();
    final color = _color(level);
    final reset = ConsoleColor.reset.colorCode;
    final dim = ConsoleColor.brightBlack.colorCode;
    final methodColor = ConsoleColor.brightCyan.colorCode;

    final buffer = StringBuffer();
    buffer.writeln('$dim$_separator$reset');
    buffer.write('$emoji [$label]');
    if (tag != null) buffer.write('[$tag]');
    buffer.writeln();

    if (caller.location != null) {
      buffer.writeln('$dim📍 ${caller.location}$reset');
    }
    if (caller.methodName != null) {
      buffer.writeln('$methodColor(${caller.methodName})$reset');
    }
    buffer.writeln('$dim$_shortSeparator$reset');

    buffer.writeln(_formatObject(message));
    buffer.write('$dim$_separator$reset');

    print(buffer.toString(), color: color, showCallerInfo: false);
  }

  static _CallerInfo _getCallerInfo() {
    final frames = StackTrace.current.toString().split('\n');

    String? location;
    String? methodName;

    for (var i = 2; i < frames.length && i < 6; i++) {
      final frame = frames[i];
      final fileMatch = _fileLineRegex.firstMatch(frame);
      if (fileMatch != null) {
        final file = fileMatch.group(1) ?? '';
        final line = fileMatch.group(2) ?? '?';
        if (!file.contains('printer_manager.dart')) {
          location = '$file:$line';
          final methodMatch = _methodRegex.firstMatch(frame);
          if (methodMatch != null) {
            methodName = methodMatch.group(1);
          }
          break;
        }
      }
    }

    return _CallerInfo(location: location, methodName: methodName);
  }

  static String _formatObject(dynamic object, {int indent = 0}) {
    if (object is Map) return _formatMap(object, indent: indent);
    if (object is List) return _formatList(object, indent: indent);
    return object.toString();
  }

  static String _formatMap(Map map, {int indent = 0}) {
    if (map.isEmpty) return '{}';

    final reset = ConsoleColor.reset.colorCode;
    final keyColor = ConsoleColor.cyan.colorCode;
    final nullColor = ConsoleColor.brightBlack.colorCode;
    final boolColor = ConsoleColor.magenta.colorCode;
    final numColor = ConsoleColor.green.colorCode;
    final strColor = ConsoleColor.yellow.colorCode;
    final spaces = '  ' * indent;
    final innerSpaces = '  ' * (indent + 1);
    final entries = map.entries.toList();
    final buffer = StringBuffer('{\n');

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final key = entry.key;
      final value = entry.value;

      buffer.write('$innerSpaces$keyColor"$key"$reset: ');

      if (value is Map) {
        buffer.write(_formatMap(value, indent: indent + 1));
      } else if (value is List) {
        buffer.write(_formatList(value, indent: indent + 1));
      } else {
        buffer.write(
          _formatPrimitive(value, strColor, numColor, boolColor, nullColor),
        );
      }

      if (i < entries.length - 1) buffer.write(',');
      buffer.write('\n');
    }

    buffer.write('$spaces}');
    return buffer.toString();
  }

  static String _formatList(List list, {int indent = 0}) {
    if (list.isEmpty) return '[]';

    final nullColor = ConsoleColor.brightBlack.colorCode;
    final boolColor = ConsoleColor.magenta.colorCode;
    final numColor = ConsoleColor.green.colorCode;
    final strColor = ConsoleColor.yellow.colorCode;
    final spaces = '  ' * indent;
    final innerSpaces = '  ' * (indent + 1);
    final buffer = StringBuffer('[\n');

    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      buffer.write(innerSpaces);

      if (item is Map) {
        buffer.write(_formatMap(item, indent: indent + 1));
      } else if (item is List) {
        buffer.write(_formatList(item, indent: indent + 1));
      } else {
        buffer.write(
          _formatPrimitive(item, strColor, numColor, boolColor, nullColor),
        );
      }

      if (i < list.length - 1) buffer.write(',');
      buffer.write('\n');
    }

    buffer.write('$spaces]');
    return buffer.toString();
  }

  static String _formatPrimitive(
    dynamic value,
    String strColor,
    String numColor,
    String boolColor,
    String nullColor,
  ) {
    final reset = ConsoleColor.reset.colorCode;
    if (value == null) return '$nullColor null $reset';
    if (value is String) return '$strColor"$value"$reset';
    if (value is num) return '$numColor$value$reset';
    if (value is bool) return '$boolColor$value$reset';
    return '$strColor${value.toString()}$reset';
  }

  static String _emoji(LogLevel level) => switch (level) {
    LogLevel.debug => '🐛',
    LogLevel.info => 'ℹ️',
    LogLevel.warning => '⚠️',
    LogLevel.error => '❌',
  };

  static ConsoleColor _color(LogLevel level) => switch (level) {
    LogLevel.debug => ConsoleColor.cyan,
    LogLevel.info => ConsoleColor.green,
    LogLevel.warning => ConsoleColor.yellow,
    LogLevel.error => ConsoleColor.red,
  };
}

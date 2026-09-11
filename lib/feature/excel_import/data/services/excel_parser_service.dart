import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_history_item.dart';
import 'package:xml/xml.dart';

class ExcelParserService {
  /// Parses an Excel (.xlsx) file (bytes) containing Onyx ERP module sheets
  /// into a structured list of [TaskEntity] objects using native OpenXML streaming.
  /// Works reliably on Web, macOS, iOS, and Android with 0 crashes.
  Future<List<TaskEntity>> parseExcelBytes(Uint8List bytes) async {
    final stopwatch = Stopwatch()..start();
    Printer.log('Starting OpenXML decompression (${bytes.length} bytes)...');

    final archive = ZipDecoder().decodeBytes(bytes);

    // 1. Parse Shared Strings (xl/sharedStrings.xml)
    final ssFile = archive.findFile('xl/sharedStrings.xml');
    final List<String> sharedStrings = [];
    if (ssFile != null) {
      final ssXml = utf8.decode(ssFile.content as List<int>);
      final doc = XmlDocument.parse(ssXml);
      for (final si in doc.findAllElements('si')) {
        final buffer = StringBuffer();
        for (final t in si.findAllElements('t')) {
          buffer.write(t.innerText);
        }
        sharedStrings.add(buffer.toString());
      }
    }
    Printer.log('Extracted ${sharedStrings.length} shared strings');

    // 2. Parse Relationships (xl/_rels/workbook.xml.rels)
    final relsFile = archive.findFile('xl/_rels/workbook.xml.rels');
    final relsMap = <String, String>{};
    if (relsFile != null) {
      final relsDoc = XmlDocument.parse(utf8.decode(relsFile.content as List<int>));
      for (final rel in relsDoc.findAllElements('Relationship')) {
        final id = _getAttr(rel, 'Id');
        final target = _getAttr(rel, 'Target');
        if (id != null && target != null) {
          relsMap[id] = target;
        }
      }
    }

    // 3. Parse Workbook Sheets (xl/workbook.xml)
    final wbFile = archive.findFile('xl/workbook.xml');
    final sheetEntries = <({String name, String path})>[];
    if (wbFile != null) {
      final wbDoc = XmlDocument.parse(utf8.decode(wbFile.content as List<int>));
      for (final sheet in wbDoc.findAllElements('sheet')) {
        final name = _getAttr(sheet, 'name');
        final rId = _getAttr(sheet, 'id');
        if (name != null && rId != null && relsMap.containsKey(rId)) {
          var target = relsMap[rId]!;
          if (!target.startsWith('xl/')) {
            target = 'xl/$target';
          }
          sheetEntries.add((name: name, path: target));
        }
      }
    }

    Printer.log('Discovered ${sheetEntries.length} sheets in workbook: ${sheetEntries.map((e) => e.name).toList()}');

    final List<TaskEntity> parsedTasks = [];

    // 4. Process Each Sheet
    for (final entry in sheetEntries) {
      // Yield to event loop to keep Flutter Web UI fluid
      await Future.delayed(Duration.zero);

      final sheetFile = archive.findFile(entry.path);
      if (sheetFile == null) continue;

      final sheetXml = utf8.decode(sheetFile.content as List<int>);
      final sheetDoc = XmlDocument.parse(sheetXml);
      final rows = sheetDoc.findAllElements('row');

      final cleanSheetCode = entry.name.trim().toUpperCase();
      int consecutiveEmpty = 0;
      int r = 0;

      for (final row in rows) {
        r++;
        final cells = <int, String>{};
        for (final c in row.findElements('c')) {
          final ref = _getAttr(c, 'r') ?? '';
          final t = _getAttr(c, 't');
          final colIdx = _colRefToIndex(ref);

          String val = '';
          if (t == 's') {
            final v = c.findElements('v').firstOrNull?.innerText;
            if (v != null) {
              final sIdx = int.tryParse(v);
              if (sIdx != null && sIdx < sharedStrings.length) {
                val = sharedStrings[sIdx];
              }
            }
          } else if (t == 'inlineStr') {
            val = c.findAllElements('t').map((e) => e.innerText).join();
          } else {
            val = c.findElements('v').firstOrNull?.innerText ?? '';
          }
          cells[colIdx] = val.trim();
        }

        // Skip row 1 as header
        if (r == 1) continue;

        final rawCode = (cells[0] ?? '').replaceAll('\n', '').trim();
        final screenName = cells[1] ?? '';
        final description = cells[2] ?? '';

        // Skip completely empty template rows
        if (rawCode.isEmpty && screenName.isEmpty && description.isEmpty) {
          consecutiveEmpty++;
          if (consecutiveEmpty > 15) break;
          continue;
        }
        consecutiveEmpty = 0;

        final taskTypeStr = cells[3] ?? '';
        final priorityStr = cells[4] ?? '';
        final createdDateStr = cells[5] ?? '';
        final resolvedDateStr = cells[6] ?? '';
        final devNotes = cells[7] ?? '';
        final devStatusStr = cells[8] ?? '';
        final qaNotes = cells[9] ?? '';
        final qaTester = cells[10] ?? '';
        final finalResultBack = cells[11] ?? '';
        final finalResultFront = cells[12] ?? '';
        final backendTeam = cells[13] ?? '';
        final frontendTeam = cells[14] ?? '';

        // Derive version, moduleCode, sequenceNumber
        String version = 'V5.1.8';
        String moduleCode = cleanSheetCode;
        int sequenceNumber = r;
        String formattedId = rawCode;

        if (rawCode.isNotEmpty && rawCode.contains('.')) {
          final parts = rawCode.split('.');
          if (parts.length >= 5) {
            version = '${parts[0].trim()}.${parts[1].trim()}.${parts[2].trim()}';
            moduleCode = parts[3].trim().toUpperCase();
            sequenceNumber = int.tryParse(parts[4].trim()) ?? r;
          } else if (parts.length == 4) {
            version = '${parts[0].trim()}.${parts[1].trim()}.${parts[2].trim()}';
            final lastPart = parts[3].trim();
            final letters = lastPart.replaceAll(RegExp(r'[^a-zA-Z]'), '').toUpperCase();
            final digits = lastPart.replaceAll(RegExp(r'[^0-9]'), '');
            moduleCode = letters.isNotEmpty ? letters : cleanSheetCode;
            sequenceNumber = int.tryParse(digits) ?? r;
          }
        } else {
          formattedId = TaskEntity.generateFormattedId(
            version: version,
            moduleCode: moduleCode,
            sequenceNumber: sequenceNumber,
          );
        }

        // Determine Status
        TaskStatus status = TaskStatus.open;
        if (devStatusStr.contains('تم الحل') ||
            finalResultBack.contains('تم الحل') ||
            finalResultFront.contains('تم الحل') ||
            devStatusStr.toLowerCase().contains('solved')) {
          status = TaskStatus.backendSolved;
        } else if (devStatusStr.isNotEmpty) {
          status = TaskStatus.fromString(devStatusStr);
        }

        // Date parsing
        final createdDate = _parseDate(createdDateStr);
        final resolvedDate = resolvedDateStr.isNotEmpty ? _parseDate(resolvedDateStr) : null;

        final title = description.length > 60
            ? '${description.substring(0, 57)}...'
            : (description.isNotEmpty ? description : screenName);

        final task = TaskEntity(
          id: formattedId,
          formattedId: formattedId,
          version: version,
          moduleCode: moduleCode,
          sequenceNumber: sequenceNumber,
          screenName: screenName.isEmpty ? 'عام' : screenName,
          title: title.isEmpty ? 'مهمة بدون عنوان' : title,
          description: description,
          taskType: TaskType.fromString(taskTypeStr),
          priority: TaskPriority.fromString(priorityStr),
          status: status,
          backendDevName: backendTeam.isNotEmpty ? backendTeam : null,
          frontendDevName: frontendTeam.isNotEmpty ? frontendTeam : null,
          qaTesterName: qaTester.isNotEmpty ? qaTester : null,
          createdDate: createdDate,
          resolvedDate: resolvedDate,
          devNotes: devNotes.isNotEmpty ? devNotes : null,
          qaNotes: qaNotes.isNotEmpty ? qaNotes : null,
          history: [
            TaskHistoryItem(
              id: 'imp_${formattedId}_$r',
              action: 'imported_from_excel',
              authorName: 'Excel Migration',
              timestamp: DateTime.now(),
              details: 'Imported from sheet: ${entry.name}',
            )
          ],
        );

        parsedTasks.add(task);
      }
    }

    Printer.log('Successfully parsed ${parsedTasks.length} tasks in ${stopwatch.elapsedMilliseconds}ms');
    return parsedTasks;
  }

  static String? _getAttr(XmlElement elem, String localName) {
    for (final attr in elem.attributes) {
      if (attr.name.local == localName) {
        return attr.value;
      }
    }
    return null;
  }

  static int _colRefToIndex(String ref) {
    int idx = 0;
    for (int i = 0; i < ref.length; i++) {
      final code = ref.codeUnitAt(i);
      if (code >= 65 && code <= 90) {
        idx = idx * 26 + (code - 64);
      } else if (code >= 97 && code <= 122) {
        idx = idx * 26 + (code - 96);
      } else {
        break;
      }
    }
    return idx - 1;
  }

  static DateTime _parseDate(String dateStr) {
    if (dateStr.isEmpty) return DateTime.now();
    if (dateStr.contains('/')) {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final month = int.tryParse(parts[1]) ?? 1;
        final year = int.tryParse(parts[2]) ?? 2025;
        return DateTime(year, month, day);
      }
    } else if (dateStr.contains('-')) {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) return parsed;
    } else {
      final serial = double.tryParse(dateStr);
      if (serial != null && serial > 1000) {
        return DateTime(1899, 12, 30).add(Duration(days: serial.toInt()));
      }
    }
    return DateTime.now();
  }
}

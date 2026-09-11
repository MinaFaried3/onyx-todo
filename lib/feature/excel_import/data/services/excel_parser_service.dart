import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_history_item.dart';

class ExcelParserService {
  /// Parses an Excel file (bytes) containing Onyx ERP module sheets
  /// into a structured list of [TaskEntity] objects.
  List<TaskEntity> parseExcelBytes(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    final List<TaskEntity> parsedTasks = [];

    Printer.logger('Excel sheets found: ${excel.tables.keys.toList()}');

    for (final sheetName in excel.tables.keys) {
      final table = excel.tables[sheetName];
      if (table == null || table.rows.isEmpty) continue;

      final cleanSheetCode = sheetName.trim().toUpperCase();

      // Find header row (usually row 0)
      int headerRowIndex = 0;
      for (int r = 0; r < table.rows.length && r < 5; r++) {
        final row = table.rows[r];
        final rowStr = row.map((cell) => cell?.value?.toString() ?? '').join(' ');
        if (rowStr.contains('كود') || rowStr.contains('الشاشة') || rowStr.contains('وصف')) {
          headerRowIndex = r;
          break;
        }
      }

      // Process rows starting after header
      for (int r = headerRowIndex + 1; r < table.rows.length; r++) {
        final row = table.rows[r];
        if (row.isEmpty) continue;

        String getCellVal(int colIndex) {
          if (colIndex >= row.length) return '';
          final cell = row[colIndex];
          if (cell == null || cell.value == null) return '';
          return cell.value.toString().trim();
        }

        final rawCode = getCellVal(0);
        final screenName = getCellVal(1);
        final description = getCellVal(2);

        // Skip completely empty rows
        if (rawCode.isEmpty && screenName.isEmpty && description.isEmpty) {
          continue;
        }

        final taskTypeStr = getCellVal(3);
        final priorityStr = getCellVal(4);
        final createdDateStr = getCellVal(5);
        final resolvedDateStr = getCellVal(6);
        final devNotes = getCellVal(7);
        final devStatusStr = getCellVal(8);
        final qaNotes = getCellVal(9);
        final qaTester = getCellVal(10);
        final finalResultBack = getCellVal(11);
        final finalResultFront = getCellVal(12);
        final backendTeam = getCellVal(13);
        final frontendTeam = getCellVal(14);

        // Derive version, moduleCode, sequenceNumber from code or sheet
        String version = 'V5.1.8';
        String moduleCode = cleanSheetCode;
        int sequenceNumber = r;

        String formattedId = rawCode;
        if (rawCode.isNotEmpty && rawCode.contains('.')) {
          final parts = rawCode.split('.');
          if (parts.length >= 4) {
            // e.g. V5.1.8.ADM.000001
            version = '${parts[0]}.${parts[1]}.${parts[2]}';
            moduleCode = parts[3].toUpperCase();
            sequenceNumber = int.tryParse(parts[4]) ?? r;
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
            finalResultFront.contains('تم الحل')) {
          status = TaskStatus.backendSolved;
        }

        // Date parsing
        DateTime createdDate = DateTime.now();
        if (createdDateStr.isNotEmpty) {
          if (createdDateStr.contains('/')) {
            final parts = createdDateStr.split('/');
            if (parts.length == 3) {
              final day = int.tryParse(parts[0]) ?? 1;
              final month = int.tryParse(parts[1]) ?? 1;
              final year = int.tryParse(parts[2]) ?? 2025;
              createdDate = DateTime(year, month, day);
            }
          } else if (double.tryParse(createdDateStr) != null) {
            // Excel serial date number
            final serial = double.parse(createdDateStr);
            createdDate = DateTime(1899, 12, 30).add(Duration(days: serial.toInt()));
          }
        }

        DateTime? resolvedDate;
        if (resolvedDateStr.isNotEmpty) {
          resolvedDate = DateTime.tryParse(resolvedDateStr);
        }

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
              details: 'Imported from sheet: $sheetName',
            )
          ],
        );

        parsedTasks.add(task);
      }
    }

    Printer.logger('Successfully parsed ${parsedTasks.length} tasks from Excel');
    return parsedTasks;
  }
}

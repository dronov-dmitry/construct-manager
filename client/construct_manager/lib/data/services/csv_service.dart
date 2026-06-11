import 'dart:convert';

import '../../core/network/supabase_client.dart';
import '../models/budget.dart';
import '../models/construction.dart';
import '../models/delay.dart';
import '../models/schedule.dart';

class CsvService {
  Future<String> exportToCsv(String constructionUid) async {
    final data = await SupabaseClientManager.instance.client
        .from('constructions')
        .select()
        .eq('uid', constructionUid)
        .maybeSingle();
    if (data == null) throw Exception('Project not found');
    final c = Construction.fromJson(data);

    final buffer = StringBuffer();

    buffer.writeln('# Construction');
    buffer.writeln('uid,title,address,type,stage,map_address,information,budget,owner_uid,responsibles');
    buffer.writeln(_csvRow([
      c.constructionUid,
      c.title,
      c.address,
      c.type,
      c.stage,
      c.mapAddress,
      c.information,
      c.budget?.toStringAsFixed(2) ?? '',
      c.ownerUid,
      _jsonField(c.responsibles.map((e) => e.toJson()).toList()),
    ]));

    final budgetsData = await SupabaseClientManager.instance.client
        .from('budgets')
        .select()
        .eq('construction_uid', constructionUid);
    final budgets = (budgetsData as List<dynamic>)
        .map((e) => Budget.fromJson(e as Map<String, dynamic>)).toList();
    if (budgets.isNotEmpty) {
      buffer.writeln('# Budgets');
      buffer.writeln('uid,construction_uid,title,description,value');
      for (final b in budgets) {
        buffer.writeln(_csvRow([b.budgetUid, b.constructionUid, b.title, b.desc, b.value.toStringAsFixed(2)]));
      }
    }

    final schedulesData = await SupabaseClientManager.instance.client
        .from('schedules')
        .select()
        .eq('construction_uid', constructionUid);
    final schedules = (schedulesData as List<dynamic>)
        .map((e) => Schedule.fromJson(e as Map<String, dynamic>)).toList();
    if (schedules.isNotEmpty) {
      buffer.writeln('# Schedules');
      buffer.writeln('uid,construction_uid,title,start_date,deadline,state,finish_date');
      for (final s in schedules) {
        buffer.writeln(_csvRow([s.scheduleUid, s.constructionUid, s.title, s.startDate ?? '', s.deadline, s.state, s.finishDate ?? '']));
      }

      for (final s in schedules) {
        final delaysData = await SupabaseClientManager.instance.client
            .from('delays')
            .select()
            .eq('construction_uid', constructionUid)
            .eq('schedule_uid', s.scheduleUid);
        final delays = (delaysData as List<dynamic>)
            .map((e) => Delay.fromJson(e as Map<String, dynamic>)).toList();
        if (delays.isNotEmpty) {
          buffer.writeln('# Delays');
          buffer.writeln('uid,schedule_uid,title,reason,is_excusable,is_compensable,is_concurrent,is_critical,days,additional_info');
          for (final d in delays) {
            buffer.writeln(_csvRow([
              d.delayUid ?? '', d.scheduleUid, d.title, d.reason,
              d.isExcusable.toString(), d.isCompensable.toString(),
              d.isConcurrent.toString(), d.isCritical.toString(),
              d.days.toString(), d.additionalInfo,
            ]));
          }
        }
      }
    }

    return buffer.toString();
  }

  Future<int> importFromCsv(String csvContent) async {
    int imported = 0;

    for (final section in _parseSections(csvContent)) {
      if (section.rows.isEmpty) continue;

      switch (section.type) {
        case 'Construction':
          await _importConstruction(section);
          imported += section.rows.length;
          break;
        case 'Budgets':
          await _importBudgets(section);
          imported += section.rows.length;
          break;
        case 'Schedules':
          await _importSchedules(section);
          imported += section.rows.length;
          break;
        case 'Delays':
          await _importDelays(section);
          imported += section.rows.length;
          break;
      }
    }

    return imported;
  }

  Future<void> _importConstruction(_CsvSection section) async {
    final header = section.header;
    for (final row in section.rows) {
      final map = <String, dynamic>{};
      for (var i = 0; i < header.length && i < row.length; i++) {
        map[header[i]] = row[i];
      }
      map['budget'] = map['budget'] != null && (map['budget'] as String).isNotEmpty
          ? double.tryParse(map['budget'] as String)
          : null;
      if (map['responsibles'] is String && (map['responsibles'] as String).isNotEmpty) {
        try {
          map['responsibles'] = _parseJsonArray(map['responsibles'] as String);
        } catch (_) {
          map['responsibles'] = [];
        }
      } else {
        map['responsibles'] = [];
      }
      if (map['uid'] == null || (map['uid'] as String).isEmpty) continue;
      await SupabaseClientManager.instance.client
          .from('constructions')
          .upsert(map);
    }
  }

  Future<void> _importBudgets(_CsvSection section) async {
    final header = section.header;
    for (final row in section.rows) {
      final map = <String, dynamic>{};
      for (var i = 0; i < header.length && i < row.length; i++) {
        final val = row[i];
        if (header[i] == 'value') {
          map['value'] = double.tryParse(val) ?? 0;
        } else {
          map[header[i]] = val;
        }
      }
      if (map['uid'] == null || (map['uid'] as String).isEmpty) continue;
      await SupabaseClientManager.instance.client
          .from('budgets')
          .upsert(map);
    }
  }

  Future<void> _importSchedules(_CsvSection section) async {
    final header = section.header;
    for (final row in section.rows) {
      final map = <String, dynamic>{};
      for (var i = 0; i < header.length && i < row.length; i++) {
        map[header[i]] = row[i];
      }
      if (map['uid'] == null || (map['uid'] as String).isEmpty) continue;
      await SupabaseClientManager.instance.client
          .from('schedules')
          .upsert(map);
    }
  }

  Future<void> _importDelays(_CsvSection section) async {
    final header = section.header;
    for (final row in section.rows) {
      final map = <String, dynamic>{};
      for (var i = 0; i < header.length && i < row.length; i++) {
        final val = row[i];
        switch (header[i]) {
          case 'days':
            map['days'] = int.tryParse(val) ?? 0;
            break;
          case 'is_excusable':
          case 'is_compensable':
          case 'is_concurrent':
          case 'is_critical':
            map[header[i]] = val.toLowerCase() == 'true';
            break;
          default:
            map[header[i]] = val;
        }
      }
      if (map['uid'] == null || (map['uid'] as String).isEmpty) continue;
      await SupabaseClientManager.instance.client
          .from('delays')
          .upsert(map);
    }
  }

  String _csvRow(List<String> values) {
    return values.map(_csvEscape).join(',');
  }

  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n') || value.contains('\r')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String _jsonField(dynamic value) {
    final json = value.toString();
    return '"${json.replaceAll('"', '""')}"';
  }

  List<_CsvSection> _parseSections(String content) {
    final sections = <_CsvSection>[];
    String? currentType;
    List<String>? currentHeader;
    final currentRows = <List<String>>[];

    for (final line in content.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('# ') && trimmed.length > 2) {
        if (currentType != null && currentHeader != null) {
          sections.add(_CsvSection(currentType, currentHeader, currentRows));
        }
        currentType = trimmed.substring(2).trim();
        currentHeader = null;
        currentRows.clear();
        continue;
      }

      if (currentType == null) continue;

      final row = _parseCsvLine(line);
      if (row.isEmpty) continue;

      if (currentHeader == null) {
        currentHeader = row;
      } else {
        currentRows.add(row);
      }
    }

    if (currentType != null && currentHeader != null) {
      sections.add(_CsvSection(currentType, currentHeader, currentRows));
    }

    return sections;
  }

  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (inQuotes) {
        if (ch == '"') {
          if (i + 1 < line.length && line[i + 1] == '"') {
            buffer.write('"');
            i++;
          } else {
            inQuotes = false;
          }
        } else {
          buffer.write(ch);
        }
      } else {
        if (ch == '"') {
          inQuotes = true;
        } else if (ch == ',') {
          result.add(buffer.toString().trim());
          buffer.clear();
        } else {
          buffer.write(ch);
        }
      }
    }
    result.add(buffer.toString().trim());
    return result;
  }

  List<dynamic> _parseJsonArray(String json) {
    final trimmed = json.trim();
    if (!trimmed.startsWith('[') || !trimmed.endsWith(']')) return [];
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is List) return decoded;
      return [];
    } catch (_) {
      return [];
    }
  }
}

class _CsvSection {
  final String type;
  final List<String> header;
  final List<List<String>> rows;

  _CsvSection(this.type, this.header, this.rows);
}

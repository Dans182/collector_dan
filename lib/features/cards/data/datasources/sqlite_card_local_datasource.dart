import 'package:sqlite3/sqlite3.dart';

import '../../../../core/database/sqlite_database.dart';
import '../../domain/entities/card_search_filters.dart';
import '../models/card_image_record.dart';
import '../models/card_record.dart';
import '../models/stored_card_record.dart';
import 'card_local_datasource.dart';

class SqliteCardLocalDatasource implements CardLocalDatasource {
  SqliteCardLocalDatasource(this._sqliteDatabase) {
    _createSchema();
  }

  final SqliteDatabase _sqliteDatabase;

  Database get _db => _sqliteDatabase.database;

  @override
  Future<StoredCardRecord> insertCard({
    required CardRecord card,
    required List<CardImageRecord> images,
  }) async {
    _db.execute('BEGIN');
    try {
      _db.execute(
        '''
        INSERT INTO cards (
          id, player_name, set_name, year, team_id, brand, card_number,
          rarity_id, notes, is_rookie_card, is_autographed, is_graded,
          grader_company, grade_value
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          card.id,
          card.playerName,
          card.setName,
          card.year,
          card.teamId,
          card.brand,
          card.cardNumber,
          card.rarityId,
          card.notes,
          card.isRookieCard ? 1 : 0,
          card.isAutographed ? 1 : 0,
          card.isGraded ? 1 : 0,
          card.graderCompany,
          card.gradeValue,
        ],
      );

      for (final image in images) {
        _insertImage(image);
      }

      _db.execute('COMMIT');
      return StoredCardRecord(card: card, images: images);
    } catch (_) {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }

  @override
  Future<StoredCardRecord> updateCard({
    required CardRecord card,
    required List<CardImageRecord> images,
  }) async {
    _db.execute('BEGIN');
    try {
      _db.execute(
        '''
        UPDATE cards SET
          player_name = ?,
          set_name = ?,
          year = ?,
          team_id = ?,
          brand = ?,
          card_number = ?,
          rarity_id = ?,
          notes = ?,
          is_rookie_card = ?,
          is_autographed = ?,
          is_graded = ?,
          grader_company = ?,
          grade_value = ?
        WHERE id = ?
        ''',
        [
          card.playerName,
          card.setName,
          card.year,
          card.teamId,
          card.brand,
          card.cardNumber,
          card.rarityId,
          card.notes,
          card.isRookieCard ? 1 : 0,
          card.isAutographed ? 1 : 0,
          card.isGraded ? 1 : 0,
          card.graderCompany,
          card.gradeValue,
          card.id,
        ],
      );

      _db.execute('DELETE FROM card_images WHERE card_id = ?', [card.id]);
      for (final image in images) {
        _insertImage(image);
      }

      _db.execute('COMMIT');
      return StoredCardRecord(card: card, images: images);
    } catch (_) {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }

  @override
  Future<void> deleteCard(String cardId) async {
    _db.execute('DELETE FROM card_images WHERE card_id = ?', [cardId]);
    _db.execute('DELETE FROM cards WHERE id = ?', [cardId]);
  }

  @override
  Future<StoredCardRecord?> fetchCardById(String cardId) async {
    final cardRows = _db.select('SELECT * FROM cards WHERE id = ?', [cardId]);
    if (cardRows.isEmpty) {
      return null;
    }

    final imageRows = _db.select(
      'SELECT * FROM card_images WHERE card_id = ? ORDER BY sort_order ASC',
      [cardId],
    );

    return StoredCardRecord(
      card: _cardFromRow(cardRows.first),
      images: [for (final row in imageRows) _imageFromRow(row)],
    );
  }

  @override
  Future<List<StoredCardRecord>> searchCards(CardSearchFilters filters) async {
    final values = <Object?>[];
    final conditions = <String>[];

    if (filters.textQuery != null && filters.textQuery!.trim().isNotEmpty) {
      conditions.add('(player_name LIKE ? OR set_name LIKE ? OR brand LIKE ? OR notes LIKE ?)');
      final query = '%${filters.textQuery!.trim()}%';
      values.addAll([query, query, query, query]);
    }

    if (filters.yearFrom != null) {
      conditions.add('year >= ?');
      values.add(filters.yearFrom);
    }
    if (filters.yearTo != null) {
      conditions.add('year <= ?');
      values.add(filters.yearTo);
    }
    if (filters.teamId != null && filters.teamId!.trim().isNotEmpty) {
      conditions.add('team_id = ?');
      values.add(filters.teamId);
    }
    if (filters.rarityId != null && filters.rarityId!.trim().isNotEmpty) {
      conditions.add('rarity_id = ?');
      values.add(filters.rarityId);
    }
    if (filters.onlyRookieCards != null) {
      conditions.add('is_rookie_card = ?');
      values.add(filters.onlyRookieCards! ? 1 : 0);
    }
    if (filters.onlyAutographed != null) {
      conditions.add('is_autographed = ?');
      values.add(filters.onlyAutographed! ? 1 : 0);
    }
    if (filters.onlyGraded != null) {
      conditions.add('is_graded = ?');
      values.add(filters.onlyGraded! ? 1 : 0);
    }

    final whereClause = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';
    final rows = _db.select(
      'SELECT * FROM cards $whereClause ORDER BY year DESC, player_name ASC LIMIT ? OFFSET ?',
      [...values, filters.limit, filters.offset],
    );

    return [
      for (final row in rows)
        StoredCardRecord(
          card: _cardFromRow(row),
          images: [
            for (final image in _db.select(
              'SELECT * FROM card_images WHERE card_id = ? ORDER BY sort_order ASC',
              [row['id']],
            ))
              _imageFromRow(image),
          ],
        ),
    ];
  }

  void _createSchema() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS cards (
        id TEXT PRIMARY KEY,
        player_name TEXT NOT NULL,
        set_name TEXT NOT NULL,
        year INTEGER NOT NULL,
        team_id TEXT,
        brand TEXT,
        card_number TEXT,
        rarity_id TEXT,
        notes TEXT,
        is_rookie_card INTEGER NOT NULL,
        is_autographed INTEGER NOT NULL,
        is_graded INTEGER NOT NULL,
        grader_company TEXT,
        grade_value REAL
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS card_images (
        id TEXT PRIMARY KEY,
        card_id TEXT NOT NULL,
        file_path TEXT NOT NULL,
        type TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        FOREIGN KEY(card_id) REFERENCES cards(id)
      )
    ''');

    _db.execute('CREATE INDEX IF NOT EXISTS idx_cards_year ON cards(year)');
    _db.execute('CREATE INDEX IF NOT EXISTS idx_cards_team_id ON cards(team_id)');
    _db.execute('CREATE INDEX IF NOT EXISTS idx_cards_rarity_id ON cards(rarity_id)');
  }

  void _insertImage(CardImageRecord image) {
    _db.execute(
      'INSERT INTO card_images (id, card_id, file_path, type, sort_order) VALUES (?, ?, ?, ?, ?)',
      [image.id, image.cardId, image.filePath, image.type, image.sortOrder],
    );
  }

  CardRecord _cardFromRow(Row row) {
    return CardRecord(
      id: row['id'] as String,
      playerName: row['player_name'] as String,
      setName: row['set_name'] as String,
      year: row['year'] as int,
      teamId: row['team_id'] as String?,
      brand: row['brand'] as String?,
      cardNumber: row['card_number'] as String?,
      rarityId: row['rarity_id'] as String?,
      notes: row['notes'] as String?,
      isRookieCard: (row['is_rookie_card'] as int) == 1,
      isAutographed: (row['is_autographed'] as int) == 1,
      isGraded: (row['is_graded'] as int) == 1,
      graderCompany: row['grader_company'] as String?,
      gradeValue: switch (row['grade_value']) {
        final num value => value.toDouble(),
        _ => null,
      },
    );
  }

  CardImageRecord _imageFromRow(Row row) {
    return CardImageRecord(
      id: row['id'] as String,
      cardId: row['card_id'] as String,
      filePath: row['file_path'] as String,
      type: row['type'] as String,
      sortOrder: row['sort_order'] as int,
    );
  }
}

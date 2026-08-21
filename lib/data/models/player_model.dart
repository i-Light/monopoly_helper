import 'package:flutter/material.dart';

/// A player taking part in the physical board game.
///
/// This is a deliberately trimmed-down version of the player model the
/// app used to ship (that one also tracked jail state, bankruptcy, and a
/// dice roller — none of which were part of the redesigned flow). Jail
/// state ([inPrison]/[prisonReleasePending]) has since been reintroduced,
/// but as a new, purpose-built mechanic for the "special tiles" feature —
/// not a resurrection of the old, deleted `PlayerProvider` fields. Aside
/// from that, only what the turn loop actually needs is kept:
///   * [balance]: the player's cash, in the same currency the board uses.
///   * [position]: the index (into `CitiesData.all`) of the city the
///     player's physical piece is standing on right now.
///   * [ownedCityIndices]: which cities' base plot this player owns. The
///     brief specifically asked for this to be "a list of indices", so
///     ownership of the base plot is tracked exactly that way.
///   * [ownedGarageIndices] / [ownedMarketIndices]: the same idea, kept as
///     two extra index lists so the garage/market "buy" buttons on the
///     results page can independently show "buy" vs. "bought". This is a
///     small, deliberate extension beyond the single list the brief
///     mentioned, documented here and in ARCHITECTURE.md.
class PlayerModel {
  PlayerModel({
    required this.id,
    required this.name,
    required this.color,
    required this.balance,
    this.position = 0,
    this.inPrison = false,
    this.prisonReleasePending = false,
    List<int>? ownedCityIndices,
    List<int>? ownedGarageIndices,
    List<int>? ownedMarketIndices,
  })  : ownedCityIndices = ownedCityIndices ?? <int>[],
        ownedGarageIndices = ownedGarageIndices ?? <int>[],
        ownedMarketIndices = ownedMarketIndices ?? <int>[];

  final String id;
  final String name;
  final Color color;
  int balance;
  int position;

  /// Whether this player is currently serving time — set by
  /// [GameSessionController.arrestActivePlayerForDebt], cleared either by
  /// winning an escape challenge or by [prisonReleasePending] resolving at
  /// the start of a later turn.
  bool inPrison;

  /// Set when the player pays bail instead of attempting an escape
  /// challenge: they stay jailed for the rest of *this* turn (no
  /// movement), then are automatically freed to Start at the very start
  /// of their *next* turn, without needing to see the prison choice
  /// screen again.
  bool prisonReleasePending;

  final List<int> ownedCityIndices;
  final List<int> ownedGarageIndices;
  final List<int> ownedMarketIndices;

  /// Initials made from the first letter of each word in [name], used on
  /// the results page's ownership badge (e.g. "أحمد علي" -> "أع").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.map(_firstGrapheme).join();
  }

  /// Returns the first "visible" character of [word], keeping an Arabic
  /// base letter together with a following combining diacritic (if any)
  /// so initials never end up as a lone, invisible mark.
  static String _firstGrapheme(String word) {
    if (word.isEmpty) return '';
    final combiningMarks = RegExp(r'[\u064B-\u065F\u0670]');
    var end = 1;
    while (end < word.length && combiningMarks.hasMatch(word[end])) {
      end++;
    }
    return word.substring(0, end);
  }

  bool ownsCity(int cityIdx) => ownedCityIndices.contains(cityIdx);
  bool ownsGarage(int cityIdx) => ownedGarageIndices.contains(cityIdx);
  bool ownsMarket(int cityIdx) => ownedMarketIndices.contains(cityIdx);
}

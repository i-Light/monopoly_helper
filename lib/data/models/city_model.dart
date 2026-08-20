import 'package:flutter/material.dart';

/// A single city/property space on the physical board.
///
/// Field names intentionally mirror the structure the user described for
/// the real dataset that will replace [CitiesData]'s placeholder list:
/// `{idx, name, color_on_board, color_on_card, base_price, base_fee,
/// garage_price, garage_fee, market_price, market_fee}`.
///
/// A city can be upgraded independently in three tiers — the base plot,
/// a garage, and a market — each with its own purchase price and the rent
/// ("fee") it charges other players who owe money for landing on it.
@immutable
class CityModel {
  const CityModel({
    required this.idx,
    required this.name,
    required this.colorOnBoard,
    required this.colorOnCard,
    required this.basePrice,
    required this.baseFee,
    required this.garagePrice,
    required this.garageFee,
    required this.marketPrice,
    required this.marketFee,
  });

  final int idx;
  final String name;
  final Color colorOnBoard;
  final Color colorOnCard;
  final int basePrice;
  final int baseFee;
  final int garagePrice;
  final int garageFee;
  final int marketPrice;
  final int marketFee;
}

import 'package:flutter/material.dart';

/// What kind of board space a [CityModel] represents.
///
/// Everything defaults to [normal] (the generic buy base/garage/market
/// flow). The other four values each get their own bespoke results-page
/// content instead — see `presentation/special_tiles/`.
enum CityKind { normal, start, club, expressBus, prison }

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
  final int idx;
  final String name;
  final Color colorOnBoard;
  final Color colorOnCard;
  final int basePrice;
  final int baseFee;
  final int garagePrice;
  final int? _customGarageFee;
  final int marketPrice;
  final int? _customMarketFee;
  final CityKind kind;
  const CityModel({
    required this.idx,
    required this.name,
    required this.colorOnBoard,
    required this.colorOnCard,
    required this.basePrice,
    required this.baseFee,
    required this.garagePrice,
    int? garageFee,
    required this.marketPrice,
    int? marketFee,
    this.kind = CityKind.normal,
  })  : _customMarketFee = marketFee,
        _customGarageFee = garageFee;

  int get garageFee => _customGarageFee ?? baseFee * 2;

  int get marketFee => _customMarketFee ?? baseFee * 5;
}

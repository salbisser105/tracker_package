library tracker_coin_package;

import 'dart:convert';

import 'package:http/http.dart' as http;

class TrackerTestPackage {
  /// This is the main method of the package [fetchCoin] where we use the http package to call an api.
  /// here we access coingecko free api to check coin information.
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    ///Basic http call.
    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }
      }
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }
}

/// [Coin] is the model that we are handling inside our package.
/// We will need this in order to have our [fetchCoin] method working.
class Coin {
  Coin({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.change,
    required this.changePercentage,
  });

  String name;
  String symbol;
  String imageUrl;
  num price;
  num change;
  num changePercentage;

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      name: json['name'],
      symbol: json['symbol'],
      imageUrl: json['image'],
      price: json['current_price'],
      change: json['price_change_24h'],
      changePercentage: json['price_change_percentage_24h'],
    );
  }
}

/// This is the list that we will be displaying when using the package.

List<Coin> coinList = [];

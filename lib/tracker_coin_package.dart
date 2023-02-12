library tracker_coin_package;

import 'dart:convert';

import 'package:http/http.dart' as http;

class TrackerCoinPackage {
  /// This is the main method of the package [fetchCoin] where we use the http package to call an api.
  /// here we access coingecko free api to check coin information.
  Future<List<CoinModel>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    ///Basic http call.
    if (response.statusCode == 200) {
      List<dynamic> values = [];
      // We decode the value.
      values = json.decode(response.body);
      //We check the list.
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          //We add the call.
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(CoinModel.fromJson(map));
          }
        }
      }
      //We return our coin list.
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }
}

/// [CoinModel] is the model that we are handling inside our package.
/// We will need this in order to have our [fetchCoin] method working.
class CoinModel {
  CoinModel({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.change,
    required this.changePercentage,
  });
//Atributes we want to have in our Model
  String name;
  String symbol;
  String imageUrl;
  num price;
  num change;
  num changePercentage;

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
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

List<CoinModel> coinList = [];

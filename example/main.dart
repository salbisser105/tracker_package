import 'package:flutter/material.dart';
import 'package:tracker_coin_package/tracker_coin_package.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'page1',
      routes: {
        'page1': ((context) => const HomePagePriceTracker()),
      },
    );
  }
}

class HomePagePriceTracker extends StatefulWidget {
  const HomePagePriceTracker({Key? key}) : super(key: key);

  @override
  State<HomePagePriceTracker> createState() => _HomePagePriceTrackerState();
}

class _HomePagePriceTrackerState extends State<HomePagePriceTracker> {
  TrackerTestPackage helpers = TrackerTestPackage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[300],
          centerTitle: true,
          title: Text(
            'Crypto Tracker',
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder<List<Coin>>(
            future: helpers.fetchCoin(),
            builder: (context, snapshot) {
              var data = snapshot.data;
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Scrollbar(
                thumbVisibility: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        return CoinCardWidget(
                          name: data![index].name,
                          symbol: data[index].symbol,
                          imageUrl: data[index].imageUrl,
                          price: data[index].price.toDouble(),
                          change: data[index].change.toDouble(),
                          changePercentage:
                              data[index].changePercentage.toDouble(),
                        );
                      }),
                ),
              );
            }));
  }
}

class CoinCardWidget extends StatelessWidget {
  CoinCardWidget({
    Key? key,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.change,
    required this.changePercentage,
  }) : super(key: key);

  String name;
  String symbol;
  String imageUrl;
  double price;
  double change;
  double changePercentage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width * 0.99,
        decoration: boxDecoration(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
          ),
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: boxDecoration(),
                  height: 55,
                  width: 55,
                  child: Image.network(imageUrl)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        symbol,
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price.toString(),
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        change < 8
                            ? '-${change.toStringAsFixed(4)}'
                            : '+${change.toStringAsFixed(4)}',
                        style: TextStyle(
                            color: change.toDouble() < 8
                                ? Colors.red
                                : Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        changePercentage < 8
                            ? '-${changePercentage.toStringAsFixed(4)}%'
                            : '+${changePercentage.toStringAsFixed(4)}%',
                        style: TextStyle(
                            color: changePercentage < 8
                                ? Colors.red
                                : Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

boxDecoration() {
  return BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
          color: Colors.white,
          offset: Offset(-4, -4),
          blurRadius: 10,
          spreadRadius: 1)
    ],
  );
}

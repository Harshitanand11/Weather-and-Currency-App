import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_state.dart';
import 'package:provider/provider.dart';

class CurrencyWidget extends StatelessWidget {
  const CurrencyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final baseCurrency = appState.selectedCurrency;
    final currencyData = context.select<AppState, Map<String, dynamic>?>(
          (state) => state.currencyData,
    );
    if (currencyData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final formatCurrency = NumberFormat.currency(
      locale: 'en_US',
      symbol: baseCurrency,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: DropdownButton<String>(
            value: baseCurrency,
            onChanged: (value) =>
                context.read<AppState>().setSelectedCurrency(value!),
            items: currencyData['rates']
                .keys
                .map(
                  (currency) => DropdownMenuItem(
                value: currency,
                child: Text(currency),
              ),
            )
                .toList(),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              formatCurrency.format(currencyData['rates'][baseCurrency]),
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      ],
    );
  }
}
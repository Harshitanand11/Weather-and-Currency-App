import 'package:flutter/material.dart';
class SettingsPage extends StatefulWidget {
  final bool showWeather;
  final bool showCurrency;
  final String selectedCountry;

  const SettingsPage({
    Key? key,
    required this.showWeather,
    required this.showCurrency,
    required this.selectedCountry,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showWeather = false;
  bool _showCurrency = false;
  String _selectedCountry = '';

  @override
  void initState() {
    super.initState();
    _showWeather = widget.showWeather;
    _showCurrency = widget.showCurrency;
    _selectedCountry = widget.selectedCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select which widgets to display:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Weather'),
              value: _showWeather,
              onChanged: (value) {
                setState(() {
                  _showWeather = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Currency'),
              value: _showCurrency,
              onChanged: (value) {
                setState(() {
                  _showCurrency = value;
                });
              },
            ),
            SizedBox(height: 32),
            Text(
              'Select a country:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedCountry,
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value!;
                });
              },
              items: [
                'United States - New York',
                'United Kingdom - London',
                'UAE - Dubai',
                'India - Mumbai',
                'Japan - Tokyo',
                'Russia - Moscow',
                'Canada - Toronto',
              ]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, {
            'showWeather': _showWeather,
            'showCurrency': _showCurrency,
            'selectedCountry': _selectedCountry,
          });
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

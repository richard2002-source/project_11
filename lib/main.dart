import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Multi-Category Unit Converter"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: UnitConverter(),
      ),
    );
  }
}

class UnitConverter extends StatefulWidget {
  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedCategory = "Speed";
  String? _selectedConversion;
  String _result = "";

  final Map<String, Map<String, Function(double)>> _conversionCategories = {
    "Speed": {
      "km/h to mph": (double value) => value * 0.621371,
      "mph to km/h": (double value) => value / 0.621371,
      "m/s to km/h": (double value) => value * 3.6,
      "km/h to m/s": (double value) => value / 3.6,
    },
    "Time": {
      "hours to minutes": (double value) => value * 60,
      "minutes to seconds": (double value) => value * 60,
      "seconds to minutes": (double value) => value / 60,
      "minutes to hours": (double value) => value / 60,
    },
    "Volume": {
      "liters to gallons": (double value) => value * 0.264172,
      "gallons to liters": (double value) => value / 0.264172,
      "ml to liters": (double value) => value / 1000,
      "liters to ml": (double value) => value * 1000,
    },
    "Metric Length": {
      "cm to inches": (double value) => value * 0.393701,
      "inches to cm": (double value) => value / 0.393701,
      "meters to feet": (double value) => value * 3.28084,
      "feet to meters": (double value) => value / 3.28084,
    },
    "Weight": {
      "kg to lbs": (double value) => value * 2.20462,
      "lbs to kg": (double value) => value / 2.20462,
      "grams to kg": (double value) => value / 1000,
      "kg to grams": (double value) => value * 1000,
    },
  };

  void _convert() {
    if (_inputController.text.isEmpty) {
      setState(() {
        _result = "⚠️ Please enter a valid number!";
      });
      return;
    }

    double? inputValue = double.tryParse(_inputController.text);
    if (inputValue == null) {
      setState(() {
        _result = "⚠️ Input must be a numeric value!";
      });
      return;
    }

    if (_selectedConversion == null) {
      setState(() {
        _result = "⚠️ Please select a conversion!";
      });
      return;
    }

    final conversionFunction =
    _conversionCategories[_selectedCategory]![_selectedConversion]!;
    double convertedValue = conversionFunction(inputValue);

    setState(() {
      _result =
      "$inputValue converted to ${_selectedConversion!.split(' ')[2]} is ${convertedValue.toStringAsFixed(2)}.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.lightBlue[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter a value to convert:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _inputController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Enter value",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: Icon(Icons.input, color: Colors.blue),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            "Choose a category:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
          ),
          SizedBox(height: 8.0),
          DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            dropdownColor: Colors.white,
            items: _conversionCategories.keys.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: TextStyle(color: Colors.blue[800])),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
                _selectedConversion = null; // Reset conversion selection
              });
            },
          ),
          SizedBox(height: 16.0),
          if (_conversionCategories[_selectedCategory]!.isNotEmpty) ...[
            Text(
              "Choose conversion type:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
            ),
            SizedBox(height: 8.0),
            DropdownButton<String>(
              value: _selectedConversion,
              isExpanded: true,
              dropdownColor: Colors.white,
              items: _conversionCategories[_selectedCategory]!.keys.map((String conversion) {
                return DropdownMenuItem<String>(
                  value: conversion,
                  child: Text(conversion, style: TextStyle(color: Colors.blue[800])),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _selectedConversion = newValue!);
              },
            ),
          ],
          SizedBox(height: 24.0),
          Center(
            child: ElevatedButton.icon(
              onPressed: _convert,
              icon: Icon(Icons.calculate, color: Colors.white),
              label: Text("Convert"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 24.0),
          Text(
            "Result:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
          ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              _result,
              style: TextStyle(
                fontSize: 18.0,
                color: _result.startsWith("⚠️") ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

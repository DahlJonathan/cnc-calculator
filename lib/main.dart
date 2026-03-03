import 'dart:math';
import 'package:flutter/material.dart';
import './models/material.dart';

void main() {
  runApp(const CNCCalculatorApp());
}

enum CalculationType { rpm, cuttingSpeed, feedRate }

class CNCCalculatorApp extends StatelessWidget {
  const CNCCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      home: const CNCScreen(),
    );
  }
}

class CNCScreen extends StatefulWidget {
  const CNCScreen({super.key});

  @override
  State<CNCScreen> createState() => _CNCScreenState();
}

class _CNCScreenState extends State<CNCScreen> {
  final _formKey = GlobalKey<FormState>();

  CalculationType selectedType = CalculationType.rpm;
  MaterialModel selectedMaterial = materials.first;

  final diameterController = TextEditingController();
  final rpmController = TextEditingController();
  final cuttingSpeedController = TextEditingController();
  final flutesController = TextEditingController();
  final feedPerToothController = TextEditingController();

  String result = "";

  @override
  void initState() {
    super.initState();
    _applyMaterialDefaults();
  }

  void _applyMaterialDefaults() {
    cuttingSpeedController.text = selectedMaterial.recommendedVc.toString();
    flutesController.text = selectedMaterial.defaultFlutes.toString();
    feedPerToothController.text = selectedMaterial.defaultChipLoad.toString();
  }

  void calculate() {
    if (!_formKey.currentState!.validate()) return;

    final diameter = double.tryParse(diameterController.text) ?? 0;
    final rpm = double.tryParse(rpmController.text) ?? 0;
    final cuttingSpeed = double.tryParse(cuttingSpeedController.text) ?? 0;
    final flutes = int.tryParse(flutesController.text) ?? 0;
    final feedPerTooth = double.tryParse(feedPerToothController.text) ?? 0;

    double output = 0;

    switch (selectedType) {
      case CalculationType.rpm:
        output = (1000 * cuttingSpeed) / (pi * diameter);
        result = "${output.toStringAsFixed(0)} RPM";
        break;

      case CalculationType.cuttingSpeed:
        output = (pi * diameter * rpm) / 1000;
        result = "${output.toStringAsFixed(2)} m/min";
        break;

      case CalculationType.feedRate:
        output = rpm * flutes * feedPerTooth;
        result = "${output.toStringAsFixed(2)} mm/min";
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CNC Milling Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// MATERIAL DROPDOWN
              DropdownButtonFormField<MaterialModel>(
                value: selectedMaterial,
                decoration: const InputDecoration(labelText: "Material"),
                items: materials.map((material) {
                  return DropdownMenuItem(
                    value: material,
                    child: Text(material.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMaterial = value!;
                    _applyMaterialDefaults();
                  });
                },
              ),

              const SizedBox(height: 20),

              /// CALCULATION TYPE
              DropdownButtonFormField<CalculationType>(
                value: selectedType,
                decoration: const InputDecoration(labelText: "Calculate"),
                items: const [
                  DropdownMenuItem(
                    value: CalculationType.rpm,
                    child: Text("Spindle Speed (RPM)"),
                  ),
                  DropdownMenuItem(
                    value: CalculationType.cuttingSpeed,
                    child: Text("Cutting Speed (Vc)"),
                  ),
                  DropdownMenuItem(
                    value: CalculationType.feedRate,
                    child: Text("Feed Rate"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                    result = "";
                  });
                },
              ),

              const SizedBox(height: 20),

              /// TOOL DIAMETER
              if (selectedType != CalculationType.feedRate)
                _numberField(diameterController, "Tool Diameter (mm)"),

              /// CUTTING SPEED
              if (selectedType == CalculationType.rpm)
                _numberField(cuttingSpeedController, "Cutting Speed (m/min)"),

              /// RPM
              if (selectedType == CalculationType.cuttingSpeed ||
                  selectedType == CalculationType.feedRate)
                _numberField(rpmController, "Spindle Speed (RPM)"),

              /// FEED INPUTS
              if (selectedType == CalculationType.feedRate) ...[
                _numberField(flutesController, "Flutes", isInt: true),
                _numberField(feedPerToothController, "Feed per Tooth (mm)"),
              ],

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text("Calculate"),
              ),

              const SizedBox(height: 24),

              if (result.isNotEmpty)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        result,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label, {
    bool isInt = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter value";
          }
          if (isInt) {
            if (int.tryParse(value) == null) {
              return "Invalid number";
            }
          } else {
            if (double.tryParse(value) == null) {
              return "Invalid number";
            }
          }
          return null;
        },
      ),
    );
  }
}

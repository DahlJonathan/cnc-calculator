class MaterialModel {
  final String name;
  final double recommendedVc; // m/min
  final int defaultFlutes;
  final double defaultChipLoad; // mm per tooth

  MaterialModel({
    required this.name,
    required this.recommendedVc,
    required this.defaultFlutes,
    required this.defaultChipLoad,
  });
}

final List<MaterialModel> materials = [
  MaterialModel(
    name: "Aluminum",
    recommendedVc: 250,
    defaultFlutes: 2,
    defaultChipLoad: 0.08,
  ),
  MaterialModel(
    name: "Mild Steel",
    recommendedVc: 120,
    defaultFlutes: 4,
    defaultChipLoad: 0.05,
  ),
  MaterialModel(
    name: "Stainless Steel",
    recommendedVc: 90,
    defaultFlutes: 4,
    defaultChipLoad: 0.04,
  ),
  MaterialModel(
    name: "Titanium",
    recommendedVc: 60,
    defaultFlutes: 4,
    defaultChipLoad: 0.03,
  ),
];

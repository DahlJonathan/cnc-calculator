# CNC Milling Calculator

A Flutter application for calculating CNC milling parameters.

## Features

- Calculate RPM based on cutting speed and tool diameter
- Calculate cutting speed from RPM and diameter
- Calculate feed rate using RPM, flutes, and feed per tooth
- Pre-configured material presets (Aluminum, Steel, Stainless Steel, Titanium)
- **Auto-filled recommended values** based on selected material

## Getting Started

```bash
flutter pub get
flutter run
```

## Materials Included

- **Aluminum** (Vc: 250 m/min)
  - Recommended flutes: 2
  - Recommended chip load: 0.08 mm/tooth
  
- **Mild Steel** (Vc: 120 m/min)
  - Recommended flutes: 4
  - Recommended chip load: 0.05 mm/tooth
  
- **Stainless Steel** (Vc: 90 m/min)
  - Recommended flutes: 4
  - Recommended chip load: 0.04 mm/tooth
  
- **Titanium** (Vc: 60 m/min)
  - Recommended flutes: 4
  - Recommended chip load: 0.03 mm/tooth

## How It Works

When you select a material, the app automatically fills in:
- **Cutting Speed (Vc)** - Optimal surface speed for the material
- **Number of Flutes** - Recommended cutting edges
- **Feed Per Tooth** - Recommended chip load per cutting edge

You can adjust these values manually if needed for specific tooling or conditions.

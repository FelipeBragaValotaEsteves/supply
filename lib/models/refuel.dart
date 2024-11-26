class Refuel {
  final String id;
  final double liters;
  final int currentMileage;
  final int previousMileage;
  final DateTime date;

  Refuel({
    required this.id,
    required this.liters,
    required this.currentMileage,
    required this.previousMileage,
    required this.date,
  });

  double get averageConsumption {
    return (currentMileage - previousMileage) / liters;
  }
}

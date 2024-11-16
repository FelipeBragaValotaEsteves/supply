class Refuel {
  final String vehicleId;
  final double liters;
  final int currentMileage;
  final int previousMileage;
  final DateTime date;

  Refuel({
    required this.vehicleId,
    required this.liters,
    required this.currentMileage,
    required this.previousMileage,
    required this.date,
  });

  double get averageConsumption {
    return (currentMileage - previousMileage) / liters;
  }
}

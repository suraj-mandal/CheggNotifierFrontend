class AvailabilityStatus {
  final bool available;

  const AvailabilityStatus({required this.available});

  factory AvailabilityStatus.fromJson(Map<String, dynamic> json) {
    return AvailabilityStatus(available: json['available'] as bool);
  }

}

// Enum for sort direction
enum SortDirection {
  ascending('ASC'),
  descending('DESC');

  final String value;

  const SortDirection(this.value);

  // fromString function to map the string to enum
  static SortDirection? fromString(String? direction) {
    return SortDirection.values.firstWhere(
      (e) => e.value == direction?.toUpperCase(),
      orElse: () => .ascending,
    );
  }

  // toString function for serialization back to string
  String toJson() => value;
}

// Cleaner helper functions for conversion
SortDirection? sortDirectionFromString(String? sortDirection) =>
    SortDirection.fromString(sortDirection);

String? sortDirectionToString(SortDirection? sortDirection) =>
    sortDirection?.toJson();

/// Supported comparison operators for static filter query parameters.
enum FilterOperator {
  equals(''),
  neq('Neq'),
  gt('Gt'),
  gte('Gte'),
  lt('Lt'),
  lte('Lte'),
  like('Like'),
  inSet('In'),
  nin('Nin'),
  from('From'),
  to('To'),
  isNull('IsNull'),
  isNotNull('IsNotNull');

  final String suffix;
  const FilterOperator(this.suffix);
}

/// Helper class to construct flat static filter parameters.
class FilterCondition {
  final String field;
  final FilterOperator operator;
  final dynamic value;

  const FilterCondition(this.field, this.operator, this.value);

  factory FilterCondition.equals(String field, dynamic value) =>
      FilterCondition(field, FilterOperator.equals, value);

  factory FilterCondition.neq(String field, dynamic value) =>
      FilterCondition(field, FilterOperator.neq, value);

  factory FilterCondition.gt(String field, dynamic value) =>
      FilterCondition(field, FilterOperator.gt, value);

  factory FilterCondition.gte(String field, dynamic value) =>
      FilterCondition(field, FilterOperator.gte, value);

  factory FilterCondition.lt(String field, dynamic value) =>
      FilterCondition(field, FilterOperator.lt, value);

  factory FilterCondition.lte(String field, dynamic value) =>
      FilterCondition(field, FilterOperator.lte, value);

  factory FilterCondition.like(String field, String value) =>
      FilterCondition(field, FilterOperator.like, value);

  factory FilterCondition.inSet(String field, List<dynamic> values) =>
      FilterCondition(field, FilterOperator.inSet, values.join(','));

  factory FilterCondition.nin(String field, List<dynamic> values) =>
      FilterCondition(field, FilterOperator.nin, values.join(','));

  factory FilterCondition.isNull(String field, [bool isNull = true]) =>
      FilterCondition(field, FilterOperator.isNull, isNull);

  factory FilterCondition.isNotNull(String field, [bool isNotNull = true]) =>
      FilterCondition(field, FilterOperator.isNotNull, isNotNull);

  MapEntry<String, dynamic> toQueryParam() {
    final key = '$field${operator.suffix}';
    return MapEntry(key, value);
  }
}

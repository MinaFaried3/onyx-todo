import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'places_details_new_response.g.dart';

@JsonSerializable()
class PlacesDetailsNewResponse extends Equatable {
  final String? name;
  final String? id;
  final List<String>? types;
  final String? formattedAddress;
  final List<AddressComponent>? addressComponents;
  final Location? location;
  final Viewport? viewport;
  final int? rating;
  final String? googleMapsUri;
  final int? utcOffsetMinutes;
  final String? adrFormatAddress;
  final String? businessStatus;
  final int? userRatingCount;
  final String? iconMaskBaseUri;
  final String? iconBackgroundColor;
  final DisplayText? displayName;
  final DisplayText? primaryTypeDisplayName;
  final bool? takeout;
  final bool? delivery;
  final bool? servesLunch;
  final bool? servesDinner;
  final String? primaryType;
  final String? shortFormattedAddress;
  final DisplayText? editorialSummary;
  final List<Review>? reviews;
  final bool? goodForChildren;
  final bool? restroom;
  final bool? goodForGroups;
  final PaymentOptions? paymentOptions;
  final ParkingOptions? parkingOptions;
  final AccessibilityOptions? accessibilityOptions;
  final bool? pureServiceAreaBusiness;
  final AddressDescriptor? addressDescriptor;
  final GoogleMapsLinks? googleMapsLinks;

  const PlacesDetailsNewResponse({
    required this.name,
    required this.id,
    required this.types,
    required this.formattedAddress,
    required this.addressComponents,
    required this.location,
    required this.viewport,
    required this.rating,
    required this.googleMapsUri,
    required this.utcOffsetMinutes,
    required this.adrFormatAddress,
    required this.businessStatus,
    required this.userRatingCount,
    required this.iconMaskBaseUri,
    required this.iconBackgroundColor,
    required this.displayName,
    required this.primaryTypeDisplayName,
    required this.takeout,
    required this.delivery,
    required this.servesLunch,
    required this.servesDinner,
    required this.primaryType,
    required this.shortFormattedAddress,
    required this.editorialSummary,
    required this.reviews,
    required this.goodForChildren,
    required this.restroom,
    required this.goodForGroups,
    required this.paymentOptions,
    required this.parkingOptions,
    required this.accessibilityOptions,
    required this.pureServiceAreaBusiness,
    required this.addressDescriptor,
    required this.googleMapsLinks,
  });

  factory PlacesDetailsNewResponse.fromJson(Map<String, dynamic> json) =>
      _$PlacesDetailsNewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlacesDetailsNewResponseToJson(this);

  @override
  List<Object?> get props => [
        name,
        id,
        types,
        formattedAddress,
        addressComponents,
        location,
        viewport,
        rating,
        googleMapsUri,
        utcOffsetMinutes,
        adrFormatAddress,
        businessStatus,
        userRatingCount,
        iconMaskBaseUri,
        iconBackgroundColor,
        displayName,
        primaryTypeDisplayName,
        takeout,
        delivery,
        servesLunch,
        servesDinner,
        primaryType,
        shortFormattedAddress,
        editorialSummary,
        reviews,
        goodForChildren,
        restroom,
        goodForGroups,
        paymentOptions,
        parkingOptions,
        accessibilityOptions,
        pureServiceAreaBusiness,
        addressDescriptor,
        googleMapsLinks,
      ];
}

@JsonSerializable()
class AddressComponent extends Equatable {
  final String longText;
  final String shortText;
  final List<String> types;
  final String languageCode;

  const AddressComponent({
    required this.longText,
    required this.shortText,
    required this.types,
    required this.languageCode,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentFromJson(json);

  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);

  @override
  List<Object?> get props => [longText, shortText, types, languageCode];
}

@JsonSerializable()
class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  List<Object?> get props => [latitude, longitude];
}

@JsonSerializable()
class Viewport extends Equatable {
  final Location low;
  final Location high;

  const Viewport({required this.low, required this.high});

  factory Viewport.fromJson(Map<String, dynamic> json) =>
      _$ViewportFromJson(json);

  Map<String, dynamic> toJson() => _$ViewportToJson(this);

  @override
  List<Object?> get props => [low, high];
}

@JsonSerializable()
class DisplayText extends Equatable {
  final String text;
  final String languageCode;

  const DisplayText({required this.text, required this.languageCode});

  factory DisplayText.fromJson(Map<String, dynamic> json) =>
      _$DisplayTextFromJson(json);

  Map<String, dynamic> toJson() => _$DisplayTextToJson(this);

  @override
  List<Object?> get props => [text, languageCode];
}

@JsonSerializable()
class Review extends Equatable {
  final String name;
  final String relativePublishTimeDescription;
  final int rating;
  final AuthorAttribution authorAttribution;
  final String publishTime;
  final String flagContentUri;
  final String googleMapsUri;

  const Review({
    required this.name,
    required this.relativePublishTimeDescription,
    required this.rating,
    required this.authorAttribution,
    required this.publishTime,
    required this.flagContentUri,
    required this.googleMapsUri,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  @override
  List<Object?> get props => [
        name,
        relativePublishTimeDescription,
        rating,
        authorAttribution,
        publishTime,
        flagContentUri,
        googleMapsUri,
      ];
}

@JsonSerializable()
class AuthorAttribution extends Equatable {
  final String displayName;
  final String uri;
  final String photoUri;

  const AuthorAttribution({
    required this.displayName,
    required this.uri,
    required this.photoUri,
  });

  factory AuthorAttribution.fromJson(Map<String, dynamic> json) =>
      _$AuthorAttributionFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorAttributionToJson(this);

  @override
  List<Object?> get props => [displayName, uri, photoUri];
}

@JsonSerializable()
class PaymentOptions extends Equatable {
  final bool acceptsCreditCards;
  final bool acceptsDebitCards;
  final bool acceptsCashOnly;

  const PaymentOptions({
    required this.acceptsCreditCards,
    required this.acceptsDebitCards,
    required this.acceptsCashOnly,
  });

  factory PaymentOptions.fromJson(Map<String, dynamic> json) =>
      _$PaymentOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentOptionsToJson(this);

  @override
  List<Object?> get props => [
        acceptsCreditCards,
        acceptsDebitCards,
        acceptsCashOnly,
      ];
}

@JsonSerializable()
class ParkingOptions extends Equatable {
  final bool freeParkingLot;
  final bool freeStreetParking;

  const ParkingOptions({
    required this.freeParkingLot,
    required this.freeStreetParking,
  });

  factory ParkingOptions.fromJson(Map<String, dynamic> json) =>
      _$ParkingOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingOptionsToJson(this);

  @override
  List<Object?> get props => [freeParkingLot, freeStreetParking];
}

@JsonSerializable()
class AccessibilityOptions extends Equatable {
  final bool wheelchairAccessibleRestroom;

  const AccessibilityOptions({required this.wheelchairAccessibleRestroom});

  factory AccessibilityOptions.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$AccessibilityOptionsToJson(this);

  @override
  List<Object?> get props => [wheelchairAccessibleRestroom];
}

@JsonSerializable()
class AddressDescriptor extends Equatable {
  final List<Landmark> landmarks;

  const AddressDescriptor({required this.landmarks});

  factory AddressDescriptor.fromJson(Map<String, dynamic> json) =>
      _$AddressDescriptorFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDescriptorToJson(this);

  @override
  List<Object?> get props => [landmarks];
}

@JsonSerializable()
class Landmark extends Equatable {
  final String name;
  final String placeId;
  final DisplayText displayName;
  final List<String> types;
  final String spatialRelationship;
  final double straightLineDistanceMeters;
  final double travelDistanceMeters;

  const Landmark({
    required this.name,
    required this.placeId,
    required this.displayName,
    required this.types,
    required this.spatialRelationship,
    required this.straightLineDistanceMeters,
    required this.travelDistanceMeters,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) =>
      _$LandmarkFromJson(json);

  Map<String, dynamic> toJson() => _$LandmarkToJson(this);

  @override
  List<Object?> get props => [
        name,
        placeId,
        displayName,
        types,
        spatialRelationship,
        straightLineDistanceMeters,
        travelDistanceMeters,
      ];
}

@JsonSerializable()
class GoogleMapsLinks extends Equatable {
  final String directionsUri;
  final String placeUri;
  final String writeAReviewUri;
  final String reviewsUri;
  final String photosUri;

  const GoogleMapsLinks({
    required this.directionsUri,
    required this.placeUri,
    required this.writeAReviewUri,
    required this.reviewsUri,
    required this.photosUri,
  });

  factory GoogleMapsLinks.fromJson(Map<String, dynamic> json) =>
      _$GoogleMapsLinksFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleMapsLinksToJson(this);

  @override
  List<Object?> get props => [
        directionsUri,
        placeUri,
        writeAReviewUri,
        reviewsUri,
        photosUri,
      ];
}

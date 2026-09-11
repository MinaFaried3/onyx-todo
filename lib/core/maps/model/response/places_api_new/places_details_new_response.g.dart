// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_details_new_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlacesDetailsNewResponse _$PlacesDetailsNewResponseFromJson(
  Map<String, dynamic> json,
) => PlacesDetailsNewResponse(
  name: json['name'] as String?,
  id: json['id'] as String?,
  types: (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
  formattedAddress: json['formattedAddress'] as String?,
  addressComponents: (json['addressComponents'] as List<dynamic>?)
      ?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>))
      .toList(),
  location: json['location'] == null
      ? null
      : Location.fromJson(json['location'] as Map<String, dynamic>),
  viewport: json['viewport'] == null
      ? null
      : Viewport.fromJson(json['viewport'] as Map<String, dynamic>),
  rating: (json['rating'] as num?)?.toInt(),
  googleMapsUri: json['googleMapsUri'] as String?,
  utcOffsetMinutes: (json['utcOffsetMinutes'] as num?)?.toInt(),
  adrFormatAddress: json['adrFormatAddress'] as String?,
  businessStatus: json['businessStatus'] as String?,
  userRatingCount: (json['userRatingCount'] as num?)?.toInt(),
  iconMaskBaseUri: json['iconMaskBaseUri'] as String?,
  iconBackgroundColor: json['iconBackgroundColor'] as String?,
  displayName: json['displayName'] == null
      ? null
      : DisplayText.fromJson(json['displayName'] as Map<String, dynamic>),
  primaryTypeDisplayName: json['primaryTypeDisplayName'] == null
      ? null
      : DisplayText.fromJson(
          json['primaryTypeDisplayName'] as Map<String, dynamic>,
        ),
  takeout: json['takeout'] as bool?,
  delivery: json['delivery'] as bool?,
  servesLunch: json['servesLunch'] as bool?,
  servesDinner: json['servesDinner'] as bool?,
  primaryType: json['primaryType'] as String?,
  shortFormattedAddress: json['shortFormattedAddress'] as String?,
  editorialSummary: json['editorialSummary'] == null
      ? null
      : DisplayText.fromJson(json['editorialSummary'] as Map<String, dynamic>),
  reviews: (json['reviews'] as List<dynamic>?)
      ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
      .toList(),
  goodForChildren: json['goodForChildren'] as bool?,
  restroom: json['restroom'] as bool?,
  goodForGroups: json['goodForGroups'] as bool?,
  paymentOptions: json['paymentOptions'] == null
      ? null
      : PaymentOptions.fromJson(json['paymentOptions'] as Map<String, dynamic>),
  parkingOptions: json['parkingOptions'] == null
      ? null
      : ParkingOptions.fromJson(json['parkingOptions'] as Map<String, dynamic>),
  accessibilityOptions: json['accessibilityOptions'] == null
      ? null
      : AccessibilityOptions.fromJson(
          json['accessibilityOptions'] as Map<String, dynamic>,
        ),
  pureServiceAreaBusiness: json['pureServiceAreaBusiness'] as bool?,
  addressDescriptor: json['addressDescriptor'] == null
      ? null
      : AddressDescriptor.fromJson(
          json['addressDescriptor'] as Map<String, dynamic>,
        ),
  googleMapsLinks: json['googleMapsLinks'] == null
      ? null
      : GoogleMapsLinks.fromJson(
          json['googleMapsLinks'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PlacesDetailsNewResponseToJson(
  PlacesDetailsNewResponse instance,
) => <String, dynamic>{
  'name': instance.name,
  'id': instance.id,
  'types': instance.types,
  'formattedAddress': instance.formattedAddress,
  'addressComponents': instance.addressComponents,
  'location': instance.location,
  'viewport': instance.viewport,
  'rating': instance.rating,
  'googleMapsUri': instance.googleMapsUri,
  'utcOffsetMinutes': instance.utcOffsetMinutes,
  'adrFormatAddress': instance.adrFormatAddress,
  'businessStatus': instance.businessStatus,
  'userRatingCount': instance.userRatingCount,
  'iconMaskBaseUri': instance.iconMaskBaseUri,
  'iconBackgroundColor': instance.iconBackgroundColor,
  'displayName': instance.displayName,
  'primaryTypeDisplayName': instance.primaryTypeDisplayName,
  'takeout': instance.takeout,
  'delivery': instance.delivery,
  'servesLunch': instance.servesLunch,
  'servesDinner': instance.servesDinner,
  'primaryType': instance.primaryType,
  'shortFormattedAddress': instance.shortFormattedAddress,
  'editorialSummary': instance.editorialSummary,
  'reviews': instance.reviews,
  'goodForChildren': instance.goodForChildren,
  'restroom': instance.restroom,
  'goodForGroups': instance.goodForGroups,
  'paymentOptions': instance.paymentOptions,
  'parkingOptions': instance.parkingOptions,
  'accessibilityOptions': instance.accessibilityOptions,
  'pureServiceAreaBusiness': instance.pureServiceAreaBusiness,
  'addressDescriptor': instance.addressDescriptor,
  'googleMapsLinks': instance.googleMapsLinks,
};

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) =>
    AddressComponent(
      longText: json['longText'] as String,
      shortText: json['shortText'] as String,
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      languageCode: json['languageCode'] as String,
    );

Map<String, dynamic> _$AddressComponentToJson(AddressComponent instance) =>
    <String, dynamic>{
      'longText': instance.longText,
      'shortText': instance.shortText,
      'types': instance.types,
      'languageCode': instance.languageCode,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

Viewport _$ViewportFromJson(Map<String, dynamic> json) => Viewport(
  low: Location.fromJson(json['low'] as Map<String, dynamic>),
  high: Location.fromJson(json['high'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ViewportToJson(Viewport instance) => <String, dynamic>{
  'low': instance.low,
  'high': instance.high,
};

DisplayText _$DisplayTextFromJson(Map<String, dynamic> json) => DisplayText(
  text: json['text'] as String,
  languageCode: json['languageCode'] as String,
);

Map<String, dynamic> _$DisplayTextToJson(DisplayText instance) =>
    <String, dynamic>{
      'text': instance.text,
      'languageCode': instance.languageCode,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
  name: json['name'] as String,
  relativePublishTimeDescription:
      json['relativePublishTimeDescription'] as String,
  rating: (json['rating'] as num).toInt(),
  authorAttribution: AuthorAttribution.fromJson(
    json['authorAttribution'] as Map<String, dynamic>,
  ),
  publishTime: json['publishTime'] as String,
  flagContentUri: json['flagContentUri'] as String,
  googleMapsUri: json['googleMapsUri'] as String,
);

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'name': instance.name,
  'relativePublishTimeDescription': instance.relativePublishTimeDescription,
  'rating': instance.rating,
  'authorAttribution': instance.authorAttribution,
  'publishTime': instance.publishTime,
  'flagContentUri': instance.flagContentUri,
  'googleMapsUri': instance.googleMapsUri,
};

AuthorAttribution _$AuthorAttributionFromJson(Map<String, dynamic> json) =>
    AuthorAttribution(
      displayName: json['displayName'] as String,
      uri: json['uri'] as String,
      photoUri: json['photoUri'] as String,
    );

Map<String, dynamic> _$AuthorAttributionToJson(AuthorAttribution instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'uri': instance.uri,
      'photoUri': instance.photoUri,
    };

PaymentOptions _$PaymentOptionsFromJson(Map<String, dynamic> json) =>
    PaymentOptions(
      acceptsCreditCards: json['acceptsCreditCards'] as bool,
      acceptsDebitCards: json['acceptsDebitCards'] as bool,
      acceptsCashOnly: json['acceptsCashOnly'] as bool,
    );

Map<String, dynamic> _$PaymentOptionsToJson(PaymentOptions instance) =>
    <String, dynamic>{
      'acceptsCreditCards': instance.acceptsCreditCards,
      'acceptsDebitCards': instance.acceptsDebitCards,
      'acceptsCashOnly': instance.acceptsCashOnly,
    };

ParkingOptions _$ParkingOptionsFromJson(Map<String, dynamic> json) =>
    ParkingOptions(
      freeParkingLot: json['freeParkingLot'] as bool,
      freeStreetParking: json['freeStreetParking'] as bool,
    );

Map<String, dynamic> _$ParkingOptionsToJson(ParkingOptions instance) =>
    <String, dynamic>{
      'freeParkingLot': instance.freeParkingLot,
      'freeStreetParking': instance.freeStreetParking,
    };

AccessibilityOptions _$AccessibilityOptionsFromJson(
  Map<String, dynamic> json,
) => AccessibilityOptions(
  wheelchairAccessibleRestroom: json['wheelchairAccessibleRestroom'] as bool,
);

Map<String, dynamic> _$AccessibilityOptionsToJson(
  AccessibilityOptions instance,
) => <String, dynamic>{
  'wheelchairAccessibleRestroom': instance.wheelchairAccessibleRestroom,
};

AddressDescriptor _$AddressDescriptorFromJson(Map<String, dynamic> json) =>
    AddressDescriptor(
      landmarks: (json['landmarks'] as List<dynamic>)
          .map((e) => Landmark.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddressDescriptorToJson(AddressDescriptor instance) =>
    <String, dynamic>{'landmarks': instance.landmarks};

Landmark _$LandmarkFromJson(Map<String, dynamic> json) => Landmark(
  name: json['name'] as String,
  placeId: json['placeId'] as String,
  displayName: DisplayText.fromJson(
    json['displayName'] as Map<String, dynamic>,
  ),
  types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
  spatialRelationship: json['spatialRelationship'] as String,
  straightLineDistanceMeters: (json['straightLineDistanceMeters'] as num)
      .toDouble(),
  travelDistanceMeters: (json['travelDistanceMeters'] as num).toDouble(),
);

Map<String, dynamic> _$LandmarkToJson(Landmark instance) => <String, dynamic>{
  'name': instance.name,
  'placeId': instance.placeId,
  'displayName': instance.displayName,
  'types': instance.types,
  'spatialRelationship': instance.spatialRelationship,
  'straightLineDistanceMeters': instance.straightLineDistanceMeters,
  'travelDistanceMeters': instance.travelDistanceMeters,
};

GoogleMapsLinks _$GoogleMapsLinksFromJson(Map<String, dynamic> json) =>
    GoogleMapsLinks(
      directionsUri: json['directionsUri'] as String,
      placeUri: json['placeUri'] as String,
      writeAReviewUri: json['writeAReviewUri'] as String,
      reviewsUri: json['reviewsUri'] as String,
      photosUri: json['photosUri'] as String,
    );

Map<String, dynamic> _$GoogleMapsLinksToJson(GoogleMapsLinks instance) =>
    <String, dynamic>{
      'directionsUri': instance.directionsUri,
      'placeUri': instance.placeUri,
      'writeAReviewUri': instance.writeAReviewUri,
      'reviewsUri': instance.reviewsUri,
      'photosUri': instance.photosUri,
    };

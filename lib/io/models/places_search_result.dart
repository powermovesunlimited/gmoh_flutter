import 'package:google_maps_webservice/places.dart';

class PlacesSearchDetailsResult {
  final String icon;
  final Geometry geometry;
  final String name;

  /// JSON opening_hours
  final OpeningHours openingHours;

  final List<Photo> photos;

  /// JSON place_id
  final String placeId;

  final String scope;

  /// JSON alt_ids
  final List<AlternativeId> altIds;

  /// JSON price_level
  final PriceLevel priceLevel;

  final num rating;

  final List<String> types;

  final String vicinity;

  /// JSON formatted_address
  final String formattedAddress;

  /// JSON permanently_closed
  final bool permanentlyClosed;

  final String id;

  final String reference;

  PlacesSearchDetailsResult(
      this.icon,
      this.geometry,
      this.name,
      this.openingHours,
      this.photos,
      this.placeId,
      this.scope,
      this.altIds,
      this.priceLevel,
      this.rating,
      this.types,
      this.vicinity,
      this.formattedAddress,
      this.permanentlyClosed,
      this.id,
      this.reference,
      );

  factory PlacesSearchDetailsResult.fromJson(Map json) => json != null
      ? PlacesSearchDetailsResult(
      json['icon'],
      json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null,
      json['name'],
      json['opening_hours'] != null
          ? OpeningHours.fromJson(json['opening_hours'])
          : null,
      json['photos']
          ?.map((p) => Photo.fromJson(p))
          ?.toList()
          ?.cast<Photo>(),
      json['place_id'],
      json['scope'],
      json['alt_ids']
          ?.map((a) => AlternativeId.fromJson(a))
          ?.toList()
          ?.cast<AlternativeId>(),
      json['price_level'] != null
          ? PriceLevel.values.elementAt(json['price_level'])
          : null,
      json['rating'],
      json['types'] != null ? (json['types'] as List)?.cast<String>() : [],
      json['vicinity'],
      json['formatted_address'],
      json['permanently_closed'],
      json['id'],
      json['reference'])
      : null;
}
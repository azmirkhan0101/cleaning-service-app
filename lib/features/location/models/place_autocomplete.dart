// Models for Google Places Autocomplete API response
// Minimal fields aligned with current controller usage

class PlaceAutocompleteResponse {
  final String status;
  final List<PlacePrediction> predictions;
  final String? errorMessage;

  PlaceAutocompleteResponse({
    required this.status,
    required this.predictions,
    this.errorMessage,
  });

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    final preds = (json['predictions'] as List<dynamic>? ?? [])
        .map((p) => PlacePrediction.fromJson(p as Map<String, dynamic>))
        .toList();

    return PlaceAutocompleteResponse(
      status: json['status'] as String? ?? 'UNKNOWN',
      predictions: preds,
      errorMessage: json['error_message'] as String?,
    );
  }
}

class PlacePrediction {
  final String description;
  final String placeId;
  final StructuredFormatting? structuredFormatting;

  PlacePrediction({
    required this.description,
    required this.placeId,
    this.structuredFormatting,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] as String? ?? '',
      placeId: json['place_id'] as String? ?? '',
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(
              json['structured_formatting'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}

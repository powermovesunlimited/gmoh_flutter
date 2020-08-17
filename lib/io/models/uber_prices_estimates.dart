class UberPricesEstimates {
  List<Prices> prices;

  UberPricesEstimates({this.prices});

  UberPricesEstimates.fromJson(Map<String, dynamic> json) {
    if (json['prices'] != null) {
      prices = new List<Prices>();
      json['prices'].forEach((v) {
        prices.add(new Prices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prices != null) {
      data['prices'] = this.prices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prices {
  String localizedDisplayName;
  double distance;
  String displayName;
  String productId;
  int highEstimate;
  int lowEstimate;
  int duration;
  String estimate;
  String currencyCode;

  Prices(
      {this.localizedDisplayName,
        this.distance,
        this.displayName,
        this.productId,
        this.highEstimate,
        this.lowEstimate,
        this.duration,
        this.estimate,
        this.currencyCode});

  Prices.fromJson(Map<String, dynamic> json) {
    localizedDisplayName = json['localized_display_name'];
    distance = json['distance'];
    displayName = json['display_name'];
    productId = json['product_id'];
    highEstimate = json['high_estimate'];
    lowEstimate = json['low_estimate'];
    duration = json['duration'];
    estimate = json['estimate'];
    currencyCode = json['currency_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['localized_display_name'] = this.localizedDisplayName;
    data['distance'] = this.distance;
    data['display_name'] = this.displayName;
    data['product_id'] = this.productId;
    data['high_estimate'] = this.highEstimate;
    data['low_estimate'] = this.lowEstimate;
    data['duration'] = this.duration;
    data['estimate'] = this.estimate;
    data['currency_code'] = this.currencyCode;
    return data;
  }


}

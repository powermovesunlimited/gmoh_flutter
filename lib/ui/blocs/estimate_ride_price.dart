class EstimateRidePrice {
  final double costPerMile;
  final double totalTripMiles;
  final double baseTripPrice;
  final int numberOfRiders;

  EstimateRidePrice(this.costPerMile, this.totalTripMiles, this.baseTripPrice, this.numberOfRiders);

  estimateTripPrice(){
    double estimatedTripPrice;
    estimatedTripPrice = (costPerMile*totalTripMiles)+baseTripPrice;
    return estimatedTripPrice;
  }

}


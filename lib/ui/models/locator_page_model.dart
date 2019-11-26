enum LocationPageMode { HOME_LOCATION, NEW_LOCATION, ORIGIN }

LocationPageMode getPageModeFromString(String pageMode) {
  return LocationPageMode.values
      .firstWhere((mode) => getStringFromEnum(mode) == pageMode);
}

String getStringFromEnum(LocationPageMode pageEnum){
  return pageEnum.toString().substring(pageEnum.toString().indexOf('.')+1);
}
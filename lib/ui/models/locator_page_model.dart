enum HomeLocationPageMode { HOME_LOCATION, NEW_LOCATION, ORIGIN }

HomeLocationPageMode getPageModeFromString(String pageMode) {
  return HomeLocationPageMode.values
      .firstWhere((mode) => getStringFromEnum(mode) == pageMode);
}

String getStringFromEnum(HomeLocationPageMode pageEnum){
  return pageEnum.toString().substring(pageEnum.toString().indexOf('.')+1);
}
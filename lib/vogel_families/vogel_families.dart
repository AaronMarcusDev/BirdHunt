Map<String, String> vogelFamiliesTijdelijk = {
  // "Eendachtigen (Anatidae)":"#c9cf64",
  // "Mussen (Passeridae)":"#ff834c",
  // "Vliegenvangers (Muscicapidae)":"#6556BF",
  // "Lijsters (Turdidae)":"#a8ac00",
  // "Mezen (Paridae)":"#bd2d96",
  // "Spreeuwen (Sturnidae)":"#237ad3",
  // "Vinkachtigen (Fringillidae)":"#fe56a6",
  // "Kraaien (Corvidae)":"#183b50",
  // "Zwaluwen (Hirundinidae)":"#25b2db",
  // "Rietzangers (Acrocephalidae)":"#7cb933",
  // "Boszangers (Phylloscopidae)":"#36801a",
  // "Duiven (Columbidae)":"#7f3387",
  // "Reigers (Ardeidae)":"#8468be",
  // "IJsvogels (Alcedinidae)":"#ff294d",
};

class VogelFamilie {
  final String naam;
  final String hex;

  VogelFamilie({
    required this.naam,
    required this.hex,
  });
}
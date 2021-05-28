class Place {
  String name;
  String category;
  String imgName;
  String infoText;
  String englishText;
  String funFact;
  String funFactEnglish;
  List<bool> usersVote;
  List coordinates;
  int votes;

  Place(this.name, this.category, this.imgName, this.infoText, this.englishText, this.funFact, this.funFactEnglish, this.usersVote, this.coordinates, this.votes);
}
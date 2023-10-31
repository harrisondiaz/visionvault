class Idea {
  int IdeaID;
  int ThoughtID;
  String IdeaTitle;
  String IdeaDescription;
  String IdeaImageURL;

  Idea({
    required this.IdeaID,
    required this.ThoughtID,
    required this.IdeaTitle,
    required this.IdeaDescription,
    required this.IdeaImageURL,

  });

  factory Idea.fromJson(Map<String, dynamic> json) {
    final ideaId = json['IdeaID'];
    if(ideaId == null){
      return Idea(
        IdeaID: 0,
        ThoughtID: 0,
        IdeaTitle: "",
        IdeaDescription: "",
        IdeaImageURL: "",
      );
    }else{
      return Idea(
        IdeaID: json['IdeaID'],
        ThoughtID: json['ThoughtID'],
        IdeaTitle: json['IdeaTitle'],
        IdeaDescription: json['IdeaDescription'],
        IdeaImageURL: json['IdeaImageURL'],
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'ideaID': IdeaID,
    'thoughtID': ThoughtID,
    'ideaTitle': IdeaTitle,
    'ideaDescription': IdeaDescription,
    'ideaImageURL': IdeaImageURL,
  };
}

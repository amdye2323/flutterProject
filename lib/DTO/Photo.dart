//사진의 정보를 저장하는 클래스
class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.albumId,this.id,this.title,this.url,this.thumbnailUrl});

  //사진의 정보를 포함하는 인스턴스를 생성하여 반환하는 factory 생성자
  factory Photo.fromJson(Map<String,dynamic> json){
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}
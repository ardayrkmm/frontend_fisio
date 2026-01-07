class GerakanModel {
  final String title;
  final String duration;
  final String image;
  final int? repetisi;
  final int? set;
  GerakanModel({
    required this.title,
    required this.duration,
    required this.image,
    this.repetisi,
    this.set,
  });
}

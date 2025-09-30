import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Photo Gallery"),
          backgroundColor: Color.fromARGB(204, 108, 33, 198),
        ),
        body: PhotoGalleryScreen()
      ),
    );
  }
}

class PhotoGalleryScreen extends StatefulWidget{
  const PhotoGalleryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return PhotoGalleryScreenState();
  }
}

class PhotoGalleryScreenState extends State<PhotoGalleryScreen>{
  List<Photo> photos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return Card(
          child: ListTile(
            title: Text(photo.title),
          ),
        );
      },
    );
  }

  Future<void> fetchPhotos() async{
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    if (response.statusCode == 200){
      final List data = jsonDecode(response.body);
      for (var item in data){
        Photo photo = Photo.fromJson(item);
        photos.add(photo);
      }

      loading = false;
      setState(() {});
    }
    else{
      print("Error ${response.statusCode}");
      loading = false;
      setState(() {});
    }
  }
}


class Photo{
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({required this.albumId, required this.id, required this.title, required this.thumbnailUrl, required this.url});

  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
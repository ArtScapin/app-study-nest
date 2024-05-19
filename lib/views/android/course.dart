import 'package:app_study_nest/models/course_model.dart';
import 'package:app_study_nest/views/android/courses.dart';
import 'package:app_study_nest/views/android/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../globals.dart';

class CourseScreen extends StatefulWidget {

  const CourseScreen({super.key});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Course course;
  List<Lesson> lessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/course/${courseInFocus?.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );

      if (response.statusCode == 200) {
        setState(() {
          course = Course.fromJson(jsonDecode(response.body));
          lessons = course.lessons;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load course details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo-simple.png',
              height: 40,
            ),// E
          ],
        ),
        backgroundColor: const Color(0xFF181D19),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            color: const Color(0xFF101511),
            onSelected: (String result) {
              switch (result) {
                case 'Home':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CoursesScreen()),
                  );
                  break;
                case 'Courses':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CoursesScreen()),
                  );
                  break;
                case 'Logout':
                  token = null;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Home',
                child: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Courses',
                child:  Text(
                  'Courses',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child:  Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xFF101511),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(10),
          color: const Color(0xFF101511),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      image: DecorationImage(
                        image: NetworkImage('$apiUrl/thumbnail/${course.thumbnail}'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  course.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Color(0xFF04F781),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '??',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.video_collection_rounded,
                          color: Color(0xFF04F781),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '??',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Text('@${course.user.username}',
                      style: const TextStyle(
                          color: Color(0xFF26AB70),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  course.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B6040),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    child: const Text(
                      'Let’s Go',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: lessons.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Container(
                              color: const Color(0xFF181D19),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Lessons',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final lesson = lessons[index - 1];
                          final isEvenRow = (index - 1) % 2 == 0;

                          return Container(
                            color: isEvenRow ? const Color(0xFF393E3A) : const Color(0xFF181D19),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      lesson.name,
                                      style: const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

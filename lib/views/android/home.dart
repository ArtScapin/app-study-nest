import 'package:app_study_nest/models/course_model.dart';
import 'package:app_study_nest/views/android/course.dart';
import 'package:app_study_nest/views/android/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../globals.dart';
import 'courses.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Course> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    courseInFocus = null;
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/course'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          courses = data.map((json) => Course.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error to load Courses');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Courses',
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 50),
              Image.asset(
                'assets/logo-simple.png',
                height: 40,
              ),// E
            ],
          ),
          backgroundColor: const Color(0xFF181D19),
          actions: <Widget>[
            PopupMenuButton<String>(
              color: const Color(0xFF101511),
              onSelected: (String result) {
                switch (result) {
                  case 'Home':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
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
            : ListView(
          children: [
            ActivityGraph(),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Popular Courses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...courses.map((course) => InkWell(
              onTap: () {
                courseInFocus = course;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CourseScreen()
                ));
              },
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
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.star,
                                color: Color(0xFF04F781),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                '5.0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Icon(
                                Icons.video_collection_rounded,
                                color: Color(0xFF04F781),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${course.lessons.length}',
                                style: const TextStyle(
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
                    ],
                  ),
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const HomeScreen());
}

class ActivityGraph extends StatelessWidget {
  final List<int> activityData = [0, 2, 3, 2, 0, 1, 5]; // Dados de exemplo

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF101511),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Activity Graph',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(activityData.length, (index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: activityData[index] * 10.0, // Altura da barra
                    width: 20,
                    decoration: BoxDecoration(
                      color: index == 6 ? const Color(0xFF04F781) : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    [ 'S', 'S', 'M', 'T', 'W', 'T', 'F'][index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}


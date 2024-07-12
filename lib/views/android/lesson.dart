import 'dart:convert';

import 'package:app_study_nest/views/android/courses.dart';
import 'package:app_study_nest/views/android/home.dart';
import 'package:app_study_nest/views/android/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../globals.dart';
import '../../models/course_model.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late YoutubePlayerController _youtubeController;
  bool isFullScreen = false;
  bool isLoading = true;
  TextEditingController commentController = TextEditingController(); // Controlador para o campo de comentário
  bool isTyping = false; // Flag para indicar se o usuário está digitando
  bool isTextFieldFocused = false; // Flag para indicar se o campo de texto está focado

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(lessonInFocus!.video)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    _youtubeController.addListener(() {
      if (_youtubeController.value.isFullScreen != isFullScreen) {
        setState(() {
          isFullScreen = _youtubeController.value.isFullScreen;
        });
      }
    });

    fetchLesson();
  }

  Future<void> fetchLesson() async {
    final response = await http.get(
      Uri.parse('$apiUrl/lesson/${courseInFocus?.id}/${lessonInFocus?.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        lessonInFocus = Lesson.fromJson(jsonDecode(response.body));
        isLoading = false;
      });
    }
  }

  Future<void> postComment(String text) async {
    final response = await http.post(
      Uri.parse('$apiUrl/comment/${lessonInFocus?.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      // Atualiza os comentários após o envio bem-sucedido
      fetchLesson();
      // Limpa o campo de comentário
      commentController.clear();
    } else {
      // Trata erros de envio de comentário
      // Exemplo: exibir uma mensagem de erro ao usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to post comment'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo-simple.png',
              height: 40,
            ), // E
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
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()),
                  );
                  break;
                case 'Courses':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CoursesScreen()),
                  );
                  break;
                case 'Logout':
                  token = null;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Home',
                child: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Courses',
                child: Text(
                  'Courses',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xFF101511),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _youtubeController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
        builder: (context, player) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                player,
                if (!isFullScreen) ...[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lessonInFocus!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lessonInFocus!.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFF181D19),
                            ),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: courseInFocus!.lessons.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Lessons',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }

                                final lesson = courseInFocus!.lessons[index -
                                    1];
                                final isEvenRow = (index - 1) % 2 == 0;

                                return InkWell(
                                  onTap: () {
                                    lessonInFocus = lesson;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (
                                          context) => const LessonScreen()),
                                    );
                                  },
                                  child: Container(
                                    color: isEvenRow
                                        ? const Color(0xFF393E3A)
                                        : const Color(0xFF181D19),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      lesson.name,
                                      style: const TextStyle(
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      isTextFieldFocused = hasFocus;
                                    });
                                  },
                                  child: TextField(
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      hintText: 'Write a comment...',
                                      filled: true,
                                      fillColor: isTextFieldFocused ||
                                          commentController.text.isNotEmpty
                                          ? Colors.white
                                          : const Color(0xFF393E3A),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        isTyping = value.isNotEmpty;
                                      });
                                    },
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty) {
                                        postComment(value);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              if (isTyping || commentController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: () {
                                    String text = commentController.text.trim();
                                    if (text.isNotEmpty) {
                                      postComment(text);
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: lessonInFocus?.comments.length ?? 0,
                              itemBuilder: (context, index) {
                                final comment = lessonInFocus!.comments[index];
                                String initial =
                                comment.user.username.substring(0, 1)
                                    .toUpperCase();

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF393E3A),
                                    child: Text(
                                      initial,
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    comment.user.username,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    comment.text,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
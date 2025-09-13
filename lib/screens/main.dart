import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes/screens/clinicalnotes/main.dart';
import 'package:notes/screens/constants.dart';
import 'package:notes/screens/flashcardnotes/main.dart';
import 'package:notes/screens/logo.dart';
import 'package:notes/screens/mcqnotes/main.dart';
import 'package:notes/screens/videonotes/main.dart';
import 'package:notes/widgets/explore_courses/app_bar.dart';

class NotesScreen extends StatefulWidget {
  final String className;
  const NotesScreen({super.key, required this.className});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final bool _isLoading = false;
  int _VideoTotalCount = 0;
  int _VideoUniqueCount = 0;
  int _mcqCount = 0;
  int _mcqSubjectCount = 0;
  final int _clinicalCaseCount = 0;
  final int _flashcardTotalCount = 0;
  final int _flashcardUniqueCount = 0;
  int _clinicalUniqueCount = 0;
  int _clinicalTotalCount = 0;
  int _flashCardUniqueCount = 0;
  int _flashCardTotalCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchVideoStats();
    _fetchMcqStats();
    _fetchClinicalCases();
    _fetchFlashCards();
  }

  Future<void> _fetchVideoStats() async {
    try {
      final response = await http.get(Uri.parse("${API}videos/"));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        int titleCount = data.length;

        int VideoCount = data
            .map((video) => video['subject_name'])
            .toSet()
            .length;

        int FullCount = data.length;

        var count = 0;

        setState(() {
          _VideoUniqueCount = VideoCount;
          _VideoTotalCount = FullCount;
        });
      } else {
        print("Failed to load data. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching MCQ stats: $e");
    }
  }

  Future<void> _fetchMcqStats() async {
    try {
      final response = await http.get(Uri.parse("${API}mcqs/"));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        int titleCount = data.length;

        int uniquesubjectCount = data
            .map((mcq) => mcq['subject']?['name'])
            .where((name) => name != null)
            .toSet()
            .length;

        int totaluniqueCount = data.length;

        var count = 0;

        setState(() {
          _mcqCount = uniquesubjectCount;
          _mcqSubjectCount = totaluniqueCount;
        });
      } else {
        print("Failed to load data. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching MCQ stats: $e");
    }
  }

  Future<void> _fetchClinicalCases() async {
    try {
      final response = await http.get(Uri.parse("${API}clinical-cases/"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        int uniquesubjectCount = data
            .map((mcq) => mcq['subject'])
            .toSet()
            .length;

        int totalCount = data.length;

        setState(() {
          _clinicalUniqueCount = uniquesubjectCount;
          _clinicalTotalCount = totalCount;
        });
      }
    } catch (e) {
      print("Error fetching Clinical Cases: $e");
    }
  }

  Future<void> _fetchFlashCards() async {
    try {
      final response = await http.get(Uri.parse("${API}flashcards/"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        int uniqueCount = data.map((mcq) => mcq['subject_name']).toSet().length;

        int totalCount = data.length;

        setState(() {
          _flashCardUniqueCount = uniqueCount;
          _flashCardTotalCount = totalCount;
        });
      }
    } catch (e) {
      print("Error fetching Flashcards: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF008080);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: "YourCustomFont", // add your font here
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomLogoAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Video Card
                NoteCard(
                  title: 'Video',
                  leftSubtitle: _isLoading
                      ? 'Loading...'
                      : '$_VideoUniqueCount Topics',
                  rightSubtitle: _isLoading ? '' : '$_VideoTotalCount Videos',
                  navigateTo: const VideoSubjectScreen(),
                ),

                // MCQ Card
                NoteCard(
                  title: 'MCQs',
                  leftSubtitle: _isLoading
                      ? 'Loading...'
                      : '$_mcqSubjectCount Topics',
                  rightSubtitle: _isLoading ? '' : '$_mcqCount MCQs',
                  navigateTo: const McqSubjectsScreen(),
                ),

                // Clinical Case Card
                NoteCard(
                  title: 'Clinical Case',
                  leftSubtitle: _isLoading
                      ? 'Loading...'
                      : '$_clinicalUniqueCount Topics',
                  rightSubtitle: _isLoading
                      ? ''
                      : '$_clinicalTotalCount Clinical Cases',
                  navigateTo: const ClinicalCasesScreen(),
                ),

                // Flash Card
                NoteCard(
                  title: 'Flash Card',
                  leftSubtitle: _isLoading
                      ? 'Loading...'
                      : '$_flashCardUniqueCount Topics',
                  rightSubtitle: _isLoading
                      ? ''
                      : '$_flashCardTotalCount Flash Cards',
                  navigateTo: const FlashcardsScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String leftSubtitle;
  final String rightSubtitle;
  final Widget navigateTo;

  const NoteCard({
    super.key,
    required this.title,
    required this.leftSubtitle,
    required this.rightSubtitle,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF008080);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            height: 160,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.more_vert),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        leftSubtitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        rightSubtitle,
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 20,
                  width: double.infinity,
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
